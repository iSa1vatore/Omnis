import 'dart:async';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:common/utils/date_time_utils.dart';
import 'package:common/utils/random_utils.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/exceptions/failure.dart';
import 'package:domain/exceptions/permissions_failure.dart';
import 'package:domain/model/audio_item.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/message.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/message_attachment/message_attachment_photo.dart';
import 'package:domain/model/message_attachment/message_attachment_type.dart';
import 'package:domain/model/message_attachment/message_attachment_voice.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/cached_files_repository.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services/audio_service/audio_service.dart';
import 'package:services/voice_recorder_service/voice_recorder_service.dart';

import '../utils/audio_waveform_utils.dart';

part 'conversation_bloc.freezed.dart';

@injectable
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final UsersRepository usersRepository;
  final ConnectionsRepository connectionsRepository;
  final MessagesRepository messagesRepository;
  final CachedFilesRepository cachedFilesRepository;

  final ApiService apiService;

  final VoiceRecorderService voiceRecorderService;
  final AudioService audioService;

  int lastTimeSendActivity = 0;

  List<double> voiceRecordWaveData = [];
  Timer? voiceRecordActivitySetTimer;

  ConversationBloc(
    this.usersRepository,
    this.connectionsRepository,
    this.messagesRepository,
    this.apiService,
    this.voiceRecorderService,
    this.audioService,
    this.cachedFilesRepository,
  ) : super(const ConversationState()) {
    on<SelectConversation>((event, emit) async {
      emit(const ConversationState().copyWith(user: event.user));

      var currentUser = await usersRepository.me();

      currentUser.fold(
        (error) => emit(state.copyWith(error: error, isLoading: false)),
        (currentUser) => emit(state.copyWith(currentUser: currentUser)),
      );

      if (state.error != null) return;

      var findMessages = await messagesRepository.findMessagesByPeerId(
        peerId: event.user.id,
        limit: 50,
        offset: 0,
      );

      findMessages.fold(
        (error) => emit(state.copyWith(error: error, isLoading: false)),
        (messages) => emit(state.copyWith(
          messages: messages,
          isLoading: false,
        )),
      );

      if (state.error != null) return;

      var findConnection = await connectionsRepository.findByUserId(
        event.user.id,
      );

      findConnection.fold(
        (error) => emit(state.copyWith(error: error, isLoading: false)),
        (connection) => emit(state.copyWith(connection: connection)),
      );

      if (state.error != null) return;

      usersRepository
          .fetchFromRemote(state.connection!)
          .then((remoteUser) => remoteUser.fold(
                (error) {
                  print("user offline");
                },
                (user) {
                  print("user info");
                },
              ));

      await emit.forEach<Message>(
        messagesRepository
            .observeMessages()
            .where((event) => event.peerId == state.user!.id),
        onData: (message) {
          var messageIndex = state.messages.indexWhere(
            (m) => m.id == message.id,
          );

          if (messageIndex != -1) {
            var newMessagesList = [...state.messages];

            newMessagesList[messageIndex] = message;

            return state.copyWith(messages: newMessagesList);
          }

          var messages = [
            ...[message],
            ...state.messages
          ];

          return state.copyWith(messages: messages);
        },
      );
    }, transformer: restartable());

    on<SendMessage>((event, emit) async {
      lastTimeSendActivity = 0;

      messagesRepository.send(
        state.connection!,
        text: event.text.isEmpty ? null : event.text,
        attachments: state.attachments,
      );

      emit(state.copyWith(attachments: []));
    });

    on<SetActivity>((event, emit) {
      if (DateTimeUtils.currentTimestamp - lastTimeSendActivity > 5) {
        lastTimeSendActivity = DateTimeUtils.currentTimestamp;

        messagesRepository.setActivityFor(state.connection!, type: event.type);
      }
    }, transformer: droppable());

    on<SetPermanentVoiceRecording>(
      (event, emit) => emit(state.copyWith(isPermanentVoiceRecording: true)),
    );

    on<StartVoiceRecording>((event, emit) async {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.microphone,
      ].request();

      if (permissions[Permission.microphone]!.isDenied) {
        emit(state.copyWith(error: const PermissionsFailure.isDenied()));

        return;
      } else if (permissions[Permission.microphone]!.isPermanentlyDenied) {
        emit(state.copyWith(
          error: const PermissionsFailure.isPermanentlyDenied(),
        ));

        return;
      }

      await voiceRecorderService.start();

      messagesRepository.setActivityFor(
        state.connection!,
        type: MessageActivityType.audiomessage,
      );

      voiceRecordActivitySetTimer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) {
          if (!state.isVoiceRecordingPaused) {
            messagesRepository.setActivityFor(
              state.connection!,
              type: MessageActivityType.audiomessage,
            );
          }
        },
      );

      emit(state.copyWith(
        isVoiceRecording: true,
      ));
    });

    on<StopVoiceRecording>((event, emit) async {
      voiceRecordActivitySetTimer?.cancel();

      String? filePath = await voiceRecorderService.stop();

      emit(state.copyWith(
        isVoiceRecording: false,
        isPermanentVoiceRecording: false,
      ));

      if (!event.send) return;

      var fileId = basenameWithoutExtension(filePath!);

      var voiceAttachment = MessageAttachment(
        type: MessageAttachmentType.voice,
        voice: MessageAttachmentVoice(
          fileId: fileId,
          duration: state.recordDuration,
          waveform: voiceRecordWaveData,
        ),
      );

      lastTimeSendActivity = 0;

      await messagesRepository.send(
        state.connection!,
        attachments: [voiceAttachment],
      );

      voiceRecordWaveData = [];

      await messagesRepository.uploadAttachment(
        state.connection!,
        fileId: fileId,
        filePath: filePath,
        fileName: "voice_message.m4a",
        fileType: "voice",
      );
    });

    on<PauseVoiceRecording>((event, emit) async {
      await voiceRecorderService.pause();

      emit(state.copyWith(
        isVoiceRecordingPaused: true,
      ));
    });

    on<ResumeVoiceRecording>((event, emit) async {
      await voiceRecorderService.resume();

      emit(state.copyWith(
        isVoiceRecordingPaused: false,
      ));
    });

    on<SelectReplyMessage>(
      (event, emit) => emit(state.copyWith(replyMessage: event.message)),
    );

    on<LoadMoreMessages>((event, emit) async {
      var findMessages = await messagesRepository.findMessagesByPeerId(
        peerId: state.user!.id,
        limit: 50,
        offset: state.messages.length,
      );

      findMessages.fold(
        (error) => emit(state.copyWith(error: error, isLoading: false)),
        (messages) => emit(state.copyWith(
          messages: [...state.messages, ...messages],
          isLoading: false,
        )),
      );
    });

    on<ToggleShowingAttachmentsPicker>(
      (event, emit) => emit(state.copyWith(
        attachmentsPickerIsShown: !state.attachmentsPickerIsShown,
      )),
    );

    on<SelectAttachments>((event, emit) async {
      if (event.type == 1) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );

        if (result == null) return;

        List<MessageAttachment> attachments = [...state.attachments];

        for (var platformFile in result.files) {
          var fileDetails = platformFile;

          if (fileDetails.path == null) continue;

          var fileId = RandomUtils.generateString(16);

          var imageSize = ImageSizeGetter.getSize(FileInput(File(
            fileDetails.path!,
          )));

          attachments.add(MessageAttachment(
            type: MessageAttachmentType.photo,
            photo: MessageAttachmentPhoto(
              fileId: fileId,
              name: fileDetails.name,
              filePath: fileDetails.path,
              width: imageSize.width,
              height: imageSize.height,
            ),
          ));
        }

        emit(state.copyWith(
          attachments: attachments,
          attachmentsPickerIsShown: false,
        ));
      }

      if (event.type == 2) {}
    });

    on<PlayVoiceMessage>((event, emit) async {
      var file = await cachedFilesRepository
          .findByFileId(event.voice.fileId)
          .then((file) => file.fold((error) => null, (file) => file));

      if (file == null) return;

      var message = state.messages.firstWhere(
        (message) => message.id == event.messageId,
      );

      String author;

      if (message.fromId == 1) {
        author = state.currentUser!.name;
      } else {
        author = state.user!.name;
      }

      audioService.play(AudioItem(
        path: file.path,
        author: author,
        fileId: event.voice.fileId,
      ));
    });

    on<RemoveAttachment>((event, emit) {
      var newAttachmentsList = [...state.attachments];
      newAttachmentsList.removeAt(event.index);

      emit(state.copyWith(attachments: newAttachmentsList));
    });
  }

  Stream<List<double>> voiceAudioAmplitudeStream() async* {
    while (state.isVoiceRecording && !state.isVoiceRecordingPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
      final ap = await voiceRecorderService.getAmplitude();

      voiceRecordWaveData.add(AudioWaveFormUtils.normalize(ap.current));

      yield voiceRecordWaveData;
    }
  }
}

@freezed
class ConversationEvent with _$ConversationEvent {
  const factory ConversationEvent.selectConversation(
    User user,
  ) = SelectConversation;

  const factory ConversationEvent.sendMessage(
    String text,
  ) = SendMessage;

  const factory ConversationEvent.setActivity(
    MessageActivityType type,
  ) = SetActivity;

  const factory ConversationEvent.startVoiceRecording() = StartVoiceRecording;

  const factory ConversationEvent.setPermanentVoiceRecording() =
      SetPermanentVoiceRecording;

  const factory ConversationEvent.pauseVoiceRecording() = PauseVoiceRecording;

  const factory ConversationEvent.resumeVoiceRecording() = ResumeVoiceRecording;

  const factory ConversationEvent.stopVoiceRecording({
    @Default(true) bool send,
  }) = StopVoiceRecording;

  const factory ConversationEvent.selectReplyMessage({
    required Message message,
  }) = SelectReplyMessage;

  const factory ConversationEvent.loadMoreMessages() = LoadMoreMessages;

  const factory ConversationEvent.toggleShowingAttachmentsPicker() =
      ToggleShowingAttachmentsPicker;

  const factory ConversationEvent.playVoiceMessage({
    required MessageAttachmentVoice voice,
    required int messageId,
  }) = PlayVoiceMessage;

  const factory ConversationEvent.selectAttachments({
    required int type,
  }) = SelectAttachments;

  const factory ConversationEvent.removeAttachment({
    required int index,
  }) = RemoveAttachment;
}

@freezed
class ConversationState with _$ConversationState {
  const ConversationState._();

  const factory ConversationState({
    User? user,
    User? currentUser,
    Connection? connection,
    @Default([]) List<Message> messages,
    Message? replyMessage,
    @Default(true) bool isLoading,
    @Default(false) bool attachmentsPickerIsShown,
    @Default(false) bool isVoiceRecording,
    @Default(false) bool isPermanentVoiceRecording,
    @Default(false) bool isVoiceRecordingPaused,
    @Default([]) List<MessageAttachment> attachments,
    @Default(0) int recordDuration,
    Failure? error,
  }) = Initial;
}

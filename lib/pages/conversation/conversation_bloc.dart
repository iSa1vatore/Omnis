import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:common/utils/date_time_utils.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/message.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services/voice_recorder_service/voice_recorder_service.dart';

import '../../utils/audio_waveform_utils.dart';

part 'conversation_bloc.freezed.dart';

@injectable
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final UsersRepository usersRepository;
  final ConnectionsRepository connectionsRepository;
  final MessagesRepository messagesRepository;

  final ApiService apiService;

  final VoiceRecorderService voiceRecorderService;

  int lastTimeSendActivity = 0;
  List<double> voiceAudioWaveData = [];

  ConversationBloc(
    this.usersRepository,
    this.connectionsRepository,
    this.messagesRepository,
    this.apiService,
    this.voiceRecorderService,
  ) : super(const ConversationState()) {
    on<SelectConversation>((event, emit) async {
      emit(state.copyWith(user: event.user, isLoading: true));

      var connection = await connectionsRepository.findByUserId(event.user.id);

      connection.result(
        onSuccess: (connection) {
          emit(state.copyWith(connection: connection));
        },
        onError: (error) {
          print("GET CONNECTION ERROR");
        },
      );

      var messages = await messagesRepository.findMessagesByPeerId(
        event.user.id,
      );

      messages.result(
        onSuccess: (messages) {
          emit(state.copyWith(messages: messages));
        },
        onError: (e) {
          print("GET MESSAGES ERROR");
        },
      );

      emit(state.copyWith(isLoading: false));

      await emit.forEach<Message>(
        messagesRepository
            .observeNewMessage()
            .where((event) => event.peerId == state.user!.id),
        onData: (message) {
          var messages = [
            ...[message],
            ...state.messages
          ];

          return state.copyWith(messages: messages);
        },
      );
    }, transformer: droppable());

    on<SendMessage>((event, emit) async {
      var sendMessage = await messagesRepository.send(
        connection: state.connection!,
        text: event.text,
      );

      sendMessage.result(
        onSuccess: (messageId) {
          var newMessagesList = [...state.messages];

          var messageIndex = newMessagesList.indexWhere(
            (m) => m.id == messageId,
          );

          var updatedMessage = newMessagesList[messageIndex].copyWith(
            sendState: 0,
          );

          newMessagesList[messageIndex] = updatedMessage;

          emit(state.copyWith(messages: newMessagesList));
        },
        onError: (e) {
          print("SEND MESSAGE ERROR");
        },
      );
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
        Permission.storage,
        Permission.microphone,
      ].request();

      bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
          permissions[Permission.microphone]!.isGranted;

      if (!permissionsGranted) {
        print("error");
        return;
      }

      await voiceRecorderService.start();

      emit(state.copyWith(isVoiceRecording: true));
    });

    on<StopVoiceRecording>((event, emit) async {
      String? path = await voiceRecorderService.stop();

      print('Output path $path');

      voiceAudioWaveData = [];

      emit(state.copyWith(
        isVoiceRecording: false,
        isPermanentVoiceRecording: false,
      ));
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
  }

  Stream<List<double>> voiceAudioAmplitudeStream() async* {
    while (state.isVoiceRecording && !state.isVoiceRecordingPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
      final ap = await voiceRecorderService.getAmplitude();

      voiceAudioWaveData.add(AudioWaveFormUtils.normalize(ap.current));

      yield voiceAudioWaveData;
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
}

@freezed
class ConversationState with _$ConversationState {
  const ConversationState._();

  const factory ConversationState({
    User? user,
    Connection? connection,
    @Default([]) List<Message> messages,
    Message? replyMessage,
    @Default(true) bool isLoading,
    @Default(false) bool isVoiceRecording,
    @Default(false) bool isPermanentVoiceRecording,
    @Default(false) bool isVoiceRecordingPaused,
  }) = Initial;
}

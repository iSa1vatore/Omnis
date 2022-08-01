import 'package:common/logs.dart';
import 'package:common/utils/network_utils.dart';
import 'package:data/mapper/attachment_mapper.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:data/sources/remote/dto/attachment_dto.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/message.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:server/enum/server_event_type.dart';
import 'package:server/models/server_event.dart';
import 'package:services/background_service/background_service.dart';
import 'package:services/notifications_service/notifications_service.dart';

import '../background_main.dart';

part 'main_bloc.freezed.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  final ApiService apiService;
  final MessagesRepository messagesRepository;
  final UsersRepository usersRepository;
  final NotificationsService notificationsService;

  MainBloc(
    this.apiService,
    this.messagesRepository,
    this.usersRepository,
    this.notificationsService,
  ) : super(const MainState()) {
    on<RunBackgroundService>((event, emit) async {
      var address = await NetworkUtils.getWifiIP();
      var port = 14080;

      BackgroundService.run(backgroundMain, onReady: () async {
        BackgroundService.runServer(
          address: address,
          port: port,
          userGlobalId: event.user.globalId,
        );
      });

      apiService.setSender(
        address: address,
        port: port,
        userGlobalId: event.user.globalId,
      );

      BackgroundService.onServerEvent((event) {
        if (event == null) return;

        var serverEvent = ServerEvent.fromMap(event);

        var type = serverEvent.type;
        var data = serverEvent.data;

        switch (type) {
          case ServerEventType.newMessage:
            List<dynamic>? attachmentsList = data["attachments"];
            List<MessageAttachment>? attachments;

            attachments = attachmentsList
                ?.map((e) => MessageAttachmentDto.fromJson(e).toAttachment())
                .cast<MessageAttachment>()
                .toList();

            messagesRepository.notifyAboutMessage(Message(
              id: data["id"],
              globalId: data["globalId"],
              time: data["time"],
              peerId: data["peerId"],
              fromId: data["fromId"],
              sendState: data["sendState"],
              text: data["text"],
              attachments: attachments,
            ));

            messagesRepository.removeMessageActivityBy(fromId: data["fromId"]);
            break;
          case ServerEventType.setMessagesActivity:
            MessageActivityType activityType;

            if (data["type"] == "audiomessage") {
              activityType = MessageActivityType.audiomessage;
            } else {
              activityType = MessageActivityType.typing;
            }

            messagesRepository.notifyAboutNewActivity(MessageActivity(
              peerId: data["peerId"],
              type: activityType,
              time: data["time"],
            ));
            break;
        }
      });

      notificationsService.configure((p0) {
        Log.e("payload: $p0");
      });
    });

    on<UpdateAppLivecycleState>(
      (event, emit) => BackgroundService.updateAppLifecycleState(
        isPaused: event.isPaused,
      ),
    );
  }
}

@freezed
class MainEvent with _$MainEvent {
  const factory MainEvent.runBackgroundService({
    required User user,
  }) = RunBackgroundService;

  const factory MainEvent.updateAppLivecycleState({
    required bool isPaused,
  }) = UpdateAppLivecycleState;
}

@freezed
class MainState with _$MainState {
  const MainState._();

  const factory MainState({
    @Default(false) bool serverIsStarted,
  }) = Initial;
}

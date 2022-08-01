import 'dart:math';
import 'dart:ui';

import 'package:common/logs.dart';
import 'package:common/utils/encryption_utils.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:domain/repository/private_keys_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:server/enum/server_event_type.dart';
import 'package:server/models/events/new_message.dart';
import 'package:server/server.dart';
import 'package:services/notifications_service/notifications_service.dart';

import 'di/di.dart';

void backgroundMain(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await DI.instance.setupInjection();

  service.invoke('ready');
  Log.i("backgroundMain is ready");

  var showNotifications = true;

  ApiService apiService = DI.resolve();
  PrivateKeysRepository privateKeysRepository = DI.resolve();
  NotificationsService notificationsService = DI.resolve();
  UsersRepository usersRepository = DI.resolve();
  NewServer server = DI.resolve();

  service.on('new_app_lifecycle_state').listen((event) {
    showNotifications = event?["is_paused"];
  });

  service.on('run_server').listen((event) async {
    Log.i("try to start server");

    var address = event!["address"];
    var port = event["port"];
    var userGlobalId = event["user_global_id"];

    var stringKey = await privateKeysRepository.fetchEncryptionPrivateKey();

    try {
      await server.start(
        address: address,
        port: port,
        rsaPrivateKey: EncryptionUtils.rsaPrivateKeyFromString(stringKey!),
      );

      Log.i("server is started");

      apiService.setSender(
        address: address,
        port: port,
        userGlobalId: userGlobalId,
      );
    } catch (e) {
      Log.e("server started error");
    }
  });

  server.events.stream.listen((event) async {
    service.invoke('new_server_event', event.toMap());

    switch (event.type) {
      case ServerEventType.newMessage:
        Log.i("new server event: new message");

        if (!showNotifications) return;

        var data = event.data as SENewMessage;
        var user = await usersRepository.findByID(data.fromId);

        if (user != null) {
          String body = "";

          if (data.text != null) body = data.text!;

          notificationsService.show(
            id: data.id,
            title: user.name,
            body: body,
            payload: data.peerId.toString(),
          );
        }
        break;
    }
  });

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Receiving messages",
      content: "Users on the network:  ${Random().nextInt(10)}",
    );
  }
}

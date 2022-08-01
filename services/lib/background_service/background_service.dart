import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static final service = FlutterBackgroundService();

  static Future<void> run(
    dynamic Function(ServiceInstance) backgroundTask, {
    required void Function() onReady,
  }) async {
    service.on("ready").listen((event) => onReady());

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundTask,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: backgroundTask,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  static onServerEvent(void Function(Map<String, dynamic>?)? callback) {
    service.on("new_server_event").listen(callback);
  }

  static updateAppLifecycleState({required bool isPaused}) {
    service.invoke("new_app_lifecycle_state", {
      "is_paused": isPaused,
    });
  }

  static runServer({
    required String address,
    required int port,
    required String userGlobalId,
  }) =>
      service.invoke("run_server", {
        "address": address,
        "port": port,
        "user_global_id": userGlobalId,
      });

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();

    return true;
  }
}

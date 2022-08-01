import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:services/notifications_service/notifications_service.dart';

@Singleton(as: NotificationsService)
class NotificationsServiceImpl extends NotificationsService {
  final FlutterLocalNotificationsPlugin localNotifications;

  NotificationsServiceImpl(this.localNotifications);

  final androidNewMessageDetails = const AndroidNotificationDetails(
    'messages',
    'Messages',
    channelDescription: 'New message notifications',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  final iosNewMessageDetails = const IOSNotificationDetails(
    presentSound: true,
    threadIdentifier: "messages",
  );

  @override
  Future<void> configure(void Function(String?) onSelectNotification) async =>
      await localNotifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          ),
          macOS: MacOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          ),
        ),
        onSelectNotification: onSelectNotification,
      );

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNewMessageDetails,
      iOS: iosNewMessageDetails,
    );

    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

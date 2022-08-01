abstract class NotificationsService {
  Future<void> configure(void Function(String?) onSelectNotification);
  
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String payload,
  });
}

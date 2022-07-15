import 'package:domain/model/message_activity.dart';

import '../enum/message_activity.dart';
import '../model/connection.dart';
import '../model/message.dart';
import '../util/resource.dart';

abstract class MessagesRepository {
  Future<Resource<List<Message>>> findMessagesByPeerId(int peerId);

  Future<Resource<int>> add({
    required String globalId,
    required String text,
    required int peerId,
    required int fromId,
  });

  Future<Resource<int>> send({
    required Connection connection,
    required String text,
  });

  Future<Resource<int>> setActivityFor(
    Connection connection, {
    required MessageActivityType type,
  });

  void setActivity(MessageActivity messageActivity);

  Stream<Message> observeNewMessage();

  Stream<List<MessageActivity>> observeMessageActivities();
}

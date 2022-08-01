import 'package:dartz/dartz.dart';
import 'package:domain/model/message_activity.dart';

import '../enum/message_activity.dart';
import '../exceptions/messages_failure.dart';
import '../model/connection.dart';
import '../model/message.dart';
import '../model/message_attachment/message_attachment.dart';

abstract class MessagesRepository {
  Future<Either<MessagesFailure, List<Message>>> findMessagesByPeerId({
    required int peerId,
    required int limit,
    required int offset,
  });

  Future<Either<MessagesFailure, Message>> findMessageById(int id);

  Future<Message> add({
    required String globalId,
    String? text,
    required int peerId,
    required int fromId,
    List<MessageAttachment>? attachments,
  });

  Future<Message> send(
    Connection connection, {
    String? text,
    List<MessageAttachment>? attachments,
  });

  Future<Either<MessagesFailure, Unit>> uploadAttachment(
    Connection connection, {
    required String fileId,
    required String filePath,
    required String fileName,
    required String fileType,
  });

  Future<Either<MessagesFailure, Unit>> setActivityFor(
    Connection connection, {
    required MessageActivityType type,
  });

  Future<Either<MessagesFailure, int>> fetchUnreadCount({
    required int peerId,
    required int lastReadId,
  });

  void removeMessageActivityBy({
    required int fromId,
  });

  void notifyAboutMessage(Message message);

  void notifyAboutNewActivity(MessageActivity messageActivity);

  Stream<Message> observeMessages();

  Stream<List<MessageActivity>> observeMessageActivities();
}

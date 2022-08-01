import 'dart:async';

import 'package:common/utils/date_time_utils.dart';
import 'package:common/utils/random_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:data/mapper/attachment_mapper.dart';
import 'package:data/mapper/messages_mapper.dart';
import 'package:data/sources/local/db/app_database.dart';
import 'package:data/sources/local/db/dao/messages_dao.dart';
import 'package:data/sources/local/db/entity/message_entity.dart';
import 'package:dio/dio.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/exceptions/api_failure.dart';
import 'package:domain/exceptions/messages_failure.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/message.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/message_attachment/message_attachment_type.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../sources/remote/api_service.dart';

@Singleton(as: MessagesRepository)
class MessagesRepositoryImpl extends MessagesRepository {
  final AppDatabase db;
  final ApiService apiService;

  late MessagesDao _dao;

  final _messagesStream = BehaviorSubject<Message>();
  final _messageActivityStream = BehaviorSubject<List<MessageActivity>>.seeded(
    [],
  );

  MessagesRepositoryImpl(this.db,
      this.apiService,) {
    _dao = db.messagesDao;

    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      removingOldMessageActivities();
    });
  }

  void removingOldMessageActivities() {
    var messageActivities = [..._messageActivityStream.value];

    for (var messageActivity in [...messageActivities]) {
      if (DateTimeUtils.currentTimestamp - messageActivity.time > 5) {
        messageActivities.remove(messageActivity);
      }
    }

    _messageActivityStream.value = messageActivities;
  }

  @override
  void removeMessageActivityBy({required int fromId}) {
    var messageActivities = _messageActivityStream.value
        .where(
          (i) => i.peerId != fromId,
    )
        .toList();

    _messageActivityStream.value = messageActivities;
  }

  @override
  Future<Either<MessagesFailure, List<Message>>> findMessagesByPeerId({
    required int peerId,
    required int limit,
    required int offset,
  }) async {
    try {
      var messages = await _dao.findMessagesByPeerId(peerId, limit, offset);

      return Right(messages.map((m) => m.toMessage()).toList());
    } catch (_) {
      return const Left(MessagesFailure.dbError());
    }
  }

  @override
  Stream<Message> observeMessages() => _messagesStream.asBroadcastStream();

  @override
  Stream<List<MessageActivity>> observeMessageActivities() =>
      _messageActivityStream.asBroadcastStream();

  @override
  Future<Message> send(Connection connection, {
    String? text,
    List<MessageAttachment>? attachments,
  }) async {
    var globalId = RandomUtils.generateString(16);

    var addMessage = await add(
      globalId: globalId,
      text: text,
      peerId: connection.userId,
      fromId: 1,
      attachments: attachments,
    );

    notifyAboutMessage(addMessage);

    Message updatedMessage;

    try {
      for (MessageAttachment attachment in attachments ?? []) {
        if (attachment.type == MessageAttachmentType.photo) {
          var photoDetails = attachment.photo!;

          await uploadAttachment(
            connection,
            fileId: photoDetails.fileId,
            filePath: photoDetails.filePath!,
            fileName: photoDetails.name,
            fileType: "photo",
          );
        }
      }

      await apiService.messagesSend(
        connection,
        text: text,
        globalId: globalId,
        attachments: attachments?.map((a) => a.toDto().toJson()).toList(),
      );

      updatedMessage = addMessage.copyWith(sendState: 0);
    } on DioError catch (_) {
      updatedMessage = addMessage.copyWith(sendState: -2);
    } on ApiFailure catch (_) {
      updatedMessage = addMessage.copyWith(sendState: -1);
    }

    _dao.updateMessage(updatedMessage.toMessageEntity());

    notifyAboutMessage(updatedMessage);

    return addMessage;
  }

  @override
  Future<Message> add({
    required String globalId,
    String? text,
    required int peerId,
    required int fromId,
    List<MessageAttachment>? attachments,
  }) async {
    var currentTimestamp = DateTimeUtils.currentTimestamp;

    var messageId = await _dao.insertMessage(MessageEntity(
      globalId: globalId,
      time: currentTimestamp,
      peerId: peerId,
      fromId: fromId,
      text: text,
      attachments: attachments,
      sendState: 1,
    ));

    var newMessage = Message(
      id: messageId,
      globalId: globalId,
      time: currentTimestamp,
      peerId: peerId,
      fromId: fromId,
      text: text,
      attachments: attachments,
      sendState: 1,
    );

    return newMessage;
  }

  @override
  Future<Either<MessagesFailure, Unit>> setActivityFor(Connection connection, {
    required MessageActivityType type,
  }) async {
    try {
      await apiService.messagesSetActivity(connection, type: type);

      return const Right(unit);
    } on DioError catch (_) {
      return left(const MessagesFailure.serverError());
    } on ApiFailure catch (_) {
      return left(const MessagesFailure.apiError());
    }
  }

  @override
  Future<Either<MessagesFailure, Unit>> uploadAttachment(Connection connection,
      {
        required String fileId,
        required String filePath,
        required String fileName,
        required String fileType,
      }) async {
    try {
      await apiService.uploadFile(
        connection,
        fileId: fileId,
        filePath: filePath,
        fileName: fileName,
        fileType: fileType,
      );

      return const Right(unit);
    } on DioError catch (_) {
      return left(const MessagesFailure.serverError());
    } on ApiFailure catch (_) {
      return left(const MessagesFailure.apiError());
    }
  }

  @override
  Future<Either<MessagesFailure, Message>> findMessageById(int id) async {
    try {
      var message = await _dao.findMessageById(id);

      if (message != null) return Right(message.toMessage());

      return const Left(MessagesFailure.doesNotExist());
    } catch (_) {
      return const Left(MessagesFailure.dbError());
    }
  }

  @override
  void notifyAboutNewActivity(MessageActivity messageActivity) {
    var messageActivities = [
      ...[messageActivity],
      ..._messageActivityStream.value,
    ];

    _messageActivityStream.add(messageActivities);
  }

  @override
  void notifyAboutMessage(Message message) {
    _messagesStream.add(message);
  }

  @override
  Future<Either<MessagesFailure, int>> fetchUnreadCount({
    required int peerId,
    required int lastReadId,
  }) async {
    try {
      // TODO: проверь есть ли новая версия floor с фиксом этого кринжа
      var count = await db.selectCount(
        from: "Messages",
        where: "peerId = $peerId AND id > $lastReadId",
      );

      return Right(count);
    } catch (_) {
      return const Left(MessagesFailure.dbError());
    }
  }
}

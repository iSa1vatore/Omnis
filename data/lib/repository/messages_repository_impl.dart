import 'dart:async';

import 'package:common/utils/date_time_utils.dart';
import 'package:common/utils/random_utils.dart';
import 'package:data/mapper/messages_mapper.dart';
import 'package:data/sources/local/db/app_database.dart';
import 'package:data/sources/local/db/dao/messages_dao.dart';
import 'package:data/sources/local/db/entity/message_entity.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/message.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/util/resource.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../sources/remote/api_service.dart';

@Singleton(as: MessagesRepository)
class MessagesRepositoryImpl extends MessagesRepository {
  final AppDatabase db;
  final ApiService apiService;

  late MessagesDao _dao;

  final _newMessageStream = BehaviorSubject<Message>();
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
  Future<Resource<List<Message>>> findMessagesByPeerId(int peerId) async {
    var messages = await _dao.findMessagesByPeerId(peerId);

    return Resource.success(messages.map((m) => m.toMessage()).toList());
  }

  @override
  Stream<Message> observeNewMessage() => _newMessageStream.asBroadcastStream();

  @override
  Stream<List<MessageActivity>> observeMessageActivities() =>
      _messageActivityStream.asBroadcastStream();

  @override
  Future<Resource<int>> send({
    required Connection connection,
    required String text,
  }) async {
    var globalId = RandomUtils.generateString(16);

    var addMessage = add(
      globalId: globalId,
      text: text,
      peerId: connection.userId,
      fromId: 1,
    );

    var result = await apiService.messagesSend(
      connection,
      text: text,
      globalId: globalId,
    );

    if (result == 1) {
      var addedMessage = await addMessage;

      return Resource.success(addedMessage.data!);
    }

    return Resource.error("send error");
  }

  @override
  Future<Resource<int>> add({
    required String globalId,
    required String text,
    required int peerId,
    required int fromId,
  }) async {
    var currentTimestamp = DateTimeUtils.currentTimestamp;

    var messageId = await _dao.insertMessage(MessageEntity(
      globalId: globalId,
      time: currentTimestamp,
      peerId: peerId,
      fromId: fromId,
      text: text,
      sendState: 1,
    ));

    _newMessageStream.add(Message(
      id: messageId,
      globalId: globalId,
      time: currentTimestamp,
      peerId: peerId,
      fromId: fromId,
      text: text,
      sendState: 1,
    ));

    return Resource.success(messageId);
  }

  @override
  Future<Resource<int>> setActivityFor(Connection connection, {
    required MessageActivityType type,
  }) async {
    var result = await apiService.messagesSetActivity(connection, type: type);

    return Resource.success(result);
  }

  @override
  void setActivity(MessageActivity messageActivity) {
    var messageActivities = [
      ...[messageActivity],
      ..._messageActivityStream.value,
    ];

    _messageActivityStream.add(messageActivities);
  }
}

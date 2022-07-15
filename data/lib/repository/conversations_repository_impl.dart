import 'package:data/mapper/conversation_mapper.dart';
import 'package:data/sources/local/db/dao/conversation_dao.dart';
import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:domain/model/conversation.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/util/resource.dart';
import 'package:injectable/injectable.dart';

import '../sources/local/db/app_database.dart';

@Singleton(as: ConversationsRepository)
class ConversationsRepositoryImpl extends ConversationsRepository {
  final AppDatabase db;

  late ConversationDao _dao;

  ConversationsRepositoryImpl(this.db) {
    _dao = db.conversationDao;
  }

  @override
  Future<Resource<Conversation>> findOrCreateById(int id) async {
    var conversation = await _dao.findConversationById(id);

    if (conversation != null) {
      return Resource.success(conversation.toConversation());
    }

    return create(Conversation(
      id: id,
      inRead: 0,
      outRead: 0,
      lastMessageId: 0,
    ));
  }

  @override
  Future<Resource<Conversation>> create(Conversation conversation) async {
    var newConversationId = await _dao.insertConversation(
      conversation.toConversationEntity(),
    );

    var newConversation = await _dao.findConversationById(newConversationId);

    if (newConversation != null) {
      return Resource.success(newConversation.toConversation());
    }

    return Resource.error("conversation create error");
  }

  @override
  Future<Resource<bool>> update({
    required int id,
    int? inRead,
    int? outRead,
    int? lastMessageId,
  }) async {
    var conversation = await _dao.findConversationById(id);

    if (conversation != null) {
      var update = await _dao.updateConversation(ConversationEntity(
        id: id,
        inRead: inRead ?? conversation.inRead,
        outRead: outRead ?? conversation.outRead,
        lastMessageId: lastMessageId ?? conversation.lastMessageId,
      ));

      if (update == 1) return Resource.success(true);
    } else {
      var newConversation = await create(Conversation(
        id: id,
        inRead: inRead ?? 0,
        outRead: outRead ?? 0,
        lastMessageId: lastMessageId ?? 0,
      ));

      if (newConversation.error == null) return Resource.success(true);
    }

    return Resource.error("update error");
  }

  @override
  Future<Resource<List<Conversation>>> fetchAll() async {
    var conversations = await _dao.findAll();

    return Resource.success(
      conversations.map((e) => e.toConversation()).toList(),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:data/mapper/conversation_mapper.dart';
import 'package:data/sources/local/db/dao/conversation_dao.dart';
import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:domain/exceptions/conversations_failure.dart';
import 'package:domain/model/conversation.dart';
import 'package:domain/repository/conversations_repository.dart';
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
  Future<Either<ConversationsFailure, Conversation>> findById(
    int id,
  ) async {
    try {
      var conversation = await _dao.findConversationById(id);

      if (conversation != null) {
        return Right(conversation.toConversation());
      }

      return const Left(ConversationsFailure.doesNotExist());
    } catch (_) {
      return const Left(ConversationsFailure.dbError());
    }
  }

  @override
  Future<Either<ConversationsFailure, Conversation>> create(
    Conversation conversation,
  ) async {
    try {
      var newConversationId = await _dao.insertConversation(
        conversation.toConversationEntity(),
      );

      var newConversation = await _dao.findConversationById(newConversationId);

      if (newConversation != null) {
        return Right(newConversation.toConversation());
      }

      return const Left(ConversationsFailure.createError());
    } catch (_) {
      return const Left(ConversationsFailure.dbError());
    }
  }

  @override
  Future<Either<ConversationsFailure, Unit>> update({
    required int id,
    int? inRead,
    int? outRead,
    int? lastMessageId,
  }) async {
    try {
      var conversation = await _dao.findConversationById(id);

      if (conversation != null) {
        var update = await _dao.updateConversation(ConversationEntity(
          id: id,
          inRead: inRead ?? conversation.inRead,
          outRead: outRead ?? conversation.outRead,
          lastMessageId: lastMessageId ?? conversation.lastMessageId,
        ));

        if (update != 0) return const Right(unit);

        return const Left(ConversationsFailure.updateError());
      } else {
        var createConversation = await create(Conversation(
          id: id,
          inRead: inRead ?? 0,
          outRead: outRead ?? 0,
          lastMessageId: lastMessageId ?? 0,
        ));

        return createConversation.fold(
          (error) => const Left(ConversationsFailure.updateError()),
          (_) => const Right(unit),
        );
      }
    } catch (_) {
      return const Left(ConversationsFailure.dbError());
    }
  }

  @override
  Future<Either<ConversationsFailure, List<Conversation>>> findAll() async {
    try {
      var conversations = await _dao.findAll();

      return Right(conversations.map((e) => e.toConversation()).toList());
    } catch (_) {
      return const Left(ConversationsFailure.dbError());
    }
  }
}

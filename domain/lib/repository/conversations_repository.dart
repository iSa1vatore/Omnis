import 'package:dartz/dartz.dart';
import 'package:domain/model/conversation.dart';

import '../exceptions/conversations_failure.dart';

abstract class ConversationsRepository {
  Future<Either<ConversationsFailure, Conversation>> findById(int id);

  Future<Either<ConversationsFailure, Unit>> update({
    required int id,
    int? inRead,
    int? outRead,
    int? lastMessageId,
  });

  Future<Either<ConversationsFailure, Conversation>> create(
    Conversation conversation,
  );

  Future<Either<ConversationsFailure, List<Conversation>>> findAll();
}

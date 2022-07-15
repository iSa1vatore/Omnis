import 'package:domain/model/conversation.dart';
import 'package:domain/util/resource.dart';

abstract class ConversationsRepository {
  Future<Resource<Conversation>> findOrCreateById(int id);

  Future<Resource<bool>> update({
    required int id,
    int? inRead,
    int? outRead,
    int? lastMessageId,
  });

  Future<Resource<Conversation>> create(Conversation conversation);

  Future<Resource<List<Conversation>>> fetchAll();
}

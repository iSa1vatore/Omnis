import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversationDao {
  @Query("SELECT * FROM Conversations WHERE id = :id")
  Future<ConversationEntity?> findConversationById(int id);

  @Query("SELECT * FROM Conversations")
  Future<List<ConversationEntity>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertConversation(ConversationEntity conversationEntity);

  @update
  Future<int> updateConversation(ConversationEntity conversationEntity);
}

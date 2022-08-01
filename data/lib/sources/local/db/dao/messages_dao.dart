import 'package:floor/floor.dart';

import '../entity/message_entity.dart';

@dao
abstract class MessagesDao {
  @Query(
    "SELECT * FROM Messages "
    "WHERE peerId = :peerId "
    "ORDER BY id DESC "
    "LIMIT :limit "
    "OFFSET :offset",
  )
  Future<List<MessageEntity>> findMessagesByPeerId(
    int peerId,
    int limit,
    int offset,
  );

  @Query("SELECT * FROM Messages WHERE id = :id")
  Future<MessageEntity?> findMessageById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertMessage(MessageEntity messageEntity);

  @update
  Future<int> updateMessage(MessageEntity messageEntity);
}

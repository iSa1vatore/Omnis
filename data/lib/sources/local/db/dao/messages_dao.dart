import 'package:floor/floor.dart';

import '../entity/message_entity.dart';

@dao
abstract class MessagesDao {
  @Query("SELECT * FROM Messages WHERE peerId = :peerId ORDER BY id DESC")
  Future<List<MessageEntity>> findMessagesByPeerId(int peerId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertMessage(MessageEntity messageEntity);
}

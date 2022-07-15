import 'package:floor/floor.dart';

@Entity(tableName: "Conversations")
class ConversationEntity {
  @primaryKey
  final int id;
  final int inRead;
  final int outRead;
  final int lastMessageId;

  ConversationEntity({
    required this.id,
    required this.inRead,
    required this.outRead,
    required this.lastMessageId,
  });
}

import 'package:floor/floor.dart';

@Entity(tableName: "Messages")
class MessageEntity {
  @primaryKey
  final int? id;
  final String globalId;
  final int time;
  final int peerId;
  final int fromId;
  final String text;

  @ColumnInfo(name: 'send_state')
  final int sendState;

  MessageEntity({
    this.id,
    required this.globalId,
    required this.time,
    required this.peerId,
    required this.fromId,
    required this.text,
    required this.sendState,
  });
}

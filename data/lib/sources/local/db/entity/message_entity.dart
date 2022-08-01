import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:floor/floor.dart';

@Entity(tableName: "Messages")
class MessageEntity {
  @primaryKey
  final int? id;
  final String globalId;
  final int time;
  final int peerId;
  final int fromId;
  final String? text;
  final List<MessageAttachment>? attachments;

  @ColumnInfo(name: 'send_state')
  final int sendState;

  MessageEntity({
    this.id,
    required this.globalId,
    required this.time,
    required this.peerId,
    required this.fromId,
    this.text,
    required this.sendState,
    this.attachments = const [],
  });
}

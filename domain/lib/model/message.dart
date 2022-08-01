import 'package:domain/model/message_attachment/message_attachment.dart';

class Message {
  final int id;
  final String globalId;
  final int time;
  final int peerId;
  final int fromId;
  final int sendState;
  final String? text;
  final List<MessageAttachment>? attachments;
  final Message? replyMessage;

  Message({
    required this.id,
    required this.globalId,
    required this.time,
    required this.peerId,
    required this.fromId,
    required this.sendState,
    this.text,
    this.attachments,
    this.replyMessage,
  });

  Message copyWith({
    int? id,
    String? globalId,
    int? time,
    int? peerId,
    int? fromId,
    int? sendState,
    String? text,
    List<MessageAttachment>? attachments,
    Message? replyMessage,
  }) {
    return Message(
      id: id ?? this.id,
      globalId: globalId ?? this.globalId,
      time: time ?? this.time,
      peerId: peerId ?? this.peerId,
      fromId: fromId ?? this.fromId,
      sendState: sendState ?? this.sendState,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      replyMessage: replyMessage ?? this.replyMessage,
    );
  }
}

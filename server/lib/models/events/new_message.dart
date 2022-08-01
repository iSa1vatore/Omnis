import 'package:data/mapper/attachment_mapper.dart';
import 'package:domain/model/message.dart';

class SENewMessage extends Message {
  SENewMessage({
    required super.id,
    required super.globalId,
    required super.time,
    required super.peerId,
    required super.fromId,
    required super.sendState,
    super.text,
    super.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'globalId': globalId,
      'time': time,
      'peerId': peerId,
      'fromId': fromId,
      'sendState': sendState,
      'text': text,
      'attachments': attachments != null
          ? attachments!.map((a) => a.toDto().toJson()).toList()
          : null,
    };
  }
}

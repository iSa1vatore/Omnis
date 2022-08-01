import 'package:domain/model/message_attachment/message_attachment_voice.dart';

import 'message_attachment_photo.dart';

class MessageAttachment {
  final int type;
  final MessageAttachmentVoice? voice;
  final MessageAttachmentPhoto? photo;

  MessageAttachment({
    required this.type,
    this.voice,
    this.photo,
  });
}

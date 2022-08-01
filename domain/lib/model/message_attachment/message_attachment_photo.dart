import 'message_attachment_base.dart';

class MessageAttachmentPhoto extends BaseMessageAttachment {
  final String name;
  final int width;
  final int height;

  MessageAttachmentPhoto({
    required super.fileId,
    super.filePath,
    required this.name,
    required this.width,
    required this.height,
  });
}

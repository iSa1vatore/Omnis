import 'message_attachment_base.dart';

class MessageAttachmentVoice extends BaseMessageAttachment {
  final int duration;
  final List<double> waveform;

  MessageAttachmentVoice({
    required super.fileId,
    required this.duration,
    required this.waveform,
  });
}

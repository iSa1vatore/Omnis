import 'package:data/sources/local/db/converters/message_attachments_converter.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/message_attachment/message_attachment_voice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<MessageAttachment> attachments = [
    MessageAttachment(
      type: 4,
      voice: MessageAttachmentVoice(
        fileId: '1',
        duration: 1,
        waveform: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      ),
    )
  ];

  var converter = MessageAttachmentsConverter();

  test('converter test', () {
    var encoded = converter.encode(attachments);
    List<MessageAttachment>? decoded = converter.decode(encoded);

    expect(decoded![0].voice!.waveform, attachments[0].voice!.waveform);
  });
}

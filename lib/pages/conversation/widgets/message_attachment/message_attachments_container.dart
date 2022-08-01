import 'package:domain/model/message.dart';
import 'package:domain/model/message_attachment/message_attachment_photo.dart';
import 'package:flutter/material.dart';
import 'package:omnis/pages/conversation/widgets/message_attachment/photo_message_attachment.dart';
import 'package:omnis/pages/conversation/widgets/message_attachment/voice_message_attachment.dart';

class MessageAttachmentsContainer extends StatelessWidget {
  final Message message;

  const MessageAttachmentsContainer(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> attachmentsList = [];
    List<MessageAttachmentPhoto> photos = [];

    for (var attachment in message.attachments!) {
      if (attachment.voice != null) {
        attachmentsList.add(VoiceMessageAttachment(
          attachment.voice!,
          isOut: message.fromId == 1,
          messageId: message.id,
        ));
      }

      if (attachment.photo != null) {
        photos.add(attachment.photo!);
      }
    }

    if (photos.isNotEmpty) {
      attachmentsList.add(LayoutBuilder(builder: (context, constraints) {
        return PhotoMessageAttachment(
          photos,
          maxWidth: constraints.maxWidth,
        );
      }));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: attachmentsList,
    );
  }
}

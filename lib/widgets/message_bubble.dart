import 'package:domain/model/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/message_attachment/message_attachments_container.dart';
import 'package:omnis/utils/emoji_utils.dart';
import 'package:omnis/widgets/slidable_widget.dart';

import '../pages/conversation/widgets/message_context_menu.dart';
import 'message_send_status.dart';

class MessagesBubble extends StatelessWidget {
  final Message message;
  final bool isOut;

  const MessagesBubble({
    Key? key,
    required this.message,
    required this.isOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = message.text;

    var rowContent = <Widget>[];

    var messageSendTime = Padding(
      padding: EdgeInsets.only(bottom: isOut ? 1.5 : 9, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isOut)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: MessageSendState(message.sendState, isRead: false),
            ),
          Text(
            DateFormat('hh:mm a').format(
              DateTime.fromMillisecondsSinceEpoch(message.time * 1000),
            ),
            style: context.textTheme.caption!.copyWith(fontSize: 12),
          ),
        ],
      ),
    );

    Widget? textWidget;
    Color? containerColor;

    var isEmojiMessage = text == null
        ? false
        : EmojiUtils.hasOnlyEmojis(text) && text.length <= 6;

    if (isEmojiMessage) {
      textWidget = Text(
        text,
        style: const TextStyle(
          fontSize: 38,
          height: .6,
        ),
      );

      containerColor = Colors.transparent;
    } else {
      containerColor = isOut
          ? context.extraColors.messageBackgroundColor
          : context.extraColors.outMessageBackgroundColor;

      if (text != null) {
        textWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isOut
                  ? context.extraColors.messageTextColor
                  : context.extraColors.outMessageTextColor,
            ),
          ),
        );
      }
    }

    Widget? attachmentsWidget;

    if (message.attachments != null && message.attachments!.isNotEmpty) {
      attachmentsWidget = MessageAttachmentsContainer(message);
    }

    rowContent.add(Flexible(
      child: MessageContextMenu(
        child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Column(
            children: [
              if (textWidget != null) textWidget,
              if (attachmentsWidget != null) attachmentsWidget,
            ],
          ),
        ),
      ),
    ));

    if (isOut) {
      rowContent.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: messageSendTime,
        ),
      );
    } else {
      rowContent.add(messageSendTime);
    }

    return SlidableWidget(
      onSlided: () {},
      afterIcon: Icons.reply_rounded,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isEmojiMessage ? 8 : 4,
        ),
        child: Row(
          mainAxisAlignment:
              isOut ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: rowContent,
        ),
      ),
    );
  }
}

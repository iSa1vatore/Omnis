import 'package:domain/model/message.dart';
import 'package:domain/model/user.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../widgets/message_bubble.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var demoUserOne = User(
      id: 1,
      name: 'Питер',
      photo: '',
      lastOnline: 0,
      globalId: "123",
    );

    var demoUserTwo = User(
      id: 2,
      name: 'Брайан',
      photo: '',
      lastOnline: 0,
      globalId: "123",
    );

    var demoMessageOne = Message(
        id: 1,
        time: 1656759921,
        peerId: demoUserOne.id,
        fromId: demoUserOne.id,
        text: "Have you lost your internet too?",
        globalId: "",
        sendState: 0);

    var demoMessagesList = [
      demoMessageOne,
      Message(
          id: 2,
          time: 1656759921,
          peerId: demoUserTwo.id,
          fromId: demoUserTwo.id,
          text: "Yeah",
          replyMessage: demoMessageOne,
          globalId: "",
          sendState: 0),
      Message(
          id: 3,
          time: 1656769921,
          peerId: demoUserOne.id,
          fromId: demoUserOne.id,
          text: "How to live without fortnite?",
          globalId: "",
          sendState: 0)
    ];

    BorderRadius? borderRadius;

    Border? border = Border(
      bottom: BorderSide(color: context.theme.dividerColor),
      top: BorderSide(color: context.theme.dividerColor),
    );

    if (context.platform.isIos) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );

      border = Border.all(color: context.theme.dividerColor);
    }

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            child: MessagesBubble(message: demoMessagesList[0], isOut: true),
          ),
          MessagesBubble(message: demoMessagesList[1], isOut: false),
          MessagesBubble(message: demoMessagesList[2], isOut: true),
        ],
      ),
    );
  }
}

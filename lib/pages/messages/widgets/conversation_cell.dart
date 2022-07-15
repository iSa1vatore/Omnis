import 'package:auto_route/auto_route.dart';
import 'package:domain/model/conversation.dart';
import 'package:domain/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/avatar.dart';
import 'package:omnis/widgets/cell.dart';

import '../../../router/router.dart';
import '../../conversation/conversation_bloc.dart';

class ConversationCell extends StatelessWidget {
  final Conversation conversation;
  final User user;

  const ConversationCell({
    Key? key,
    required this.conversation,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Cell(
      onTap: () {
        context
            .read<ConversationBloc>()
            .add(ConversationEvent.selectConversation(
              user,
            ));

        context.router.push(const ConversationRoute());
      },
      avatar: Avatar(
        height: 50,
        width: 50,
        url: user.photo,
      ),
      title: user.name,
      caption: "Last message",
      before: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.check_rounded,
                size: 18,
                color: context.theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text("10:22 PM", style: context.theme.textTheme.caption),
            ],
          ),
          const SizedBox(height: 12),
          if (2 <= 3)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyle(
                    color: context.theme.colorScheme.inversePrimary,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

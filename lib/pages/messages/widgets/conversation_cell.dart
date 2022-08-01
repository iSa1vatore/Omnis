import 'package:auto_route/auto_route.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/ui_conversation.dart';
import 'package:domain/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/avatar.dart';
import 'package:omnis/widgets/cell.dart';

import '../../../bloc/conversation_bloc.dart';
import '../../../router/router.dart';
import '../../../utils/date_time_utils.dart';
import '../../../widgets/message_activity.dart';
import '../../../widgets/message_send_status.dart';

class ConversationCell extends StatelessWidget {
  final UIConversation conversation;
  final MessageActivity? activity;
  final User user;

  const ConversationCell({
    Key? key,
    required this.conversation,
    required this.user,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lastMessage = conversation.lastMessage;

    Widget? lastMessageDetails;
    if (lastMessage != null) {
      if (lastMessage.text != null) {
        lastMessageDetails = Text(
          lastMessage.text!,
          style: context.theme.textTheme.caption!.copyWith(
            fontSize: 15,
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      }
      if (lastMessage.attachments != null &&
          lastMessage.attachments!.isNotEmpty) {
        var isVoiceMessage = lastMessage.attachments?[0].voice != null;

        lastMessageDetails = Text(
          isVoiceMessage ? context.loc.voice_message : context.loc.attachment,
          style: context.theme.textTheme.caption!.copyWith(
            fontSize: 15,
            color: context.theme.colorScheme.primary,
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      }
    }

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
        source: user.photo,
      ),
      title: user.name,
      captionWidget: activity != null
          ? MessageUserActivity(activity!)
          : lastMessageDetails,
      before: lastMessage != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (lastMessage.fromId == 1)
                      MessageSendState(
                        lastMessage.sendState,
                        iconSize: 17,
                        isRead: true,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      DateTimeUtils.format(lastMessage.time),
                      style: context.theme.textTheme.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (conversation.unreadCount > 0)
                  Container(
                    width: conversation.unreadCount < 10 ? 20 : 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: TextStyle(
                          color: context.extraColors.inverseTextColor,
                        ),
                      ),
                    ),
                  )
              ],
            )
          : null,
    );
  }
}

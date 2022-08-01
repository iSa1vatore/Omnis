import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/messages/widgets/conversation_cell.dart';

import '../../bloc/messages_bloc.dart';
import '../../widgets/page_placeholder.dart';

class ConversationsList extends StatelessWidget {
  const ConversationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: 8,
        left: MediaQuery.of(context).padding.left,
        right: MediaQuery.of(context).padding.right,
      ),
      sliver: BlocBuilder<MessagesBloc, MessagesState>(
        builder: (context, state) {
          var conversationsLength = state.conversations.length;

          if (state.isLoading) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: context.mediaQuerySize.height / 1.6,
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (conversationsLength == 0 && !state.isLoading) {
            return SliverToBoxAdapter(
              child: PagePlaceholder(
                message: context.loc.emptyMessagesList,
                desc: context.loc.emptyMessagesListDesc,
                emoji: "😶",
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var conversation = state.conversations[index];
                var user = state.users.firstWhere(
                  (user) => user.id == conversation.id,
                );
                var activity = state.messageActivities.firstWhereOrNull(
                  (activity) => activity.peerId == conversation.id,
                );
 
                return ConversationCell(
                  conversation: conversation,
                  user: user,
                  activity: activity,
                );
              },
              childCount: conversationsLength,
            ),
          );
        },
      ),
    );
  }
}

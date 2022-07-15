import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/messages/messages_bloc.dart';
import 'package:omnis/pages/messages/widgets/conversation_cell.dart';

import '../../widgets/adaptive_sliver_app_bar.dart';
import '../../widgets/extended_scroll_view.dart';
import '../../widgets/page_placeholder.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: ExtendedScrollView(
        slivers: [
          AdaptiveSliverAppBar(title: context.loc.messages),
          SliverPadding(
            padding: EdgeInsets.only(
              top: 8,
              left: safePadding.left,
              right: safePadding.right,
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

                      return ConversationCell(
                        conversation: conversation,
                        user: user,
                      );
                    },
                    childCount: conversationsLength,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

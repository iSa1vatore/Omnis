import 'package:common/logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../bloc/conversation_bloc.dart';
import '../../../widgets/message_bubble.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (prevState, state) {
        return prevState.messages != state.messages;
      },
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var message = state.messages[index];

              return VisibilityDetector(
                key: Key("message-${message.id}"),
                onVisibilityChanged: (VisibilityInfo info) {
                  if (info.visibleFraction == 1) {
                    Log.i(message.id);
                  }
                },
                child: MessagesBubble(
                  message: message,
                  isOut: message.fromId == 1,
                ),
              );
            },
            childCount: state.messages.length,
          ),
        );
      },
    );
  }
}

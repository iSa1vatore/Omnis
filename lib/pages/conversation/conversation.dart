import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/message_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/voice_record_lock.dart';
import 'package:omnis/pages/conversation/widgets/write_bar.dart';
import 'package:omnis/pages/messages/messages_bloc.dart';
import 'package:omnis/router/router.dart';
import 'package:omnis/widgets/tap_effect.dart';

import '../../widgets/adaptive_app_bar.dart';
import '../../widgets/avatar.dart';
import '../../widgets/message_bubble.dart';
import 'conversation_bloc.dart';

class ConversationPage extends HookWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding(bottom: 8).copyWith(
          top: context.appBarHeight,
        );

    var conversationBloc = context.watch<ConversationBloc>();

    var user = conversationBloc.state.user!;

    final voiceRecordBoxYOffset = useState(0.0);
    final writeBarXOffset = useState(0.0);

    void voiceButtonGestureDetector(LongPressMoveUpdateDetails gesture) {
      double offsetY = gesture.localOffsetFromOrigin.dy;
      double offsetX = gesture.localOffsetFromOrigin.dx;

      if (offsetX < -35) {
        writeBarXOffset.value = offsetX + 35;

        return;
      }

      if (offsetY < -60) {
        var offset = -(offsetY + 60);

        if (!conversationBloc.state.isPermanentVoiceRecording) {
          voiceRecordBoxYOffset.value = offset;
        }

        if (offset > 30) {
          conversationBloc
              .add(const ConversationEvent.setPermanentVoiceRecording());
        }
      }
    }

    void cancelVoiceRecord() {
      conversationBloc.add(
        const ConversationEvent.stopVoiceRecording(send: false),
      );

      voiceRecordBoxYOffset.value = 0;
      writeBarXOffset.value = 0;
    }

    void sendVoiceMessage() {
      voiceRecordBoxYOffset.value = 0;
      writeBarXOffset.value = 0;

      conversationBloc.add(
        const ConversationEvent.stopVoiceRecording(),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AdaptiveAppBar(
        previousPageTitle: context.loc.back,
        trailing: Avatar(
          width: 38,
          height: 38,
          url: user.photo,
        ),
        child: TouchEffect(
          borderRadius: 8,
          onTap: () {
            context.router.push(const ConversationDetailsRoute());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: context.theme.textTheme.subtitle2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                BlocBuilder<MessagesBloc, MessagesState>(
                  builder: (context, state) {
                    MessageActivity? activity =
                        state.messageActivities.firstWhereOrNull(
                      (activity) => activity.peerId == user.id,
                    );

                    if (activity == null) {
                      return Text(
                        "Online",
                        style: context.theme.textTheme.caption,
                      );
                    }

                    String activityName;
                    Widget activityAnimation;

                    switch (activity.type) {
                      case MessageActivityType.typing:
                        activityName = context.loc.typing;
                        activityAnimation = SpinKitThreeBounce(
                          color: context.theme.colorScheme.primary,
                          size: 8,
                        );
                        break;
                      case MessageActivityType.audiomessage:
                        activityName = context.loc.recordsVoice;
                        activityAnimation = SpinKitWave(
                          color: context.theme.colorScheme.primary,
                          size: 8,
                        );
                        break;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activityName,
                          style: context.theme.textTheme.caption!.copyWith(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        activityAnimation
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: context.safeInsets.top,
            child: const Hero(
              tag: "conversationAvatar",
              child: SizedBox(),
            ),
          ),
          if (conversationBloc.state.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            padding: bodyPadding,
            itemBuilder: (BuildContext context, int index) {
              var message = conversationBloc.state.messages[index];

              return MessagesBubble(
                message: message,
                isOut: message.fromId == 1,
              );
            },
            itemCount: conversationBloc.state.messages.length,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: WriteBar(
              voiceButtonGestureDetector: voiceButtonGestureDetector,
              cancelVoiceRecord: cancelVoiceRecord,
              sendVoiceMessage: sendVoiceMessage,
              positionOffset: writeBarXOffset.value,
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOutBack,
            bottom: context.safeInsets.bottom + 35 + 50,
            right: conversationBloc.state.isVoiceRecording ||
                    conversationBloc.state.isPermanentVoiceRecording
                ? 9
                : -40,
            duration: const Duration(milliseconds: 150),
            child: VoiceRecordLock(
              positionOffset: voiceRecordBoxYOffset.value,
              isLocked: conversationBloc.state.isPermanentVoiceRecording,
            ),
          ),
        ],
      ),
    );
  }
}

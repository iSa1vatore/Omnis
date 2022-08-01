import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

import '../../../bloc/conversation_bloc.dart';
import '../conversation.dart';

class VoiceRecordLock extends StatelessWidget {
  const VoiceRecordLock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);

    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (prevState, state) {
        return prevState.isVoiceRecording != state.isVoiceRecording ||
            prevState.isPermanentVoiceRecording !=
                state.isPermanentVoiceRecording;
      },
      builder: (context, state) {
        var isLocked = state.isPermanentVoiceRecording;

        return AnimatedPositioned(
          curve: Curves.easeInOutBack,
          bottom: context.safeInsets.bottom + 35 + 50,
          right: state.isVoiceRecording || state.isPermanentVoiceRecording
              ? 9
              : -40,
          duration: const Duration(milliseconds: 150),
          child: Observer(
            builder: (_) => BlurEffect(
              backgroundColorOpacity: .6,
              backgroundColor: context.theme.cardColor,
              childBorderRadius: 50,
              child: Container(
                height: isLocked ? 40 : 70 - uiController.voiceRecordBoxYOffset,
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.dividerColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 8,
                  top: 4,
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: isLocked ? 0 : 1,
                      child: SizedBox(
                        width: 24,
                        child: Icon(
                          IconlyLight.arrowUp2,
                          size: 18,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Icon(
                        isLocked ? IconlyLight.lock : IconlyLight.unlock,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

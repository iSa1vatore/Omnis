import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../bloc/conversation_bloc.dart';
import '../../../../widgets/widgets_switcher.dart';
import '../../conversation.dart';
import '../icon_btn.dart';

class WriteBarSendButton extends StatelessWidget {
  const WriteBarSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);

    return BlocBuilder<ConversationBloc, ConversationState>(
        buildWhen: (prevState, state) =>
            prevState.isPermanentVoiceRecording !=
                state.isPermanentVoiceRecording ||
            prevState.attachments != state.attachments,
        builder: (context, state) {
          return Observer(builder: (_) {
            return WidgetsSwitcher(
              selected: uiController.showSendButton ||
                      state.isPermanentVoiceRecording ||
                      state.attachments.isNotEmpty
                  ? 0
                  : 1,
              children: [
                IconBtn(
                  icon: Icons.arrow_upward_rounded,
                  iconColor: Colors.white,
                  iconSize: 25,
                  backgroundColor: context.theme.colorScheme.primary,
                  onTap: uiController.sendMessage,
                ),
                GestureDetector(
                  onLongPressMoveUpdate: uiController.onVoiceButtonGesture,
                  onLongPress: () => context.read<ConversationBloc>().add(
                        const ConversationEvent.startVoiceRecording(),
                      ),
                  onLongPressEnd: (_) => {
                    uiController.sendVoiceMessage(),
                  },
                  child: IconBtn(
                    icon: IconlyBold.voice,
                    onTap: () {},
                  ),
                ),
              ],
            );
          });
        });
  }
}

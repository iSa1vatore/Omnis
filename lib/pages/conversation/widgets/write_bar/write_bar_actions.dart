import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../bloc/conversation_bloc.dart';
import '../../../../widgets/widgets_switcher.dart';
import '../../conversation.dart';
import '../icon_btn.dart';

class WriteBarActions extends StatelessWidget {
  const WriteBarActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);
    var conversationBloc = context.read<ConversationBloc>();

    return Observer(
      builder: (_) => Transform.translate(
        offset: Offset(uiController.writeBarXOffset, 0),
        child: BlocBuilder<ConversationBloc, ConversationState>(
            buildWhen: (prevState, state) {
          return prevState.isVoiceRecording != state.isVoiceRecording ||
              prevState.isPermanentVoiceRecording !=
                  state.isPermanentVoiceRecording ||
              state.isVoiceRecording ||
              prevState.attachmentsPickerIsShown !=
                  state.attachmentsPickerIsShown;
        }, builder: (context, state) {
          var afterContent = 0;

          if (state.isVoiceRecording) {
            if (state.isPermanentVoiceRecording) {
              afterContent = 1;
            } else {
              afterContent = 2;
            }
          }

          return WidgetsSwitcher(
            duration: 150,
            selected: afterContent,
            children: [
              IconBtn(
                key: const Key("sendAttachButton"),
                icon: IconlyBold.paperUpload,
                iconColor: state.attachmentsPickerIsShown
                    ? context.theme.colorScheme.primary
                    : null,
                onTap: () {
                  conversationBloc.add(
                    const ConversationEvent.toggleShowingAttachmentsPicker(),
                  );
                },
              ),
              IconBtn(
                key: const Key("stopRecordAttachButton"),
                icon: Icons.stop_rounded,
                iconColor: context.extraColors.dangerColor,
                iconSize: 25,
                backgroundColor: context.extraColors.dangerColor!.withOpacity(
                  .39,
                ),
                onTap: () {
                  uiController.cancelVoiceRecord();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      IconlyLight.arrowLeft2,
                      size: 20,
                      color: context.extraColors.secondaryIconColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.loc.cancel,
                      style: context.textTheme.caption,
                      overflow: TextOverflow.clip,
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

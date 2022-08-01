import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../bloc/conversation_bloc.dart';
import '../../../../widgets/widgets_switcher.dart';
import '../../conversation.dart';
import 'voice_record_details.dart';

class WriteBarBody extends StatelessWidget {
  const WriteBarBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);

    return Observer(
      builder: (_) => Transform.translate(
        offset: Offset(uiController.writeBarXOffset, 0),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 35,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: context.extraColors.messageBoxBorderColor!,
              width: 1.2,
            ),
            color: context.theme.scaffoldBackgroundColor.withOpacity(
              0.3,
            ),
          ),
          child: BlocBuilder<ConversationBloc, ConversationState>(
            buildWhen: (prevState, state) =>
                prevState.isVoiceRecording != state.isVoiceRecording,
            builder: (context, state) {
              return WidgetsSwitcher(
                duration: 150,
                selected: state.isVoiceRecording ? 0 : 1,
                children: [
                  const VoiceRecordDetails(),
                  TextField(
                    controller: uiController.messageTextController,
                    style: const TextStyle(fontSize: 16),
                    textAlignVertical: TextAlignVertical.bottom,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 1,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: context.loc.message,
                      isDense: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 6,
                        bottom: 6,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

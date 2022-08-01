import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/bloc/conversation_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/widgets_switcher.dart';

import '../../conversation_details/widgets/button_block.dart';

class AttachmentsPicker extends StatelessWidget {
  const AttachmentsPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationBloc = context.read<ConversationBloc>();

    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (prevState, state) =>
          prevState.attachmentsPickerIsShown != state.attachmentsPickerIsShown,
      builder: (context, state) {
        return WidgetsSwitcher(
          selected: state.attachmentsPickerIsShown ? 1 : 0,
          children: [
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonBlock(
                      onTap: () {
                        conversationBloc.add(
                          const ConversationEvent.selectAttachments(type: 1),
                        );
                      },
                      title: context.loc.media,
                      icon: IconlyLight.image2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ButtonBlock(
                      onTap: () {
                        conversationBloc.add(
                          const ConversationEvent.selectAttachments(type: 2),
                        );
                      },
                      title: context.loc.file,
                      icon: IconlyLight.paper,
                    ),
                  ),
                ],
              ),
            )
          ],
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
          ) {
            return SizeTransition(
              sizeFactor: animation,
              child: child,
            );
          },
        );
      },
    );
  }
}

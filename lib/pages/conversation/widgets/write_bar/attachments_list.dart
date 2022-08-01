import 'dart:io';

import 'package:domain/model/message_attachment/message_attachment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/bloc/conversation_bloc.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../widgets/widgets_switcher.dart';
import '../icon_btn.dart';

class AttachmentsList extends StatelessWidget {
  const AttachmentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationBloc = context.read<ConversationBloc>();

    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (prevState, state) =>
          prevState.attachments != state.attachments,
      builder: (context, state) {
        return WidgetsSwitcher(
          selected: state.attachments.isEmpty ? 0 : 1,
          children: [
            const SizedBox(),
            Container(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.theme.dividerColor),
                  bottom: BorderSide(color: context.theme.dividerColor),
                ),
              ),
              child: SizedBox(
                height: 75,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var attachment = state.attachments[index];

                    if (attachment.type == MessageAttachmentType.photo) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(attachment.photo!.filePath!),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: -4,
                              top: 0,
                              child: IconBtn(
                                onTap: () {
                                  conversationBloc
                                      .add(ConversationEvent.removeAttachment(
                                    index: index,
                                  ));
                                },
                                icon: Icons.close_rounded,
                                containerSize: 22,
                                iconSize: 18,
                                iconColor: Colors.white,
                                backgroundColor:
                                    context.extraColors.secondaryIconColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                  itemCount: state.attachments.length,
                ),
              ),
            ),
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

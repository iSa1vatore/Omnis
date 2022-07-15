import 'package:domain/enum/message_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/conversation_bloc.dart';
import 'package:omnis/pages/conversation/widgets/voice_record_details.dart';

import '../../../widgets/blur_effect.dart';
import '../../../widgets/widgets_switcher.dart';
import 'icon_btn.dart';

class WriteBar extends HookWidget {
  final void Function(LongPressMoveUpdateDetails) voiceButtonGestureDetector;
  final Function() cancelVoiceRecord;
  final void Function() sendVoiceMessage;
  final double positionOffset;

  const WriteBar({
    Key? key,
    required this.voiceButtonGestureDetector,
    required this.cancelVoiceRecord,
    required this.sendVoiceMessage,
    required this.positionOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.watch<ConversationBloc>();

    final textController = useTextEditingController();

    final showSendButton = useState(false);

    textController.addListener(() {
      if (textController.text.isEmpty) {
        showSendButton.value = false;
      } else {
        conversationBloc.add(const ConversationEvent.setActivity(
          MessageActivityType.typing,
        ));

        showSendButton.value = true;
      }
    });

    Widget _renderTextField() {
      return TextField(
        controller: textController,
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
      );
    }

    var afterContent = 0;

    if (conversationBloc.state.isVoiceRecording) {
      if (conversationBloc.state.isPermanentVoiceRecording) {
        afterContent = 1;
      } else {
        afterContent = 2;
      }
    }

    return BlurEffect(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .padding
              .bottom + 12,
          left: 11,
          right: 11,
          top: 9,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor.withOpacity(
            0.7,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   margin: const EdgeInsets.only(left: 6, bottom: 12),
            //   height: 40,
            //   child: Row(
            //     children: [
            //       Transform.scale(
            //         scaleX: -1,
            //         child: Icon(
            //           CupertinoIcons.reply,
            //           color: context.theme.colorScheme.primary,
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Alexanger",
            //             style: context.textTheme.subtitle2,
            //           ),
            //           const SizedBox(height: 2),
            //           Text(
            //             "Message",
            //             style: context.theme.textTheme.caption!.copyWith(
            //               fontSize: 15,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const Spacer(),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 6),
            //         child: Icon(
            //           IconlyLight.closeSquare,
            //           color: context.extraColors.secondaryIconColor,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(positionOffset, 0),
                  child: WidgetsSwitcher(
                    duration: 150,
                    selected: afterContent,
                    children: [
                      IconBtn(
                        key: const Key("sendAttachButton"),
                        icon: IconlyBold.paperUpload,
                        onTap: () {},
                      ),
                      IconBtn(
                        key: const Key("stopRecordAttachButton"),
                        icon: Icons.stop_rounded,
                        iconColor: context.extraColors.dangerColor,
                        iconSize: 25,
                        backgroundColor:
                        context.extraColors.dangerColor!.withOpacity(
                          .39,
                        ),
                        onTap: () {
                          cancelVoiceRecord();
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(positionOffset, 0),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 35,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: context.extraColors.messageBoxBorderColor!,
                          width: 1.2,
                        ),
                        color:
                        context.theme.scaffoldBackgroundColor.withOpacity(
                          0.3,
                        ),
                      ),
                      child: WidgetsSwitcher(
                        duration: 150,
                        selected:
                        conversationBloc.state.isVoiceRecording ? 0 : 1,
                        children: [
                          VoiceRecordDetails(
                            showCancelLabel: positionOffset < -50,
                            permanentRecord: conversationBloc
                                .state.isPermanentVoiceRecording,
                            waveformStream:
                            conversationBloc.voiceAudioAmplitudeStream,
                          ),
                          _renderTextField(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                WidgetsSwitcher(
                  selected: showSendButton.value ||
                      conversationBloc.state.isPermanentVoiceRecording
                      ? 0
                      : 1,
                  children: [
                    IconBtn(
                      icon: Icons.arrow_upward_rounded,
                      iconColor: Colors.white,
                      iconSize: 25,
                      backgroundColor: context.theme.colorScheme.primary,
                      onTap: () {
                        conversationBloc.add(ConversationEvent.sendMessage(
                          textController.text,
                        ));

                        textController.text = '';
                      },
                    ),
                    GestureDetector(
                      onLongPressMoveUpdate: voiceButtonGestureDetector,
                      onLongPress: () =>
                          conversationBloc.add(
                            const ConversationEvent.startVoiceRecording(),
                          ),
                      onLongPressEnd: (gesture) => sendVoiceMessage(),
                      child: IconBtn(
                        icon: IconlyBold.voice,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

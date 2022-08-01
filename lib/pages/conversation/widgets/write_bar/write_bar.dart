import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/write_bar/write_bar_actions.dart';
import 'package:omnis/pages/conversation/widgets/write_bar/write_bar_send_button.dart';
import 'package:omnis/pages/conversation/widgets/write_bar/write_button_body.dart';

import '../../../../widgets/blur_effect.dart';
import '../../conversation.dart';
import '../attachments_picker.dart';
import 'attachments_list.dart';

class WriteBar extends StatefulWidget {
  const WriteBar({
    Key? key,
  }) : super(key: key);

  @override
  State<WriteBar> createState() => _WriteBarState();
}

class _WriteBarState extends State<WriteBar> {
  final _writeBarGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);

    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        var height = _writeBarGlobalKey.currentContext?.size?.height;

        if (height != null) uiController.setWriteBarHeight(height);
        return true;
      },
      child: SizeChangedLayoutNotifier(
          child: BlurEffect(
        key: _writeBarGlobalKey,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        backgroundColorOpacity: 0.7,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AttachmentsList(),
              Padding(
                padding: const EdgeInsets.only(left: 11, right: 11, top: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    WriteBarActions(),
                    SizedBox(width: 12),
                    Expanded(child: WriteBarBody()),
                    SizedBox(width: 12),
                    WriteBarSendButton(),
                  ],
                ),
              ),
              const AttachmentsPicker(),
            ],
          ),
        ),
      )),
    );
  }
}

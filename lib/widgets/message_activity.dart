import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/message_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:omnis/extensions/build_context.dart';

class MessageUserActivity extends StatelessWidget {
  final MessageActivity messageActivity;

  const MessageUserActivity(this.messageActivity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String activityName = "";
    Widget activityAnimation = const SizedBox();

    switch (messageActivity.type) {
      case MessageActivityType.typing:
        activityName = context.loc.typing;
        activityAnimation = SpinKitThreeBounce(
          color: context.theme.colorScheme.primary,
          size: 8,
        );
        break;
      case MessageActivityType.audiomessage:
        activityName = context.loc.recordingVoice;
        activityAnimation = SpinKitWave(
          color: context.theme.colorScheme.primary,
          size: 8,
        );
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: activityAnimation,
        ),
        const SizedBox(width: 4),
        Text(
          activityName,
          style: context.theme.textTheme.caption!.copyWith(
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

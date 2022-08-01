import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class MessageSendState extends StatelessWidget {
  final int state;
  final double iconSize;
  final bool isRead;

  const MessageSendState(
    this.state, {
    Key? key,
    this.iconSize = 15,
    required this.isRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    var color = context.theme.colorScheme.primary;

    if (isRead) {
      icon = Icons.check_circle_outline_rounded;
    } else if (state == 0) {
      icon = Icons.check;
    } else if (state == 1) {
      icon = Icons.schedule_rounded;
    } else if (state == -1) {
      icon = Icons.error_outline_rounded;
      color = context.theme.errorColor;
    } else {
      icon = Icons.schedule_rounded;
      color = Colors.orange;
    }

    return Icon(
      icon,
      size: iconSize,
      color: color,
    );
  }
}

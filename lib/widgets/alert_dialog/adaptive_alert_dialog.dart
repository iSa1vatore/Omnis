import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import 'adaptive_alert_dialog_action.dart';

class AdaptiveAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final List<AdaptiveAlertDialogAction> actions;

  const AdaptiveAlertDialog({
    Key? key,
    required this.title,
    required this.actions,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return _buildCupertinoAlertDialog(
          context,
        );
      case TargetPlatform.android:
      default:
        return _buildMaterialAlertDialog(
          context,
        );
    }
  }

  Widget _buildCupertinoAlertDialog(
    BuildContext context,
  ) {
    return CupertinoAlertDialog(
      title: Text(
        title,
      ),
      content: content?.isNotEmpty ?? false
          ? Padding(
              padding: const EdgeInsets.only(
                top: 2,
              ),
              child: Text(content!),
            )
          : null,
      actions: actions,
    );
  }

  Widget _buildMaterialAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: content?.isNotEmpty ?? false ? Text(content!) : null,
      actions: actions,
    );
  }
}

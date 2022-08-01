import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class AdaptiveAlertDialogAction extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const AdaptiveAlertDialogAction.adaptive({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return _buildCupertinoDialogAction();
      case TargetPlatform.android:
      default:
        return _buildMaterialDialogAction();
    }
  }

  Widget _buildMaterialDialogAction() {
    return TextButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }

  Widget _buildCupertinoDialogAction() {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

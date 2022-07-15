import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const AdaptiveSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return CupertinoSwitch(
          activeColor: context.theme.colorScheme.primary,
          value: value,
          onChanged: onChanged,
        );
      case TargetPlatform.android:
      default:
        return Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: context.theme.colorScheme.primary,
          value: value,
          onChanged: onChanged,
        );
    }
  }
}

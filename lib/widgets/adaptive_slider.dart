import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class AdaptiveSlider extends StatelessWidget {
  final double value;
  final double max;
  final double min;
  final void Function(double) onChanged;

  const AdaptiveSlider({
    Key? key,
    required this.value,
    required this.max,
    required this.min,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return SizedBox(
          width: double.infinity,
          child: CupertinoSlider(
            value: value,
            max: max,
            min: min,
            activeColor: context.theme.colorScheme.primary,
            thumbColor: context.theme.colorScheme.primary,
            onChanged: onChanged,
          ),
        );
      case TargetPlatform.android:
      default:
        return Slider(
          value: value,
          max: max,
          min: min,
          onChanged: onChanged,
        );
    }
  }
}

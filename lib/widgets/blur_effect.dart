import 'dart:ui';

import 'package:flutter/material.dart';

class BlurEffect extends StatelessWidget {
  final Widget child;
  final double? childBorderRadius;

  const BlurEffect({
    Key? key,
    required this.child,
    this.childBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var blurredWidget = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
        child: child,
      ),
    );

    if (childBorderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(childBorderRadius!),
        child: blurredWidget,
      );
    }

    return blurredWidget;
  }
}

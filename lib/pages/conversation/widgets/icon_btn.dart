import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/tap_effect.dart';

class IconBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final GestureTapCallback? onTap;

  const IconBtn({
    Key? key,
    required this.icon,
    this.onTap,
    this.iconSize = 28,
    this.backgroundColor = Colors.transparent,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchEffect(
      borderRadius: 100,
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? context.extraColors.secondaryIconColor,
          size: iconSize,
        ),
      ),
    );
  }
}

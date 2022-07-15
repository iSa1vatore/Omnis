import 'package:flutter/material.dart';

class TouchEffect extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final double borderRadius;

  const TouchEffect({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

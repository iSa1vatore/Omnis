import 'package:flutter/material.dart';

class WidgetsSwitcher extends StatelessWidget {
  final List<Widget> children;
  final int selected;
  final int duration;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  const WidgetsSwitcher({
    Key? key,
    required this.children,
    required this.selected,
    this.duration = 100,
    this.transitionBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      transitionBuilder: transitionBuilder ??
              (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
      // switchInCurve: Curves.easeInCubic,
      // switchOutCurve: Curves.easeOutCubic,
      child: children[selected],
    );
  }
}

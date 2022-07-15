import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/icon_btn.dart';
import 'package:omnis/widgets/widgets_switcher.dart';

class SlidableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onSlided;
  final IconData afterIcon;
  final double actionThreshold;

  const SlidableWidget({
    Key? key,
    required this.child,
    required this.onSlided,
    required this.afterIcon,
    this.actionThreshold = 0.14,
  }) : super(key: key);

  @override
  State<SlidableWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;

  bool showLeftAction = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void onDragStart(DragStartDetails details) {
    setState(() {
      _dragExtent = 0;
      _controller.reset();
    });
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (_controller.value > widget.actionThreshold) {
      setState(() {
        showLeftAction = true;
      });
    } else if (showLeftAction && _controller.value < widget.actionThreshold) {
      setState(() {
        showLeftAction = false;
      });
    }

    _dragExtent += details.primaryDelta!;

    if (_dragExtent >= 0 || _dragExtent < -100) {
      return;
    }

    setState(() {
      _controller.value = _dragExtent.abs() / context.size!.width;
    });
  }

  void onDragEnd(DragEndDetails details) {
    setState(() {
      showLeftAction = false;
    });

    if (_controller.value > widget.actionThreshold) {
      widget.onSlided();
    }

    _controller.fling(velocity: -1);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              right: 15,
              child: WidgetsSwitcher(
                selected: showLeftAction ? 0 : 1,
                children: [
                  IconBtn(
                    icon: widget.afterIcon,
                    iconColor: context.theme.colorScheme.primary,
                    backgroundColor:
                        context.theme.colorScheme.primary.withOpacity(
                      0.2,
                    ),
                    iconSize: 20,
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => SlideTransition(
                position: AlwaysStoppedAnimation(Offset(-_controller.value, 0)),
                child: Container(
                  color: Colors.transparent,
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      );
}

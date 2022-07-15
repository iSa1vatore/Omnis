import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

class MessageContextMenu extends StatefulWidget {
  final Widget child;

  const MessageContextMenu({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MessageContextMenu> createState() => _MessageContextMenuState();
}

class _MessageContextMenuState extends State<MessageContextMenu> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  initChildOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;

    Size size = renderBox.size;

    Offset offset = renderBox.localToGlobal(Offset.zero);

    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: containerKey,
      onTap: () async => await open(context),
      child: widget.child,
    );
  }

  Future open(BuildContext context) async {
    initChildOffset();

    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, __) => FocusedMenuDetails(
          childOffset: childOffset,
          childSize: childSize,
          child: widget.child,
        ),
        fullscreenDialog: true,
        opaque: false,
      ),
    );
  }
}

class FocusedMenuDetails extends StatefulWidget {
  final Offset childOffset;
  final Size? childSize;
  final Widget child;

  const FocusedMenuDetails({
    Key? key,
    required this.child,
    required this.childOffset,
    required this.childSize,
  }) : super(key: key);

  @override
  State<FocusedMenuDetails> createState() => _FocusedMenuDetailsState();
}

class _FocusedMenuDetailsState extends State<FocusedMenuDetails>
    with TickerProviderStateMixin {
  final double menuWidth = 230;
  final double menuHeight = 218;

  final double reactionWidth = 230;
  final double reactionHeight = 50;

  final double bottomOffset = 60;

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> messageAnimation;
  late Animation<double> blurAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward(from: 0.0);

    scaleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Cubic(0.175, 0.885, 0.5, 1.1),
    ));

    messageAnimation = Tween(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Cubic(0.175, 0.885, 0.5, 1.1),
    ));

    blurAnimation = Tween(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double alignX;
    double alignY;

    double xOffset;
    double yOffset;

    double yOffsetReaction;
    double xOffsetReaction;

    if (widget.childOffset.dx <= 16) {
      xOffset = widget.childOffset.dx;

      alignX = -1.0;
    } else {
      alignX = 1.0;
      xOffset = widget.childOffset.dx - menuWidth + widget.childSize!.width;
    }

    if (widget.childOffset.dy + menuHeight + widget.childSize!.height <
        size.height - bottomOffset) {
      yOffset = widget.childOffset.dy + 16 + widget.childSize!.height;
      alignY = -1.0;
    } else {
      alignY = 1.0;
      yOffset = widget.childOffset.dy - 16 - menuHeight;
    }

    if (widget.childOffset.dx <= 16) {
      xOffsetReaction = widget.childOffset.dx;
    } else {
      xOffsetReaction =
          widget.childOffset.dx - reactionWidth + widget.childSize!.width;
    }

    if (widget.childOffset.dy + menuHeight + widget.childSize!.height <
        size.height - bottomOffset) {
      yOffsetReaction = widget.childOffset.dy - reactionHeight - 16;
    } else {
      yOffsetReaction = widget.childOffset.dy + widget.childSize!.height + 16;
    }

    var backColor = const Color(0xFF303030);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_animationController.isAnimating) return;

              _animationController.reverse().whenCompleteOrCancel(
                    () => Navigator.pop(context),
                  );
            },
            child: AnimatedBuilder(
              animation: blurAnimation,
              builder: (BuildContext context, Widget? child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurAnimation.value,
                    sigmaY: blurAnimation.value,
                  ),
                  child: Container(
                    color:
                        context.theme.scaffoldBackgroundColor.withOpacity(0.20),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: yOffsetReaction,
            left: xOffsetReaction,
            child: AnimatedBuilder(
              animation: scaleAnimation,
              child: BlurEffect(
                childBorderRadius: 50,
                child: Container(
                  width: reactionWidth,
                  height: reactionHeight,
                  decoration: BoxDecoration(
                    color: backColor.withOpacity(.4),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 8,
                      top: 8,
                      bottom: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var emoji in [
                        "👍",
                        "👎",
                        "🧐",
                        "❤️",
                        "‍🔥",
                        "😱",
                        "🤬",
                        "💩"
                      ])
                        EmojiReaction(
                          emoji: emoji,
                        )
                    ],
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  alignment: Alignment(alignX, -alignY),
                  child: child,
                );
              },
            ),
          ),
          Positioned(
            top: yOffset,
            left: xOffset,
            child: AnimatedBuilder(
              animation: scaleAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  alignment: Alignment(alignX, alignY),
                  child: child,
                );
              },
              child: BlurEffect(
                childBorderRadius: 14,
                child: Container(
                  width: menuWidth,
                  height: menuHeight,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      ContextItem(
                        title: context.loc.reply,
                        icon: CupertinoIcons.reply,
                      ),
                      SizedBox(
                        height: 8,
                        child: Container(
                          color: context.theme.appBarTheme.backgroundColor,
                        ),
                      ),
                      ContextItem(
                        title: context.loc.edit,
                        icon: IconlyLight.edit,
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: const Color(0xFF757575).withOpacity(0.6),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.pin,
                        icon: CupertinoIcons.pin,
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: const Color(0xFF757575).withOpacity(0.6),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.delete,
                        icon: IconlyLight.delete,
                      ),
                      SizedBox(
                        height: 8,
                        child: Container(
                          color: context.theme.appBarTheme.backgroundColor,
                        ),
                      ),
                      ContextItem(
                        title: context.loc.copy,
                        icon: Icons.copy_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: widget.childOffset.dy,
            left: widget.childOffset.dx,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: messageAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: messageAnimation.value,
                    alignment: Alignment(alignX, 0),
                    child: child,
                  );
                },
                child: SizedBox(
                  width: widget.childSize!.width,
                  height: widget.childSize!.height,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContextItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const ContextItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backColor = const Color(0xFF313131).withOpacity(0.7);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: backColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: context.textTheme.subtitle1!.copyWith(fontSize: 16),
          ),
          const Spacer(),
          Icon(icon, size: 20)
        ],
      ),
    );
  }
}

class EmojiReaction extends StatelessWidget {
  final String emoji;

  const EmojiReaction({
    Key? key,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }
}

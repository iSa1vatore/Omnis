import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/bloc/settings_bloc.dart';
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
  final double menuWidth = 230.4;
  final double menuHeight = 218;

  final double reactionWidth = 230;
  final double reactionHeight = 50;

  final double bottomOffset = 60;

  late AnimationController _animationController;
  late AnimationController _animationController2;
  late Animation<double> scaleAnimation;
  late Animation<double> messageAnimation;
  late Animation<double> blurAnimation;

  bool blurred = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..forward(from: 0.0);

    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _animationController2,
      curve: Curves.easeInCubic,
    ));

    blurred = context.read<SettingsBloc>().state.interfaceBlurEffect;

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_animationController.isAnimating) return;

              _animationController2.reverse();
              _animationController.reverse().whenCompleteOrCancel(
                    () => Navigator.pop(context),
                  );
            },
            child: AnimatedBuilder(
              animation: blurAnimation,
              builder: (BuildContext context, Widget? child) {
                if (blurred) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurAnimation.value,
                      sigmaY: blurAnimation.value,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(blurAnimation.value / 16),
                    ),
                  );
                }

                return Container(
                  color: Colors.black.withOpacity(blurAnimation.value / 16),
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
                backgroundColor: context.extraColors.contextMenuColor!,
                backgroundColorOpacity: .8,
                childBorderRadius: 50,
                child: SizedBox(
                  width: reactionWidth,
                  height: reactionHeight,
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
                        blurred: blurred,
                      ),
                      SizedBox(
                        height: 8,
                        child: Container(
                          color: context.theme.appBarTheme.backgroundColor!
                              .withOpacity(blurred ? .65 : 1),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.edit,
                        icon: IconlyLight.edit,
                        blurred: blurred,
                      ),
                      SizedBox(
                        height: 0.5,
                        child: Container(
                          color: const Color(0xFF757575),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.pin,
                        icon: CupertinoIcons.pin,
                        blurred: blurred,
                      ),
                      SizedBox(
                        height: 0.5,
                        child: Container(
                          color: const Color(0xFF757575),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.delete,
                        icon: IconlyLight.delete,
                        blurred: blurred,
                      ),
                      SizedBox(
                        height: 8,
                        child: Container(
                          color: context.theme.appBarTheme.backgroundColor!
                              .withOpacity(blurred ? .65 : 1),
                        ),
                      ),
                      ContextItem(
                        title: context.loc.copy,
                        icon: Icons.copy_rounded,
                        blurred: blurred,
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
  final bool blurred;

  const ContextItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.blurred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color:
            context.extraColors.contextMenuColor!.withOpacity(blurred ? .8 : 1),
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

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class AdaptiveAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final String? previousPageTitle;
  final Widget? child;
  final Widget? trailing;
  final double? height;

  const AdaptiveAppBar({
    Key? key,
    this.title,
    this.child,
    this.trailing,
    this.previousPageTitle,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return SizedBox(
          height: height,
          child: CupertinoNavigationBar(
            previousPageTitle: previousPageTitle,
            border: Border(
              bottom: BorderSide(
                color: context.theme.dividerColor,
                width: 1,
              ),
            ),
            backgroundColor: context.theme.appBarTheme.backgroundColor,
            middle: child ??
                Text(
                  title!,
                  style: TextStyle(
                    color: context.textTheme.titleLarge!.color,
                  ),
                ),
            trailing: trailing,
          ),
        );
      case TargetPlatform.android:
      default:
        return AppBar(
          title: child ??
              Text(
                title!,
                style: TextStyle(
                  color: context.textTheme.titleLarge!.color,
                ),
              ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.appBarTheme.backgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: context.theme.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

import '../bloc/settings_bloc.dart';

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
          child: BlocBuilder<SettingsBloc, SettingsState>(
              buildWhen: (prevState, state) =>
                  prevState.interfaceBlurEffect != state.interfaceBlurEffect,
              builder: (context, state) {
                return CupertinoNavigationBar(
                  previousPageTitle: previousPageTitle,
                  border: Border(
                    bottom: BorderSide(
                      color: context.theme.dividerColor,
                      width: 1,
                    ),
                  ),
                  backgroundColor: context.theme.appBarTheme.backgroundColor!
                      .withOpacity(state.interfaceBlurEffect ? 0.65 : 1),
                  middle: child ??
                      Text(
                        title!,
                        style: TextStyle(
                          color: context.textTheme.titleLarge!.color,
                        ),
                      ),
                  trailing: trailing,
                );
              }),
        );
      case TargetPlatform.android:
      default:
        return AppBar(
          centerTitle: false,
          title: child ??
              Text(
                title!,
                style: TextStyle(
                  color: context.textTheme.titleLarge!.color,
                ),
              ),
          backgroundColor: Colors.transparent,
          flexibleSpace: BlurEffect(
            backgroundColor: context.theme.appBarTheme.backgroundColor,
            backgroundColorOpacity: .65,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.theme.dividerColor,
                    width: 1,
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

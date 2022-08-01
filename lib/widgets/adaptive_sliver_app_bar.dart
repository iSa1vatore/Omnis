import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/bloc/settings_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

class AdaptiveSliverAppBar extends StatefulWidget {
  final String title;

  const AdaptiveSliverAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AdaptiveSliverAppBar> createState() => _AdaptiveSliverAppBarState();
}

class _AdaptiveSliverAppBarState extends State<AdaptiveSliverAppBar> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (prevState, state) =>
                prevState.interfaceBlurEffect != state.interfaceBlurEffect,
            builder: (context, state) {
              return CupertinoSliverNavigationBar(
                backgroundColor: context.theme.appBarTheme.backgroundColor!
                    .withOpacity(state.interfaceBlurEffect ? 0.65 : 1),
                largeTitle: Text(
                  widget.title,
                  style: TextStyle(color: context.textTheme.bodyMedium?.color),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: context.theme.dividerColor,
                    width: 1,
                  ),
                ),
              );
            });
      case TargetPlatform.android:
      default:
        return SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: 150,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onHeightChange(constraints.biggest.height);
              });

              return ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: BlurEffect(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                      buildWhen: (prevState, state) =>
                          prevState.interfaceBlurEffect !=
                          state.interfaceBlurEffect,
                      builder: (context, state) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: isCollapsed
                                ? context.theme.appBarTheme.backgroundColor!
                                    .withOpacity(
                                        state.interfaceBlurEffect ? .65 : 1)
                                : context.theme.scaffoldBackgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                color: isCollapsed
                                    ? context.theme.dividerColor
                                    : context.theme.scaffoldBackgroundColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: FlexibleSpaceBar(
                            title: Text(
                              widget.title,
                              style:
                                  Theme.of(context).appBarTheme.titleTextStyle,
                              textScaleFactor: 1.1,
                            ),
                            titlePadding: const EdgeInsetsDirectional.only(
                              start: 16.0,
                              bottom: 12.0,
                            ),
                          ),
                        );
                      }),
                ),
              );
            },
          ),
          pinned: true,
        );
    }
  }

  void onHeightChange(double height) {
    if (height == MediaQuery.of(context).padding.top + kToolbarHeight) {
      if (!isCollapsed) {
        setState(() {
          isCollapsed = true;
        });
      }
    } else {
      if (isCollapsed) {
        setState(() {
          isCollapsed = false;
        });
      }
    }
  }
}

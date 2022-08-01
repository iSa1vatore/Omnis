import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/bloc/settings_bloc.dart';

class BlurEffect extends StatelessWidget {
  final Widget child;
  final double? childBorderRadius;
  final Color? backgroundColor;
  final double? backgroundColorOpacity;
  final double sigma;

  const BlurEffect({
    Key? key,
    required this.child,
    this.childBorderRadius,
    this.backgroundColor,
    this.backgroundColorOpacity,
    this.sigma = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prevState, state) =>
          prevState.interfaceBlurEffect != state.interfaceBlurEffect,
      builder: (context, state) {
        var blurredWidget = child;

        if (backgroundColor != null) {
          var colorOpacity = 1.0;

          if (state.interfaceBlurEffect) {
            colorOpacity = backgroundColorOpacity!;
          }

          blurredWidget = ColoredBox(
            color: backgroundColor!.withOpacity(colorOpacity),
            child: blurredWidget,
          );
        }

        if (state.interfaceBlurEffect) {
          blurredWidget = ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: blurredWidget,
            ),
          );
        }

        if (childBorderRadius != null) {
          blurredWidget = ClipRRect(
            borderRadius: BorderRadius.circular(childBorderRadius!),
            child: blurredWidget,
          );
        }

        return blurredWidget;
      },
    );
  }
}

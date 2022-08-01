import 'package:domain/exceptions/failure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../utils/localize_failure.dart';
import 'adaptive_alert_dialog.dart';
import 'adaptive_alert_dialog_action.dart';

abstract class AdaptiveAlertDialogFactory {
  const AdaptiveAlertDialogFactory._();

  static void _showDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        return _showCupertinoDialog(
          context,
          title: title,
          content: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
      case TargetPlatform.android:
      default:
        return _showMaterialDialog(
          context,
          title: title,
          content: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
    }
  }

  static void _showCupertinoDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    showCupertinoDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  static void _showMaterialDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    showDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  static void showOKAlert(
    BuildContext context, {
    required String title,
    String? content,
    bool rootNavigator = false,
    VoidCallback? onPressed,
  }) {
    _showDialog(
      context,
      title: title,
      content: content,
      rootNavigator: rootNavigator,
      actions: <AdaptiveAlertDialogAction>[
        AdaptiveAlertDialogAction.adaptive(
          title: context.loc.ok,
          onPressed: onPressed ??
              () => Navigator.of(
                    context,
                    rootNavigator: rootNavigator,
                  ).pop(),
        ),
      ],
    );
  }

  static void showError(
    BuildContext context, {
    bool rootNavigator = false,
    VoidCallback? onPressed,
    required Failure failure,
  }) {
    var content = localizeFailure(context, failure);

    showOKAlert(
      context,
      title: context.loc.error,
      content: content,
      rootNavigator: rootNavigator,
      onPressed: onPressed,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class AdaptiveButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final IconData? icon;

  final bool _filled;
  final bool loading;

  final EdgeInsets padding;

  const AdaptiveButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  })  : _filled = false,
        super(key: key);

  const AdaptiveButton.filled({
    Key? key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  })  : _filled = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.platform.type) {
      case TargetPlatform.iOS:
        if (_filled) {
          return CupertinoButton.filled(
            padding: padding,
            onPressed: onPressed,
            child: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(title),
          );
        } else {
          return CupertinoButton(
            padding: padding,
            onPressed: onPressed,
            child: Text(title),
          );
        }
      case TargetPlatform.android:
      default:
        if (_filled) {
          if (icon != null && loading == false) {
            return ElevatedButton.icon(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              label: Text(title),
              icon: Icon(icon),
            );
          }
          return ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(title),
          );
        } else {
          return TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(title),
          );
        }
    }
  }
}

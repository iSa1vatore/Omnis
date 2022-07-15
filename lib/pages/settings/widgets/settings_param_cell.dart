import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class SettingsParamCell extends StatelessWidget {
  final String title;
  final Widget afterTitle;
  final Widget child;
  final String? caption;

  const SettingsParamCell({
    Key? key,
    required this.title,
    this.afterTitle = const SizedBox(),
    this.child = const SizedBox(),
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              Text(
                title,
                style: context.textTheme.subtitle2,
              ),
              const Spacer(),
              afterTitle
            ],
          ),
        ),
        child,
        if (caption != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              caption!,
              style: context.textTheme.caption,
            ),
          ),
      ],
    );
  }
}

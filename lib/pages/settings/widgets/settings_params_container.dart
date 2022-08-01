import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class SettingsParamsContainer extends StatelessWidget {
  final String? title;
  final EdgeInsets padding;
  final List<Widget> cells;

  const SettingsParamsContainer({
    Key? key,
    this.title,
    required this.cells,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderRadius = context.platform.isIos
        ? const BorderRadius.all(Radius.circular(12))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  context.platform.isAndroid ? context.theme.cardColor : null,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 14,
                bottom: context.platform.isAndroid ? 8 : 8,
                top: context.platform.isAndroid ? 8 : 0,
              ),
              child: Text(
                context.platform.isIos ? title!.toUpperCase() : title!,
                style: context.textTheme.caption!.copyWith(
                  color: context.platform.isAndroid
                      ? context.theme.colorScheme.primary
                      : null,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          padding: padding,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cells,
          ),
        ),
      ],
    );
  }
}

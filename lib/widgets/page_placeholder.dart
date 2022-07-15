import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

class PagePlaceholder extends StatelessWidget {
  final String message;
  final String desc;
  final String emoji;

  const PagePlaceholder({
    Key? key,
    required this.message,
    required this.desc,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.mediaQuerySize.height / 1.6,
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 54)),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.textTheme.caption!.copyWith(fontSize: 16),
          ),
          Container(
            width: 32,
            height: 2,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.dividerColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
          ),
          Text(
            desc,
            style: context.textTheme.caption!.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

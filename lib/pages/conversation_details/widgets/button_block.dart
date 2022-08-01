import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/tap_effect.dart';

class ButtonBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;

  const ButtonBlock({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchEffect(
      borderRadius: 10,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 8,
          top: 12,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: context.textTheme.caption!.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

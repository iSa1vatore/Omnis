import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/tap_effect.dart';

class ButtonBlock extends StatelessWidget {
  final IconData icon;
  final String title;

  const ButtonBlock({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchEffect(
      borderRadius: 10,
      onTap: () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

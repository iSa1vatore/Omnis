import 'package:flutter/cupertino.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/tap_effect.dart';

import 'divider.dart';

class CellList extends StatelessWidget {
  final List<Widget> children;

  const CellList({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemsList = [];

    var lastItem = children.last;

    for (var item in children) {
      itemsList.add(item);

      if (item == lastItem) continue;

      itemsList.add(
        const CellDivider(
          padding: EdgeInsets.only(left: 32 + 24),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
        ),
        child: Column(
          children: itemsList,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const ListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchEffect(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: context.theme.textTheme.subtitle1,
            ),
            const SizedBox(width: 8),
            Text(
              desc,
              style: context.textTheme.caption,
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.right_chevron,
              size: 18,
              color: context.extraColors.secondaryIconColor,
            )
          ],
        ),
      ),
    );
  }
}

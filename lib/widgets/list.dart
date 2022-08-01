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
  final IconData actionIcon;
  final String title;
  final String? desc;
  final GestureTapCallback? onTap;

  const ListItem({
    Key? key,
    required this.icon,
    this.actionIcon = CupertinoIcons.right_chevron,
    required this.title,
    this.onTap,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchEffect(
      onTap: onTap,
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
            Expanded(
              child: Text(
                title,
                style: context.theme.textTheme.subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            if (desc != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  desc!,
                  style: context.textTheme.caption,
                ),
              ),
            Icon(
              actionIcon,
              size: 18,
              color: context.extraColors.secondaryIconColor,
            )
          ],
        ),
      ),
    );
  }
}

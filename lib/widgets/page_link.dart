import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnis/widgets/tap_effect.dart';

import 'divider.dart';

class PageLink extends StatelessWidget {
  final String title;
  final IconData icon;
  final PageRouteInfo route;

  const PageLink({
    Key? key,
    required this.title,
    required this.icon,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return TouchEffect(
      onTap: () {
        context.router.push(route);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Text(title, style: theme.textTheme.subtitle2),
                const Spacer(),
                Icon(
                  CupertinoIcons.right_chevron,
                  size: 18,
                  color: theme.bottomNavigationBarTheme.unselectedItemColor,
                )
              ],
            ),
          ),
          const CellDivider(
            padding: EdgeInsets.only(left: 16 + 28 + 16),
          )
        ],
      ),
    );
  }
}

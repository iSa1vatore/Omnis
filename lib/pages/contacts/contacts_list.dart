import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../widgets/avatar.dart';
import '../../widgets/cell.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding().copyWith(top: 0);

    return SliverPadding(
      padding: bodyPadding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Cell(
              avatar: const Avatar(
                height: 50,
                width: 50,
                source: "emoji://🥑/green",
              ),
              title: "Alex Dudka",
              caption: "Online",
              before: Icon(
                IconlyLight.chat,
                color: context.theme.colorScheme.primary,
              ),
            );
          },
          childCount: 1,
        ),
      ),
    );
  }
}

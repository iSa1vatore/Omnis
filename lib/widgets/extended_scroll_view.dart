import 'package:flutter/material.dart';

class ExtendedScrollView extends StatelessWidget {
  final List<Widget> slivers;

  const ExtendedScrollView({
    Key? key,
    required this.slivers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> sliversList = slivers;

    sliversList += [
      const SliverPadding(padding: EdgeInsets.only(bottom: 95)),
    ];

    return CustomScrollView(
      slivers: sliversList,
    );
  }
}

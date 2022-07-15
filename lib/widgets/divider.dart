import 'package:flutter/cupertino.dart';
import 'package:omnis/extensions/build_context.dart';

class CellDivider extends StatelessWidget {
  final EdgeInsets padding;

  const CellDivider({
    Key? key,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      margin: padding,
      color: context.theme.dividerColor,
    );
  }
}

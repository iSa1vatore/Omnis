import 'package:flutter/cupertino.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';

class WriteBarReplyMessage extends StatelessWidget {
  const WriteBarReplyMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6, bottom: 12),
      height: 40,
      child: Row(
        children: [
          Transform.scale(
            scaleX: -1,
            child: Icon(
              CupertinoIcons.reply,
              color: context.theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Alexanger",
                style: context.textTheme.subtitle2,
              ),
              const SizedBox(height: 2),
              Text(
                "Message",
                style: context.theme.textTheme.caption!.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              IconlyLight.closeSquare,
              color: context.extraColors.secondaryIconColor,
            ),
          )
        ],
      ),
    );
  }
}

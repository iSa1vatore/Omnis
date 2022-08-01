import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/avatar.dart';
import 'package:omnis/widgets/tap_effect.dart';

import 'divider.dart';

class Cell extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget? captionWidget;
  final Avatar avatar;
  final Widget? before;
  final GestureTapCallback? onTap;

  const Cell({
    Key? key,
    required this.title,
    this.caption,
    this.captionWidget,
    required this.avatar,
    this.before,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cell = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    avatar,
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.theme.textTheme.subtitle2!
                                .copyWith(fontSize: 16),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          if (caption != null || captionWidget != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: captionWidget ??
                                  Text(
                                    caption!,
                                    style: context.theme.textTheme.caption!
                                        .copyWith(
                                      fontSize: 15,
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (before != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: before,
                )
            ],
          ),
        ),
        CellDivider(
          padding: EdgeInsets.only(left: 16 + avatar.width + 16),
        )
      ],
    );

    if (onTap != null) {
      return TouchEffect(
        onTap: onTap,
        child: cell,
      );
    }

    return cell;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

class VoiceRecordLock extends StatelessWidget {
  final double positionOffset;
  final bool isLocked;

  const VoiceRecordLock({
    Key? key,
    required this.positionOffset,
    required this.isLocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurEffect(
      childBorderRadius: 50,
      child: Container(
        height: isLocked ? 40 : 70 - positionOffset,
        decoration: BoxDecoration(
          color: context.theme.cardColor.withOpacity(.6),
          border: Border.all(color: context.theme.dividerColor),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.only(
          left: 6,
          right: 6,
          bottom: 8,
          top: 4,
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: isLocked ? 0 : 1,
              child: SizedBox(
                width: 24,
                child: Icon(
                  IconlyLight.arrowUp2,
                  size: 18,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Icon(
                isLocked ? IconlyLight.lock : IconlyLight.unlock,
                color: context.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

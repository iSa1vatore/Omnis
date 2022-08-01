import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/icon_btn.dart';
import 'package:omnis/utils/date_time_utils.dart';
import 'package:omnis/widgets/blur_effect.dart';
import 'package:omnis/widgets/tap_effect.dart';

import '../../../bloc/voice_player_cubit.dart';

class VoiceMessagePlayer extends StatelessWidget {
  const VoiceMessagePlayer({
    Key? key,
    this.inAppBar = true,
  }) : super(key: key);

  final bool inAppBar;
  static const playerHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    final bodyPadding = context.safePadding();

    final playerWidth = context.mediaQuerySize.width;

    var voicePlayer = context.read<VoicePlayerCubit>();

    return BlocBuilder<VoicePlayerCubit, VoicePlayerState>(
        builder: (context, state) {
      if (state.currentPlayingItem == null) return const SizedBox();

      return Container(
        padding: bodyPadding,
        child: BlurEffect(
          backgroundColor: context.theme.appBarTheme.backgroundColor,
          backgroundColorOpacity: .65,
          child: SizedBox(
            height: VoiceMessagePlayer.playerHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: inAppBar
                    ? Border(
                        bottom: BorderSide(
                          color: context.theme.dividerColor,
                          width: 1,
                        ),
                      )
                    : Border(
                        top: BorderSide(
                          color: context.theme.dividerColor,
                          width: 1,
                        ),
                      ),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    bottom: 0,
                    height: 1,
                    width: playerWidth * (state.playingProgress / 100),
                    duration: const Duration(milliseconds: 60),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconBtn(
                        onTap: voicePlayer.togglePlay,
                        icon: state.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow_rounded,
                        iconColor: context.theme.colorScheme.primary,
                        iconSize: 24,
                      ),
                      Text(
                        state.currentPlayingItem?.author ?? "",
                        style: context.textTheme.subtitle2!.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateTimeUtils.getDuration(state.remainingPlaybackTime),
                        style: context.textTheme.caption,
                      ),
                      const SizedBox(width: 8),
                      TouchEffect(
                        onTap: voicePlayer.toggleDoubleSpeed,
                        borderRadius: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: state.doubleSpeedEnabled
                                  ? context.theme.colorScheme.primary
                                  : context.theme.dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "2X",
                            style: context.textTheme.caption!.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: state.doubleSpeedEnabled
                                    ? context.theme.colorScheme.primary
                                    : null),
                          ),
                        ),
                      ),
                      IconBtn(
                        onTap: voicePlayer.stop,
                        icon: Icons.close_rounded,
                        iconSize: 24,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

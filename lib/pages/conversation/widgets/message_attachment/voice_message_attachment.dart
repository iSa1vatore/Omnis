import 'package:domain/model/message_attachment/message_attachment_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/bloc/conversation_bloc.dart';
import 'package:omnis/bloc/voice_player_cubit.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../utils/audio_waveform_utils.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../widgets/tap_effect.dart';
import '../voice_wave_form.dart';

class VoiceMessageAttachment extends StatefulWidget {
  final MessageAttachmentVoice voiceDetails;
  final bool isOut;
  final int messageId;

  const VoiceMessageAttachment(this.voiceDetails, {
    Key? key,
    required this.isOut,
    required this.messageId,
  }) : super(key: key);

  @override
  State<VoiceMessageAttachment> createState() => _VoiceMessageAttachmentState();
}

class _VoiceMessageAttachmentState extends State<VoiceMessageAttachment>
    with TickerProviderStateMixin {
  late final AnimationController playPauseIconAnimation;

  @override
  void initState() {
    playPauseIconAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = context.mediaQuerySize.width * .3;
    int maxLength;

    var waveWidth = widget.voiceDetails.waveform.length * 3.5;

    if (waveWidth > maxWidth) {
      maxLength = maxWidth ~/ 3.5;
    } else {
      maxWidth = waveWidth;
      maxLength = widget.voiceDetails.waveform.length;
    }

    var maxHeight = 20.0;

    var textColor = widget.isOut
        ? context.extraColors.messageTextColor!
        : context.extraColors.outMessageTextColor!;

    var waveform = AudioWaveFormUtils.resize(
      maxHeight: maxHeight,
      maxLength: maxLength,
      waveList: widget.voiceDetails.waveform,
    );

    var voicePlayer = context.read<VoicePlayerCubit>();

    return BlocBuilder<VoicePlayerCubit, VoicePlayerState>(
      buildWhen: (prevState, state) =>
      prevState.currentPlayingItem?.fileId == widget.voiceDetails.fileId ||
          state.currentPlayingItem?.fileId == widget.voiceDetails.fileId,
      builder: (context, state) {
        int waveProgress;
        int durationLeft;

        if (state.currentPlayingItem?.fileId == widget.voiceDetails.fileId) {
          if (state.isPlaying) {
            playPauseIconAnimation.forward();
          } else {
            playPauseIconAnimation.reverse();
          }

          durationLeft = state.remainingPlaybackTime;

          waveProgress =
              (waveform.length * (state.playingProgress / 100)).toInt();
        } else {
          durationLeft = widget.voiceDetails.duration;
          playPauseIconAnimation.reverse();
          waveProgress = waveform.length;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TouchEffect(
                borderRadius: 50,
                onTap: () {
                  if (state.currentPlayingItem != null) {
                    voicePlayer.togglePlay();
                  } else {
                    context
                        .read<ConversationBloc>()
                        .add(ConversationEvent.playVoiceMessage(
                      voice: widget.voiceDetails,
                      messageId: widget.messageId,
                    ));
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: textColor, width: 2),
                  ),
                  child: Center(
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      color: textColor,
                      progress: playPauseIconAnimation,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: maxHeight,
                      width: maxWidth,
                      child: CustomPaint(
                        willChange: true,
                        painter: VoiceWaveForm(
                          color: textColor,
                          height: maxHeight,
                          progress: waveProgress,
                          waveform: waveform,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateTimeUtils.getDuration(durationLeft),
                      style: context.textTheme.caption!.copyWith(
                        color: textColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

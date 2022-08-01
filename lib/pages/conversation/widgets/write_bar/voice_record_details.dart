import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/voice_wave_form.dart';
import 'package:omnis/widgets/widgets_switcher.dart';

import '../../../../bloc/conversation_bloc.dart';
import '../../../../utils/audio_waveform_utils.dart';
import '../../conversation.dart';

class VoiceRecordDetails extends StatelessWidget {
  const VoiceRecordDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiController = ConversationPageState.uiControllerOf(context);

    return Stack(
      children: [
        const SizedBox(
          width: 32,
          height: 32,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 2, right: 4),
              child: BlocBuilder<ConversationBloc, ConversationState>(
                buildWhen: (prevState, state) =>
                    prevState.isPermanentVoiceRecording !=
                    state.isPermanentVoiceRecording,
                builder: (context, state) {
                  return WidgetsSwitcher(
                    duration: 250,
                    selected: state.isPermanentVoiceRecording ? 0 : 1,
                    children: [
                      Icon(
                        CupertinoIcons.pause_circle_fill,
                        color: context.theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox()
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return StreamBuilder<List<double>>(
                      initialData: const [],
                      stream: context
                          .read<ConversationBloc>()
                          .voiceAudioAmplitudeStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var maxLength = constraints.minWidth ~/ 3.5;

                          var maxHeight = 17.0;

                          return CustomPaint(
                            willChange: true,
                            painter: VoiceWaveForm(
                              color: context.extraColors.secondaryIconColor!,
                              height: maxHeight,
                              progress: -1,
                              waveform: AudioWaveFormUtils.convertToLivePreview(
                                maxLength: maxLength,
                                maxHeight: maxHeight,
                                waveList: snapshot.data!,
                              ),
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 12),
              child: Text(
                "00:12",
                style: context.textTheme.caption,
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Observer(builder: (_) {
            return AnimatedOpacity(
              opacity: uiController.writeBarXOffset < -50 ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: context.theme.cardColor.withOpacity(.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    context.loc.cancel,
                    style: TextStyle(
                      color: context.extraColors.dangerColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/widgets/voice_wave_form.dart';
import 'package:omnis/widgets/widgets_switcher.dart';

import '../../../utils/audio_waveform_utils.dart';

class VoiceRecordDetails extends StatelessWidget {
  final bool showCancelLabel;
  final bool permanentRecord;
  final Stream<List<double>> Function() waveformStream;

  const VoiceRecordDetails({
    Key? key,
    required this.showCancelLabel,
    required this.permanentRecord,
    required this.waveformStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(
                left: 2,
                top: 2,
                right: 4,
              ),
              child: WidgetsSwitcher(
                duration: 250,
                selected: permanentRecord ? 0 : 1,
                children: [
                  Icon(
                    CupertinoIcons.pause_circle_fill,
                    color: context.theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox()
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      StreamBuilder<List<double>>(
                    initialData: const [],
                    stream: waveformStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var maxLength = constraints.minWidth ~/ 3.5;

                        var maxHeight = 17.0;

                        return CustomPaint(
                          willChange: true,
                          painter: VoiceWaveForm(
                            color: context.extraColors.secondaryIconColor!,
                            height: maxHeight,
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
                  ),
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
          child: AnimatedOpacity(
            opacity: showCancelLabel ? 1 : 0,
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
          ),
        ),
      ],
    );
  }
}

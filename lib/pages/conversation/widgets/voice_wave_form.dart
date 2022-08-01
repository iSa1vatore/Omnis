import 'package:flutter/material.dart';

class VoiceWaveForm extends CustomPainter {
  final Color color;
  final double height;
  List<double> waveform;
  final int progress;

  VoiceWaveForm({
    required this.color,
    required this.height,
    required this.waveform,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    paint.color = color;

    double waveNum = 0;
    for (var waveformValue2 in waveform) {
      double waveformValue = waveformValue2.toDouble();

      waveformValue += height / 2;

      if (waveformValue > height) {
        waveformValue = height;
      }

      double waveformYOffset = height - waveformValue;

      if (waveNum > progress) {
        paint.color = color.withOpacity(0.5);
      }

      canvas.drawLine(
        Offset(waveNum * 3.5, waveformYOffset),
        Offset(waveNum * 3.5, waveformValue),
        paint,
      );

      waveNum += 1;
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWaveForm oldDelegate) =>
      oldDelegate.waveform != waveform || oldDelegate.progress != progress;
}

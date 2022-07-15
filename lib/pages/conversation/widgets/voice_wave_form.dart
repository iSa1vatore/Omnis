import 'package:flutter/material.dart';

class VoiceWaveForm extends CustomPainter {
  final Color color;
  final double height;
  List<double> waveform;

  VoiceWaveForm({
    required this.color,
    required this.height,
    required this.waveform,
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

      paint.color = color;

      canvas.drawLine(
        Offset(waveNum, waveformYOffset),
        Offset(waveNum, waveformValue),
        paint,
      );

      waveNum += 3.5;
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWaveForm oldDelegate) =>
      oldDelegate.waveform != waveform;
}

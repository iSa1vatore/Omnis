import 'package:record/record.dart';

abstract class VoiceRecorderService {
  Future<void> start();

  Future<void> pause();

  Future<void> resume();

  Future<String?> stop();

  Future<Amplitude> getAmplitude();
}

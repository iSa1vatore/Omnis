import 'package:domain/model/audio_item.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioService {
  Future<void> play(AudioItem? audioItem);

  Future<void> pause();

  Future<void> stop();

  Future<void> setSpeed(double speed);

  Stream<Duration> get positionStream;

  double get speed;

  AudioItem? get currentItem;

  Stream<PlayerState> get playerStateStream;

  Duration? get duration;
}

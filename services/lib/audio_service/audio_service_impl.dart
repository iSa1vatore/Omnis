import 'package:common/logs.dart';
import 'package:domain/model/audio_item.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:services/audio_service/audio_service.dart';

@Singleton(as: AudioService)
class AudioServiceImpl extends AudioService {
  AudioServiceImpl(this.player) {
    player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _currentItem = null;
      }
    });
  }

  final AudioPlayer player;

  AudioItem? _currentItem;

  @override
  Stream<Duration> get positionStream => player.positionStream;

  @override
  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  @override
  Duration? get duration => player.duration;

  @override
  double get speed => player.speed;

  @override
  Future<void> play(AudioItem? audioItem) async {
    try {
      if (audioItem != null) {
        await player.setFilePath(audioItem.path);

        _currentItem = audioItem;
      }

      await player.play();
    } catch (e) {
      Log.e("Voice message player: load file error");
      return;
    }
  }

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> stop() async {
    _currentItem = null;
    await player.stop();
  }

  @override
  Future<void> setSpeed(double speed) async {
    await player.setSpeed(speed);
  }

  @override
  AudioItem? get currentItem => _currentItem;
}

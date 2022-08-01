import 'package:domain/model/audio_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:services/audio_service/audio_service.dart';

part 'voice_player_cubit.freezed.dart';

@injectable
class VoicePlayerCubit extends Cubit<VoicePlayerState> {
  final AudioService audioService;

  VoicePlayerCubit(this.audioService) : super(const VoicePlayerState()) {
    emit(state.copyWith(doubleSpeedEnabled: audioService.speed == 2));

    audioService.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        emit(VoicePlayerState(
          doubleSpeedEnabled: state.doubleSpeedEnabled,
        ));
      }

      if (state.currentPlayingItem != audioService.currentItem) {
        emit(state.copyWith(currentPlayingItem: audioService.currentItem));
      }

      if (playerState.playing != state.isPlaying) {
        emit(state.copyWith(isPlaying: playerState.playing));
      }
    });

    audioService.positionStream.listen((position) {
      if (!state.isPlaying || audioService.duration == null) return;

      var duration = audioService.duration!.inMilliseconds;
      var remainingPlaybackTime = duration ~/ 1000 - position.inSeconds;

      var playingProgress = (position.inMilliseconds / duration) * 100;

      emit(state.copyWith(
        playingProgress: playingProgress.toInt(),
        remainingPlaybackTime: remainingPlaybackTime,
      ));
    });
  }

  void togglePlay() {
    if (state.isPlaying) {
      audioService.pause();
    } else {
      audioService.play(null);
    }
  }

  void toggleDoubleSpeed() {
    if (state.doubleSpeedEnabled) {
      emit(state.copyWith(doubleSpeedEnabled: false));

      audioService.setSpeed(1);
    } else {
      emit(state.copyWith(doubleSpeedEnabled: true));

      audioService.setSpeed(2);
    }
  }

  stop() {
    audioService.stop();

    emit(VoicePlayerState(
      doubleSpeedEnabled: state.doubleSpeedEnabled,
    ));
  }
}

@freezed
class VoicePlayerState with _$VoicePlayerState {
  const factory VoicePlayerState({
    @Default(false) bool isPlaying,
    @Default(false) bool doubleSpeedEnabled,
    @Default(0) int playingProgress,
    @Default(0) int duration,
    @Default(0) int remainingPlaybackTime,
    AudioItem? currentPlayingItem,
  }) = Initial;
}

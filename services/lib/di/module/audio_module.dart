import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

@module
abstract class AudioModule {
  @injectable
  Record get record => Record();

  @injectable
  AudioPlayer get audioPlayer => AudioPlayer();
}

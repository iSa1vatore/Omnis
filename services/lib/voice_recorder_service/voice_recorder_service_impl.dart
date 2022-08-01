import 'dart:io';

import 'package:common/utils/random_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:services/files_cache_service/files_cache_service.dart';
import 'package:services/voice_recorder_service/voice_recorder_service.dart';

@Singleton(as: VoiceRecorderService)
class VoiceRecorderServiceImpl extends VoiceRecorderService {
  final Record audioRecorder;
  final FilesCacheService filesCacheService;

  VoiceRecorderServiceImpl(this.audioRecorder, this.filesCacheService);

  @override
  Future<void> start() async {
    var voiceMessagesDir = await filesCacheService.voiceMessagesDir;

    final voiceMessageFilePath =
        "$voiceMessagesDir/${RandomUtils.generateString(16)}.m4a";

    await audioRecorder.start(
      path: voiceMessageFilePath,
      encoder: AudioEncoder.aacLc,
    );
  }

  @override
  Future<String?> stop() async {
    String? voiceMessagePath = await audioRecorder.stop();

    if (voiceMessagePath != null) {
      var fileId = path.basenameWithoutExtension(voiceMessagePath);
      var fileName = "voice-message.m4a";

      await filesCacheService.saveVoiceMessage(
        file: File(voiceMessagePath),
        fileId: fileId,
        fileName: fileName,
        copyInStorage: false,
      );
    }

    return voiceMessagePath;
  }

  @override
  Future<void> pause() async {
    return audioRecorder.pause();
  }

  @override
  Future<void> resume() async {
    return audioRecorder.resume();
  }

  @override
  Future<Amplitude> getAmplitude() => audioRecorder.getAmplitude();
}

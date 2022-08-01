import 'dart:io';

abstract class FilesCacheService {
  Future<String> get voiceMessagesDir;

  Future<String> get imagesDir;

  Future<String> get tmpDir;

  Future<String> saveImage({
    required File file,
    String? fileId,
    String? fileName,
    bool copyInStorage = true,
  });

  Future<String> saveVoiceMessage({
    required File file,
    String? fileId,
    String? fileName,
    bool copyInStorage,
  });
}

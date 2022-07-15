import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/files_cache_service/files_cache_service.dart';

@Singleton(as: FilesCacheService)
class FilesCacheServiceImpl extends FilesCacheService {
  static const String _relativeVoiceMessagesDir = '/files_cache/voice_messages';

  @override
  Future<String> get voiceMessagesDir async {
    Directory appLibraryDir = await getApplicationDocumentsDirectory();
    String voiceMessagesDir = "${appLibraryDir.path}$_relativeVoiceMessagesDir";

    Directory voiceMessagesFolder = Directory(voiceMessagesDir);
    bool voiceMessagesFolderExists = await voiceMessagesFolder.exists();

    if (!voiceMessagesFolderExists) {
      await voiceMessagesFolder.create(recursive: true);
    }

    return voiceMessagesDir;
  }
}

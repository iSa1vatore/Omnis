import 'dart:io';

import 'package:common/utils/random_utils.dart';
import 'package:domain/model/cached_file.dart';
import 'package:domain/repository/cached_files_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:services/files_cache_service/files_cache_service.dart';

@Singleton(as: FilesCacheService)
class FilesCacheServiceImpl extends FilesCacheService {
  FilesCacheServiceImpl(this.cachedFilesRepository);

  final CachedFilesRepository cachedFilesRepository;

  static const String _relativeVoiceMessagesDir = '/files_cache/voice_messages';
  static const String _relativeImagesDir = '/files_cache/images';

  Future<String> get persistentCacheDir async =>
      (await getApplicationDocumentsDirectory()).path;

  @override
  Future<String> get tmpDir async => (await getTemporaryDirectory()).path;

  @override
  Future<String> get voiceMessagesDir async {
    var appLibraryDir = await persistentCacheDir;

    var voiceMessagesDir = Directory(
      "$appLibraryDir$_relativeVoiceMessagesDir",
    );

    if (!await voiceMessagesDir.exists()) {
      await voiceMessagesDir.create(recursive: true);
    }

    return voiceMessagesDir.path;
  }

  @override
  Future<String> get imagesDir async {
    var appLibraryDir = await persistentCacheDir;

    var imagesDir = Directory("$appLibraryDir$_relativeImagesDir");

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir.path;
  }

  Future<String> _saveFile({
    required File file,
    required String basePath,
    String? fileId,
    String? fileName,
    bool copyInStorage = true,
  }) async {
    var ext = path.extension(file.path);

    fileId ??= RandomUtils.generateString(16);
    fileName ??= path.basename(file.path);

    var filePath = "$basePath/$fileId$ext";

    if (copyInStorage) await file.copy(filePath);

    await cachedFilesRepository.add(CachedFile(
      id: 0,
      fileId: fileId!,
      fileName: fileName,
      path: filePath,
      length: file.lengthSync(),
    ));

    if (copyInStorage) await file.delete();

    return filePath;
  }

  @override
  Future<String> saveImage({
    required File file,
    String? fileId,
    String? fileName,
    bool copyInStorage = true,
  }) async =>
      _saveFile(
        file: file,
        basePath: await imagesDir,
        fileId: fileId,
        fileName: fileName,
        copyInStorage: copyInStorage,
      );

  @override
  Future<String> saveVoiceMessage({
    required File file,
    String? fileId,
    String? fileName,
    bool copyInStorage = true,
  }) async =>
      _saveFile(
        file: file,
        basePath: await voiceMessagesDir,
        fileId: fileId,
        fileName: fileName,
        copyInStorage: copyInStorage,
      );
}

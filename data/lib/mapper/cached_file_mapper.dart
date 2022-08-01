import 'package:data/sources/local/db/entity/cached_file_entity.dart';
import 'package:domain/model/cached_file.dart';

extension CachedFileEntityToCachedFile on CachedFileEntity {
  CachedFile toCachedFile() => CachedFile(
        id: id!,
        fileId: fileId,
        fileName: fileName,
        path: path,
        length: length,
      );
}

extension CachedFileToCachedFileEntity on CachedFile {
  CachedFileEntity toCachedFileEntity() => CachedFileEntity(
        fileId: fileId,
        fileName: fileName,
        path: path,
        length: length,
      );
}

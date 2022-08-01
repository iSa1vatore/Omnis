import 'package:dartz/dartz.dart';
import 'package:domain/model/cached_file.dart';

import '../exceptions/cached_file_failure.dart';

abstract class CachedFilesRepository {
  Future<Either<CachedFileFailure, CachedFile>> findByFileId(String fileId);

  Future<Either<CachedFileFailure, Unit>> add(CachedFile cachedFile);

  Future<Either<CachedFileFailure, Unit>> delete(CachedFile cachedFile);
}

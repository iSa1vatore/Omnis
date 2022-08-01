import 'package:dartz/dartz.dart';
import 'package:data/mapper/cached_file_mapper.dart';
import 'package:domain/exceptions/cached_file_failure.dart';
import 'package:domain/model/cached_file.dart';
import 'package:domain/repository/cached_files_repository.dart';
import 'package:injectable/injectable.dart';

import '../sources/local/db/app_database.dart';
import '../sources/local/db/dao/cached_file_dao.dart';

@Singleton(as: CachedFilesRepository)
class CachedFilesRepositoryImpl extends CachedFilesRepository {
  final AppDatabase db;

  late CachedFileDao _dao;

  CachedFilesRepositoryImpl(this.db) {
    _dao = db.cachedFileDao;
  }

  @override
  Future<Either<CachedFileFailure, Unit>> add(CachedFile cachedFile) async {
    try {
      var file = await _dao.insertCachedFile(cachedFile.toCachedFileEntity());

      if (file != 0) const Right(unit);

      return const Left(CachedFileFailure.createError());
    } catch (_) {
      return const Left(CachedFileFailure.dbError());
    }
  }

  @override
  Future<Either<CachedFileFailure, Unit>> delete(CachedFile cachedFile) async {
    try {
      var file = await _dao.deleteCachedFile(cachedFile.toCachedFileEntity());

      if (file != 0) const Right(unit);

      return const Left(CachedFileFailure.deleteError());
    } catch (_) {
      return const Left(CachedFileFailure.dbError());
    }
  }

  @override
  Future<Either<CachedFileFailure, CachedFile>> findByFileId(
    String fileId,
  ) async {
    try {
      var file = await _dao.findCachedFileByFileId(fileId);

      if (file != null) return Right(file.toCachedFile());

      return const Left(CachedFileFailure.doesNotExist());
    } catch (_) {
      return const Left(CachedFileFailure.dbError());
    }
  }
}

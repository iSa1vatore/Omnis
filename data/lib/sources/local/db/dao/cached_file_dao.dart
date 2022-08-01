import 'package:floor/floor.dart';

import '../entity/cached_file_entity.dart';

@dao
abstract class CachedFileDao {
  @Query("SELECT * FROM cached_files WHERE file_id = :fileId")
  Future<CachedFileEntity?> findCachedFileByFileId(String fileId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertCachedFile(CachedFileEntity cachedFileEntity);

  @delete
  Future<int> deleteCachedFile(CachedFileEntity cachedFileEntity);
}

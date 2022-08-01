import 'package:floor/floor.dart';

@Entity(tableName: "cached_files")
class CachedFileEntity {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'file_id')
  final String fileId;
  @ColumnInfo(name: 'file_name')
  final String fileName;
  final String path;
  final int length;

  CachedFileEntity({
    this.id,
    required this.fileId,
    required this.fileName,
    required this.path,
    required this.length,
  });
}

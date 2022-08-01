class CachedFile {
  final int id;
  final String fileId;
  final String fileName;
  final String path;
  final int length;

  const CachedFile({
    required this.id,
    required this.fileId,
    required this.fileName,
    required this.path,
    required this.length,
  });
}

class AudioItem {
  final String path;
  final String fileId;
  final String author;

  const AudioItem({
    required this.path,
    required this.author,
    required this.fileId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioItem &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          fileId == other.fileId &&
          author == other.author;

  @override
  int get hashCode => path.hashCode ^ fileId.hashCode ^ author.hashCode;
}

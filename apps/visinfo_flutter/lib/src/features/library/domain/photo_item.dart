class PhotoItem {
  const PhotoItem({
    required this.id,
    required this.storagePath,
    required this.createdAt,
    this.title,
    this.summary,
    this.tags = const <String>[],
  });

  final String id;
  final String storagePath;
  final DateTime createdAt;
  final String? title;
  final String? summary;
  final List<String> tags;
}

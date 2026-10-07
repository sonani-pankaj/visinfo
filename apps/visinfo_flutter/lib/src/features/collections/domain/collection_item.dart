class CollectionItem {
  const CollectionItem({
    required this.id,
    required this.name,
    this.description,
    this.photoIds = const <String>[],
  });

  final String id;
  final String name;
  final String? description;
  final List<String> photoIds;
}

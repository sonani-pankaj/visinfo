class TagItem {
  const TagItem({
    required this.id,
    required this.name,
    this.color,
  });

  final String id;
  final String name;
  final String? color;
}

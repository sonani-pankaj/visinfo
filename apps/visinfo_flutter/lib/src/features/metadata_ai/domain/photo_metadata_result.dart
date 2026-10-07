class PhotoMetadataResult {
  const PhotoMetadataResult({
    required this.title,
    required this.summary,
    required this.suggestedTags,
    required this.confidence,
  });

  final String title;
  final String summary;
  final List<String> suggestedTags;
  final double confidence;
}

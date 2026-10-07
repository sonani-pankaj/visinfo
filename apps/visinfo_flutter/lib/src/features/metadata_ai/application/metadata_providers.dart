import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/observability/observability_providers.dart';
import '../domain/metadata_extractor.dart';
import 'metadata_pipeline_service.dart';

final metadataExtractorProvider = Provider<MetadataExtractor>((Ref ref) {
  return LocalLlmMetadataExtractor();
});

final metadataPipelineProvider = Provider<MetadataPipelineService>((Ref ref) {
  return MetadataPipelineService(
    ref.watch(metadataExtractorProvider),
    ref.watch(appLoggerProvider),
  );
});

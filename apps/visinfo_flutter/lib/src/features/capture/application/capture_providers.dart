import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../library/application/library_providers.dart';
import '../../metadata_ai/application/metadata_providers.dart';
import 'photo_ingestion_service.dart';

final photoIngestionServiceProvider = Provider<PhotoIngestionService>((Ref ref) {
  return PhotoIngestionService(
    photoRepository: ref.watch(photoRepositoryProvider),
    metadataPipeline: ref.watch(metadataPipelineProvider),
  );
});

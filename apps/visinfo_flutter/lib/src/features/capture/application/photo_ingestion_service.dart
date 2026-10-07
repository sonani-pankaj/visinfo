import 'dart:typed_data';

import '../../library/domain/photo_item.dart';
import '../../library/domain/photo_repository.dart';
import '../../metadata_ai/application/metadata_pipeline_service.dart';

class PhotoIngestionService {
  PhotoIngestionService({
    required PhotoRepository photoRepository,
    required MetadataPipelineService metadataPipeline,
  })  : _photoRepository = photoRepository,
        _metadataPipeline = metadataPipeline;

  final PhotoRepository _photoRepository;
  final MetadataPipelineService _metadataPipeline;

  Future<MetadataExtractionOutcome> ingestPhoto({
    required PhotoItem photo,
    required Uint8List imageBytes,
    required String deviceModel,
  }) async {
    await _photoRepository.createPhoto(photo);
    return _metadataPipeline.extractWithFallback(
      imageBytes: imageBytes,
      capturedAt: photo.createdAt,
      deviceModel: deviceModel,
    );
  }
}

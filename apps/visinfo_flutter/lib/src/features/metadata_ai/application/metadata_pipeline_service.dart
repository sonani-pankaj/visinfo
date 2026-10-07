import 'dart:typed_data';

import '../../../core/observability/app_logger.dart';
import '../domain/metadata_extractor.dart';
import '../domain/photo_metadata_result.dart';

class MetadataExtractionOutcome {
  const MetadataExtractionOutcome({
    required this.result,
    required this.usedFallback,
    this.fallbackReason,
  });

  final PhotoMetadataResult result;
  final bool usedFallback;
  final String? fallbackReason;
}

class MetadataPipelineService {
  MetadataPipelineService(this._extractor, this._logger);

  final MetadataExtractor _extractor;
  final AppLogger _logger;

  Future<MetadataExtractionOutcome> extractWithFallback({
    required Uint8List imageBytes,
    required DateTime capturedAt,
    required String deviceModel,
  }) async {
    try {
      final result = await _extractor.extract(imageBytes);
      if (result.confidence >= 0.4) {
        _logger.info(
          'Metadata extraction succeeded',
          context: <String, Object?>{'confidence': result.confidence},
        );
        return MetadataExtractionOutcome(
          result: result,
          usedFallback: false,
        );
      }
      _logger.warning(
        'Metadata extraction low confidence, using fallback',
        context: <String, Object?>{'confidence': result.confidence},
      );
      return MetadataExtractionOutcome(
        result: _exifFallback(capturedAt: capturedAt, deviceModel: deviceModel),
        usedFallback: true,
        fallbackReason: 'Low confidence AI output',
      );
    } on UnsupportedError catch (e) {
      _logger.warning(
        'Metadata extraction unsupported on platform, using fallback',
        context: <String, Object?>{'reason': e.message},
      );
      return MetadataExtractionOutcome(
        result: _exifFallback(capturedAt: capturedAt, deviceModel: deviceModel),
        usedFallback: true,
        fallbackReason: e.message,
      );
    } on Exception catch (e) {
      _logger.error(
        'Metadata extraction failed, using fallback',
        error: e,
      );
      return MetadataExtractionOutcome(
        result: _exifFallback(capturedAt: capturedAt, deviceModel: deviceModel),
        usedFallback: true,
        fallbackReason: e.toString(),
      );
    }
  }

  PhotoMetadataResult _exifFallback({
    required DateTime capturedAt,
    required String deviceModel,
  }) {
    return PhotoMetadataResult(
      title: 'Photo ${capturedAt.toIso8601String()}',
      summary: 'Captured on $deviceModel',
      suggestedTags: const <String>['captured'],
      confidence: 0.2,
    );
  }
}

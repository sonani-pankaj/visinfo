import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'photo_metadata_result.dart';

abstract class MetadataExtractor {
  Future<PhotoMetadataResult> extract(Uint8List imageBytes);
}

class LocalLlmMetadataExtractor implements MetadataExtractor {
  @override
  Future<PhotoMetadataResult> extract(Uint8List imageBytes) async {
    if (kIsWeb) {
      throw UnsupportedError('Local LLM extraction is mobile-only in V1.');
    }

    // TODO: Replace with actual on-device model invocation and schema parsing.
    return const PhotoMetadataResult(
      title: 'Untitled photo',
      summary: 'Metadata extraction placeholder result.',
      suggestedTags: <String>['photo'],
      confidence: 0.0,
    );
  }
}

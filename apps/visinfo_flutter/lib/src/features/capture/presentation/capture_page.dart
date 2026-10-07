import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feature_gates/feature_gates.dart';
import '../../library/domain/photo_item.dart';
import '../application/capture_providers.dart';

class CapturePage extends ConsumerWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const gates = FeatureGates(UserEntitlement(planTier: PlanTier.free, active: true));

    return Scaffold(
      appBar: AppBar(title: const Text('Capture')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FilledButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final photo = PhotoItem(
                  id: now.microsecondsSinceEpoch.toString(),
                  storagePath: 'placeholder/${now.microsecondsSinceEpoch}.jpg',
                  createdAt: now,
                );
                final outcome = await ref.read(photoIngestionServiceProvider).ingestPhoto(
                      photo: photo,
                      imageBytes: Uint8List(0),
                      deviceModel: 'unknown',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        outcome.usedFallback
                            ? 'Saved with fallback metadata: ${outcome.fallbackReason}'
                            : 'Saved with local AI metadata',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text('Upload Photo'),
            ),
            const SizedBox(height: 24),
            Text(
              gates.canUseLocalMetadataExtraction
                  ? 'On-device metadata extraction is available on this platform.'
                  : 'Metadata extraction is disabled on web in V1.',
            ),
          ],
        ),
      ),
    );
  }
}

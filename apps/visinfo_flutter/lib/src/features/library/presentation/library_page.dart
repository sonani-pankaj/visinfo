import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/library_providers.dart';
import '../domain/photo_item.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<PhotoItem>>(
      future: ref.read(photoRepositoryProvider).listPhotos(),
      builder: (BuildContext context, AsyncSnapshot<List<PhotoItem>> snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;
        final photos = snapshot.data ?? <PhotoItem>[];

        return Scaffold(
          appBar: AppBar(title: const Text('Library')),
          body: Builder(
            builder: (BuildContext context) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (hasError) {
                return Center(child: Text('Unable to load photos: ${snapshot.error}'));
              }
              if (photos.isEmpty) {
                return const Center(child: Text('No photos yet. Capture or upload to begin.'));
              }
              return ListView.separated(
                itemCount: photos.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final photo = photos[index];
                  return ListTile(
                    leading: const Icon(Icons.image_outlined),
                    title: Text(photo.title ?? 'Untitled'),
                    subtitle: Text(photo.summary ?? photo.storagePath),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

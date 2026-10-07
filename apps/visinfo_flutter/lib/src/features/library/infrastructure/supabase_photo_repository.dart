import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/photo_item.dart';
import '../domain/photo_repository.dart';

class SupabasePhotoRepository implements PhotoRepository {
  SupabasePhotoRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> createPhoto(PhotoItem photo) async {
    await _client.from('photos').insert(<String, Object?>{
      'id': photo.id,
      'storage_path': photo.storagePath,
      'captured_at': photo.createdAt.toIso8601String(),
    });
  }

  @override
  Future<List<PhotoItem>> listPhotos() async {
    final rows = await _client
        .from('photos')
        .select('id, storage_path, created_at, photo_metadata(title, summary)')
        .order('created_at', ascending: false);

    return (rows as List<dynamic>).map((dynamic row) {
      final map = row as Map<String, dynamic>;
      final dynamic metadataValue = map['photo_metadata'];
      final Map<String, dynamic> metadata;
      if (metadataValue is Map<String, dynamic>) {
        metadata = metadataValue;
      } else if (metadataValue is List<dynamic> && metadataValue.isNotEmpty) {
        metadata = metadataValue.first as Map<String, dynamic>;
      } else {
        metadata = const <String, dynamic>{};
      }
      return PhotoItem(
        id: map['id'] as String,
        storagePath: map['storage_path'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        title: metadata['title'] as String?,
        summary: metadata['summary'] as String?,
      );
    }).toList(growable: false);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/collection_item.dart';
import '../domain/collection_repository.dart';

class SupabaseCollectionRepository implements CollectionRepository {
  SupabaseCollectionRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> deleteCollection(String collectionId) async {
    await _client.from('collections').delete().eq('id', collectionId);
  }

  @override
  Future<List<CollectionItem>> listCollections() async {
    final rows = await _client
        .from('collections')
        .select('id, name, description, collection_items(photo_id)')
        .order('name');

    return (rows as List<dynamic>).map((dynamic row) {
      final map = row as Map<String, dynamic>;
      final List<dynamic> items = map['collection_items'] as List<dynamic>? ?? <dynamic>[];
      final photoIds = items
          .map((dynamic item) => (item as Map<String, dynamic>)['photo_id'] as String)
          .toList(growable: false);
      return CollectionItem(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String?,
        photoIds: photoIds,
      );
    }).toList(growable: false);
  }

  @override
  Future<void> upsertCollection(CollectionItem collection) async {
    await _client.from('collections').upsert(<String, Object?>{
      'id': collection.id,
      'name': collection.name,
      'description': collection.description,
    });
  }
}

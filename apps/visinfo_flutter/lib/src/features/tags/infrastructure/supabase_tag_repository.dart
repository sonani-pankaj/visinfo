import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/tag_item.dart';
import '../domain/tag_repository.dart';

class SupabaseTagRepository implements TagRepository {
  SupabaseTagRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> deleteTag(String tagId) async {
    await _client.from('tags').delete().eq('id', tagId);
  }

  @override
  Future<List<TagItem>> listTags() async {
    final rows = await _client.from('tags').select('id, name, color').order('name');
    return (rows as List<dynamic>)
        .map(
          (dynamic row) => TagItem(
            id: (row as Map<String, dynamic>)['id'] as String,
            name: row['name'] as String,
            color: row['color'] as String?,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> upsertTag(TagItem tag) async {
    await _client.from('tags').upsert(<String, Object?>{
      'id': tag.id,
      'name': tag.name,
      'color': tag.color,
    });
  }
}

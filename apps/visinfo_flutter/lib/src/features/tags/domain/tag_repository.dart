import 'tag_item.dart';

abstract class TagRepository {
  Future<List<TagItem>> listTags();
  Future<void> upsertTag(TagItem tag);
  Future<void> deleteTag(String tagId);
}

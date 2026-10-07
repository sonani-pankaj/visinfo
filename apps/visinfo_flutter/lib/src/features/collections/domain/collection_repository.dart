import 'collection_item.dart';

abstract class CollectionRepository {
  Future<List<CollectionItem>> listCollections();
  Future<void> upsertCollection(CollectionItem collection);
  Future<void> deleteCollection(String collectionId);
}

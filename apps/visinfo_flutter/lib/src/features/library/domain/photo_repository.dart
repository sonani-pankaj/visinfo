import 'photo_item.dart';

abstract class PhotoRepository {
  Future<List<PhotoItem>> listPhotos();
  Future<void> createPhoto(PhotoItem photo);
}

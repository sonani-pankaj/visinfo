import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../domain/photo_repository.dart';
import '../infrastructure/supabase_photo_repository.dart';

final photoRepositoryProvider = Provider<PhotoRepository>((Ref ref) {
  return SupabasePhotoRepository(ref.watch(supabaseClientProvider));
});

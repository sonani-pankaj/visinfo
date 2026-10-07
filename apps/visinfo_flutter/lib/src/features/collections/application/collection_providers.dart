import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../domain/collection_repository.dart';
import '../infrastructure/supabase_collection_repository.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((Ref ref) {
  return SupabaseCollectionRepository(ref.watch(supabaseClientProvider));
});

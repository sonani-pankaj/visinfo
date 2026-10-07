import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../domain/tag_repository.dart';
import '../infrastructure/supabase_tag_repository.dart';

final tagRepositoryProvider = Provider<TagRepository>((Ref ref) {
  return SupabaseTagRepository(ref.watch(supabaseClientProvider));
});

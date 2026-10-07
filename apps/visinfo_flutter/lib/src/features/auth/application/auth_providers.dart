import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((Ref ref) {
  return Supabase.instance.client;
});

final authServiceProvider = Provider<AuthService>((Ref ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

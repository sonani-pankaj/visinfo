class AppConfig {
  static String get supabaseUrl => _readRequired('SUPABASE_URL');
  static String get supabaseAnonKey => _readRequired('SUPABASE_ANON_KEY');

  static String _readRequired(String key) {
    const notSet = String.fromEnvironment('NOT_SET');
    final value = const String.fromEnvironment(key, defaultValue: notSet);
    if (value == notSet || value.isEmpty) {
      throw StateError('Missing required --dart-define=$key');
    }
    return value;
  }
}

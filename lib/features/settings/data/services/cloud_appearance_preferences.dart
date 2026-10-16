import 'package:supabase_flutter/supabase_flutter.dart';

class CloudAppearancePreferences {
  const CloudAppearancePreferences(this.client);

  final SupabaseClient client;

  ({String? language, String? theme}) get current =>
      read(client.auth.currentUser?.userMetadata);

  static ({String? language, String? theme}) read(
      Map<String, dynamic>? metadata) {
    final language = metadata?['language_code'];
    final theme = metadata?['theme_mode'];
    return (
      language: language is String &&
              {'en', 'fr', 'mg', 'de', 'es', 'it'}.contains(language)
          ? language
          : null,
      theme: theme is String && {'light', 'dark', 'system'}.contains(theme)
          ? theme
          : null,
    );
  }

  Future<void> save(String key, String value) async {
    if (key == 'language_code') {
      if (!{'en', 'fr', 'mg', 'de', 'es', 'it'}.contains(value)) {
        throw ArgumentError.value(value, key);
      }
    } else if (key == 'theme_mode') {
      if (!{'light', 'dark', 'system'}.contains(value)) {
        throw ArgumentError.value(value, key);
      }
    } else {
      throw ArgumentError.value(key, 'key');
    }
    if (client.auth.currentUser == null) {
      throw StateError('Sign in before syncing appearance settings.');
    }
    await client.auth.updateUser(UserAttributes(data: {key: value}));
  }
}

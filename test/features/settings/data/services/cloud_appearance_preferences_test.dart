import 'package:budgets/features/settings/data/services/cloud_appearance_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CloudAppearancePreferences.read', () {
    test('accepts supported language and theme from account metadata', () {
      final appearance = CloudAppearancePreferences.read({
        'language_code': 'mg',
        'theme_mode': 'dark',
      });
      expect(appearance.language, 'mg');
      expect(appearance.theme, 'dark');
    });

    test('ignores unknown or malformed metadata', () {
      final appearance = CloudAppearancePreferences.read({
        'language_code': 'xx',
        'theme_mode': 12,
      });
      expect(appearance.language, isNull);
      expect(appearance.theme, isNull);
    });
  });
}

import 'category_preset_names.dart';

class OnboardingPreset {
  const OnboardingPreset(
      {required this.slug,
      required this.name,
      required this.type,
      required this.icon,
      this.nameTranslations = const {}});
  final String slug;
  final String name;
  final String type;
  final String icon;
  final Map<String, String> nameTranslations;

  String nameFor(String language) =>
      nameTranslations[language] ??
      categoryPresetNames[slug]?[language] ??
      nameTranslations['en'] ??
      categoryPresetNames[slug]?['en'] ??
      name;

  factory OnboardingPreset.fromJson(Map<String, dynamic> row) =>
      OnboardingPreset(
          slug: row['slug'] as String,
          name: row['name'] as String,
          type: row['transaction_type'] as String,
          icon: row['icon_key'] as String,
          nameTranslations: (row['name_translations'] as Map<String, dynamic>?)
                  ?.map((key, value) => MapEntry(key, value as String)) ??
              const {});
}

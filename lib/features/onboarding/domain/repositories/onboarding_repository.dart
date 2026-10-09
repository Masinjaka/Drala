import '../models/onboarding_preset.dart';

abstract class OnboardingRepository {
  Map<String, dynamic> get draft;
  Future<List<OnboardingPreset>> presets();
  Future<void> save(Map<String, dynamic> draft);
  Future<void> complete(
      {required String currency,
      required String language,
      required List<String> categories,
      required List<String> wallets});
}

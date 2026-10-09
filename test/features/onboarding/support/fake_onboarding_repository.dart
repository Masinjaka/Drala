import 'package:budgets/features/onboarding/domain/models/onboarding_preset.dart';
import 'package:budgets/features/onboarding/domain/repositories/onboarding_repository.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  @override
  Map<String, dynamic> draft = {};
  bool failSave = false;
  bool failComplete = false;
  Map<String, dynamic>? completed;
  @override
  Future<List<OnboardingPreset>> presets() async => const [
        OnboardingPreset(
            slug: 'shopping',
            name: 'Shopping',
            type: 'expense',
            icon: 'shopping',
            nameTranslations: {
              'en': 'Groceries',
              'fr': 'Courses',
              'mg': 'Fiantsenana',
              'de': 'Lebensmittel',
              'es': 'Compras',
              'it': 'Spesa',
            }),
        OnboardingPreset(
            slug: 'transport',
            name: 'Transportation',
            type: 'expense',
            icon: 'transport'),
        OnboardingPreset(
            slug: 'health', name: 'Health', type: 'expense', icon: 'health'),
        OnboardingPreset(
            slug: 'utilities',
            name: 'Utilities',
            type: 'expense',
            icon: 'utilities'),
        OnboardingPreset(
            slug: 'food',
            name: 'Foods & Drinks',
            type: 'expense',
            icon: 'food',
            nameTranslations: {
              'en': 'Food & drinks',
              'fr': 'Repas et boissons',
              'mg': 'Sakafo sy zava-pisotro',
              'de': 'Essen & Trinken',
              'es': 'Comida y bebida',
              'it': 'Cibo e bevande',
            }),
        OnboardingPreset(
            slug: 'entertainment',
            name: 'Entertainment',
            type: 'expense',
            icon: 'entertainment'),
        OnboardingPreset(
            slug: 'salary',
            name: 'Salary',
            type: 'income',
            icon: 'salary',
            nameTranslations: {
              'en': 'Salary',
              'fr': 'Salaire',
              'mg': 'Karama',
              'de': 'Gehalt',
              'es': 'Salario',
              'it': 'Stipendio',
            }),
        OnboardingPreset(
            slug: 'freelance',
            name: 'Freelance',
            type: 'income',
            icon: 'freelance'),
      ];
  @override
  Future<void> save(Map<String, dynamic> value) async {
    if (failSave) throw StateError('Offline');
    draft = value;
  }

  @override
  Future<void> complete(
      {required String currency,
      required String language,
      required List<String> categories,
      required List<String> wallets}) async {
    if (failComplete) throw StateError('Offline');
    completed = {
      'currency': currency,
      'language': language,
      'categories': categories,
      'wallets': wallets
    };
  }
}

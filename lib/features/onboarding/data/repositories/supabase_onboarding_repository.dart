import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/onboarding_preset.dart';
import '../../domain/repositories/onboarding_repository.dart';

class SupabaseOnboardingRepository implements OnboardingRepository {
  SupabaseOnboardingRepository(this.client);
  final SupabaseClient client;
  @override
  Map<String, dynamic> get draft => Map<String, dynamic>.from(
      client.auth.currentUser?.userMetadata?['onboarding_draft'] as Map? ?? {});
  @override
  Future<List<OnboardingPreset>> presets() async {
    final rows = await client
        .from('category_presets')
        .select('slug,name,transaction_type,icon_key')
        .order('name');
    return rows.map(OnboardingPreset.fromJson).toList();
  }

  @override
  Future<void> save(Map<String, dynamic> draft) async {
    await client.auth
        .updateUser(UserAttributes(data: {'onboarding_draft': draft}));
  }

  @override
  Future<void> complete(
      {required String currency,
      required String language,
      required List<String> categories,
      required List<String> wallets}) async {
    await client.rpc('complete_onboarding', params: {
      'p_currency': currency,
      'p_language': language,
      'p_categories': categories,
      'p_wallets': wallets,
    });
    await client.auth.refreshSession();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import '../../data/repositories/supabase_onboarding_repository.dart';
import '../models/onboarding_preset.dart';
import '../repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final guest = ref.watch(guestSessionProvider);
      if (guest?.isActive == true) {
    return guest!.onboarding;
  }
  return SupabaseOnboardingRepository(Supabase.instance.client);
});
final onboardingPresetsProvider =
    FutureProvider.autoDispose<List<OnboardingPreset>>(
        (ref) => ref.watch(onboardingRepositoryProvider).presets());

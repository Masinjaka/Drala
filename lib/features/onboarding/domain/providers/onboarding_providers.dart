import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/supabase_onboarding_repository.dart';
import '../models/onboarding_preset.dart';
import '../repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
    (ref) => SupabaseOnboardingRepository(Supabase.instance.client));
final onboardingPresetsProvider =
    FutureProvider.autoDispose<List<OnboardingPreset>>(
        (ref) => ref.watch(onboardingRepositoryProvider).presets());

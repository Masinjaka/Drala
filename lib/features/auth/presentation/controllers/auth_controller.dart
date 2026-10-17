import 'dart:async';

import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/features/guest/data/guest_cloud_sync_service.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:budgets/features/settings/domain/providers/locale_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/providers/auth_providers.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    debugPrint('[AuthController][signIn] Start');
    try {
      await repo.signInWithPassword(email: email, password: password);
      await _syncGuestIfReady();
      debugPrint('[AuthController][signIn] Success');
      ref.invalidate(userModelProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('[AuthController][signIn] Error: $e');
      debugPrint('[AuthController][signIn] StackTrace: $st');
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signUp(
      {required String username,
      required String email,
      required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    debugPrint('[AuthController][signUp] Start');
    try {
      await repo.signUpWithPassword(
          email: email, password: password, username: username);
      await _syncGuestIfReady();
      debugPrint('[AuthController][signUp] Success');
      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('[AuthController][signUp] Error: $e');
      debugPrint('[AuthController][signUp] StackTrace: $st');
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final guest = ref.read(guestSessionProvider);
    final language = ref.read(localeProvider).languageCode;
    guest?.setSigningOut(true);
    try {
      await repo.signOut();
      await guest?.enterAfterSignOut(currency: 'MGA', language: language);
      ref.invalidate(guestSessionProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(currencyControllerProvider);
      ref.invalidate(notificationControllerProvider);
      ref.invalidate(userModelProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    } finally {
      guest?.setSigningOut(false);
    }
  }

  Future<void> _syncGuestIfReady() async {
    final guest = ref.read(guestSessionProvider);
    if (guest?.isActive != true ||
        !guest!.onboardingComplete ||
        Supabase.instance.client.auth.currentUser == null) {
      return;
    }
    await GuestCloudSyncService(Supabase.instance.client, guest).sync();
    ref.invalidate(guestSessionProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(currencyControllerProvider);
    ref.invalidate(userModelProvider);
    ref.invalidate(notificationControllerProvider);
  }

  Future<void> resetPassword(
      {required String email, String? redirectTo}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.sendPasswordResetEmail(email: email, redirectTo: redirectTo);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.verifyOtpAndResetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_onboarding_repository.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GuestSession extends ChangeNotifier {
  GuestSession._(
    this.database,
    this._preferences,
    this.userId,
    this.isActive,
    this.onboardingComplete,
    this.accountChoiceSeen,
  )   : onboarding = GuestOnboardingRepository(database, userId),
        repositories = GuestRepositories(database, userId);

  final GuestDatabase database;
  final SharedPreferences _preferences;
  String userId;
  GuestOnboardingRepository onboarding;
  GuestRepositories repositories;
  bool isActive;
  bool onboardingComplete;
  bool accountChoiceSeen;
  bool isSyncing = false;

  void setSyncing(bool value) {
    if (isSyncing == value) return;
    isSyncing = value;
    notifyListeners();
  }

  static Future<GuestSession> load(GuestDatabase database) async {
    final preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('guest_user_id');
    if (id == null) {
      id = const Uuid().v4();
      await preferences.setString('guest_user_id', id);
    }
    final rows = await database.customSelect(
      'SELECT onboarding_complete FROM guest_profiles WHERE id = ?',
      variables: [Variable.withString(id)],
    ).get();
    final session = GuestSession._(
      database,
      preferences,
      id,
      preferences.getBool('guest_active') ?? false,
      rows.isNotEmpty && rows.single.read<int>('onboarding_complete') == 1,
      preferences.getBool('guest_account_choice_seen') ?? false,
    );
    await session.onboarding.loadDraft();
    return session;
  }

  Future<void> start() async {
    if (!isActive && onboardingComplete) {
      userId = const Uuid().v4();
      await _preferences.setString('guest_user_id', userId);
      onboarding = GuestOnboardingRepository(database, userId);
      repositories = GuestRepositories(database, userId);
      onboardingComplete = false;
    }
    final now = DateTime.now().toUtc().toIso8601String();
    await database.customInsert(
      '''INSERT OR IGNORE INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES(?,'MGA','en','system',0,?)''',
      variables: [Variable.withString(userId), Variable.withString(now)],
    );
    await _preferences.setBool('guest_active', true);
    await _preferences.setBool('guest_account_choice_seen', false);
    isActive = true;
    accountChoiceSeen = false;
    notifyListeners();
  }

  void markOnboardingComplete() {
    onboardingComplete = true;
    notifyListeners();
  }

  Future<void> markChoiceSeen() async {
    await _preferences.setBool('guest_account_choice_seen', true);
    accountChoiceSeen = true;
    notifyListeners();
  }

  Future<void> stopAfterSync() async {
    await database.clearAllData();
    await _preferences.setBool('guest_active', false);
    isActive = false;
    notifyListeners();
  }
}

final guestSessionProvider = Provider<GuestSession?>((ref) => null);

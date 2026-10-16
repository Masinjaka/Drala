import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GuestDatabase database;
  late GuestPreferenceStore preferences;

  setUp(() async {
    database = GuestDatabase(NativeDatabase.memory());
    preferences = GuestPreferenceStore(database, 'guest');
    await database.customInsert(
      '''INSERT INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES('guest','MGA','en','system',1,'2026-01-01T00:00:00Z')''',
    );
  });
  tearDown(() async => database.close());

  test('profile changes persist and are recorded for sync', () async {
    await preferences.setProfile('language_code', 'fr');
    await preferences.setProfile('theme_mode', 'dark');
    final profile = await database
        .customSelect(
          'SELECT language_code,theme_mode FROM guest_profiles',
        )
        .getSingle();
    expect(profile.read<String>('language_code'), 'fr');
    expect(profile.read<String>('theme_mode'), 'dark');
    final journal = await database
        .customSelect(
          "SELECT * FROM guest_sync_records WHERE table_name = 'user'",
        )
        .get();
    expect(journal, hasLength(2));
    await expectLater(
      preferences.setProfile('currency_code', 'USD'),
      throwsArgumentError,
    );
  });

  test('notification choices survive a new store instance', () async {
    final initial = await preferences.notifications();
    await preferences.setNotifications(initial.copyWith(
      remindersEnabled: false,
      reminderHour: 8,
      reminderMinute: 30,
    ));
    final reloaded =
        await GuestPreferenceStore(database, 'guest').notifications();
    expect(reloaded.remindersEnabled, false);
    expect(reloaded.reminderHour, 8);
    expect(reloaded.reminderMinute, 30);
    final journal = await database
        .customSelect(
          "SELECT * FROM guest_sync_records WHERE table_name = 'notification_settings'",
        )
        .get();
    expect(journal, hasLength(1));
  });
}

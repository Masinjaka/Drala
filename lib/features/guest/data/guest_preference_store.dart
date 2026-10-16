import 'dart:convert';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:drift/drift.dart';

class GuestPreferenceStore {
  const GuestPreferenceStore(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<void> setProfile(String column, String value) async {
    if (!{'language_code', 'theme_mode'}.contains(column)) {
      throw ArgumentError.value(column, 'column');
    }
    await database.transaction(() async {
      await database.customUpdate(
        'UPDATE guest_profiles SET $column = ? WHERE id = ?',
        variables: [Variable.withString(value), Variable.withString(userId)],
      );
      await GuestSyncJournal(database).record('user', userId, 'upsert', {
        column: value,
      });
    });
  }

  Future<NotificationSettings> notifications() async {
    final rows = await database.customSelect(
      'SELECT value FROM guest_preferences WHERE key = ?',
      variables: [Variable.withString('notifications:$userId')],
    ).get();
    if (rows.isEmpty) {
      return NotificationSettings.defaults(
        timezoneOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
      );
    }
    return NotificationSettings.fromMap(
      Map<String, dynamic>.from(
          jsonDecode(rows.single.read<String>('value')) as Map),
    );
  }

  Future<void> setNotifications(NotificationSettings value) async {
    final data = {
      'notifications_enabled': value.notificationsEnabled,
      'reminders_enabled': value.remindersEnabled,
      'warnings_enabled': value.warningsEnabled,
      'reminder_hour': value.reminderHour,
      'reminder_minute': value.reminderMinute,
      'timezone_offset_minutes': value.timezoneOffsetMinutes,
      'warning_threshold': value.warningThreshold,
    };
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await database.customInsert(
        '''INSERT INTO guest_preferences(key,value,updated_at) VALUES(?,?,?)
           ON CONFLICT(key) DO UPDATE SET value=excluded.value,
           updated_at=excluded.updated_at''',
        variables: [
          Variable.withString('notifications:$userId'),
          Variable.withString(jsonEncode(data)),
          Variable.withString(now),
        ],
      );
      await GuestSyncJournal(database).record(
        'notification_settings',
        userId,
        'upsert',
        data,
      );
    });
  }
}

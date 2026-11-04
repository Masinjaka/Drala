import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/notifications/data/datasources/notification_datasource.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';

class OfflineNotificationDataSource extends NotificationDataSource {
  OfflineNotificationDataSource(super.client, this.account);
  final OfflineAccount account;
  GuestPreferenceStore get _local =>
      GuestPreferenceStore(account.database, account.id);
  @override
  Future<NotificationSettings> fetchSettings() => _local.notifications();
  @override
  Future<void> upsertSettings(
      {bool? notificationsEnabled,
      bool? remindersEnabled,
      bool? warningsEnabled,
      int? reminderHour,
      int? reminderMinute,
      int? timezoneOffsetMinutes,
      double? warningThreshold,
      String? languageCode}) async {
    final current = await _local.notifications();
    await _local.setNotifications(current.copyWith(
        notificationsEnabled: notificationsEnabled,
        remindersEnabled: remindersEnabled,
        warningsEnabled: warningsEnabled,
        reminderHour: reminderHour,
        reminderMinute: reminderMinute,
        timezoneOffsetMinutes: timezoneOffsetMinutes,
        warningThreshold: warningThreshold));
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    // The device locale is already persisted; its account preference is queued
    // by the settings screen. Device-token registration remains online-only.
  }
}

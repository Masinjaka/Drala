import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';

import 'guest_notification_gateway.dart';

class GuestNotificationDelivery {
  GuestNotificationDelivery(this.guest, this.gateway);
  final GuestSession guest;
  final GuestNotificationGateway gateway;
  String? _scheduledKey;

  bool get _active =>
      guest.isActive &&
      guest.onboardingComplete &&
      !guest.isSyncing &&
      !guest.isSigningOut;

  // Called serially by the coordinator so the outbox cannot be delivered twice.
  Future<void> sync(AppLocalizations l10n) async {
    if (!_active) {
      await cancel();
      return;
    }
    final settings = await GuestPreferenceStore(guest.database, guest.userId)
        .notifications();
    final granted = await gateway.isGranted();
    try {
      await _syncReminder(l10n, settings, granted);
    } finally {
      // A reminder/time-zone failure must not starve budget-alert delivery.
      await _deliverAlerts(l10n, settings, granted);
    }
  }

  Future<void> _syncReminder(AppLocalizations l10n,
      NotificationSettings settings, bool granted) async {
    if (settings.notificationsEnabled && settings.remindersEnabled && granted) {
      final zone = await gateway.timezoneName();
      final key = '${guest.userId}|${settings.reminderHour}|'
          '${settings.reminderMinute}|${l10n.localeName}|$zone';
      if (key != _scheduledKey && _active) {
        await gateway.scheduleReminder(
          hour: settings.reminderHour,
          minute: settings.reminderMinute,
          timezone: zone,
          title: l10n.dailyReminderNotificationTitle,
          body: l10n.dailyReminderNotificationBody,
        );
        _scheduledKey = key;
      }
    } else {
      await cancel();
    }
  }

  Future<void> _deliverAlerts(AppLocalizations l10n,
      NotificationSettings settings, bool granted) async {
    if (!_active ||
        !granted ||
        !settings.notificationsEnabled ||
        !settings.warningsEnabled) {
      return;
    }
    final repository =
        GuestNotificationRepository(guest.database, guest.userId);
    for (final alert in await repository.pending()) {
      if (!_active) return;
      final body = switch (alert.notificationType) {
        'envelope_near_limit' =>
          l10n.envelopeBudgetAlmostReached(alert.envelopeName),
        'envelope_limit_reached' =>
          l10n.envelopeBudgetReached(alert.envelopeName),
        _ => l10n.envelopeBudgetExceeded(alert.envelopeName),
      };
      await gateway.showAlert(alert, l10n.appTitle, body);
      await repository.markDelivered(alert.id);
    }
  }

  Future<void> cancel() async {
    await gateway.cancelReminder();
    _scheduledKey = null;
  }
}

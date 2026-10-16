import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_reminder_time_tile.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_settings_toggle.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestNotificationSettingsPage extends ConsumerStatefulWidget {
  const GuestNotificationSettingsPage({super.key});

  @override
  ConsumerState<GuestNotificationSettingsPage> createState() =>
      _GuestNotificationSettingsPageState();
}

class _GuestNotificationSettingsPageState
    extends ConsumerState<GuestNotificationSettingsPage> {
  NotificationSettings? _settings;
  bool _saving = false;

  GuestPreferenceStore get _store {
    final guest = ref.read(guestSessionProvider)!;
    return GuestPreferenceStore(guest.database, guest.userId);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final settings = await _store.notifications();
      if (mounted) setState(() => _settings = settings);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<bool> _save(NotificationSettings next) async {
    final previous = _settings;
    if (_saving || previous == null) return false;
    setState(() {
      _settings = next;
      _saving = true;
    });
    try {
      await _store.setNotifications(next);
      return true;
    } catch (error) {
      if (mounted) {
        setState(() => _settings = previous);
        showErrorToast(context, error);
      }
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _selectTime() async {
    final settings = _settings;
    if (settings == null || _saving) return;
    final selected = await AppWheelPicker.time(
      context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
      title: context.l10n.selectReminderTime,
    );
    if (selected == null) return;
    await _save(settings.copyWith(
      reminderHour: selected.hour,
      reminderMinute: selected.minute,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    final l = context.l10n;
    return SettingsPageShell(
      title: l.notification,
      child: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
              children: [
                SettingsMenuGroup(flat: true, items: [
                  NotificationSettingsToggle(
                    loading: _saving,
                    title: l.allowNotifications,
                    icon: Icons.notifications_outlined,
                    value: settings.notificationsEnabled,
                    enabled: !_saving,
                    onChanged: (value) => _save(
                      settings.copyWith(notificationsEnabled: value),
                    ),
                  ),
                  if (settings.notificationsEnabled) ...[
                    NotificationSettingsToggle(
                      loading: _saving,
                      title: l.dailyReminders,
                      icon: Icons.alarm_outlined,
                      value: settings.remindersEnabled,
                      enabled: !_saving,
                      onChanged: (value) => _save(
                        settings.copyWith(remindersEnabled: value),
                      ),
                    ),
                    if (settings.remindersEnabled)
                      NotificationReminderTimeTile(
                        time: TimeOfDay(
                          hour: settings.reminderHour,
                          minute: settings.reminderMinute,
                        ),
                        enabled: !_saving,
                        onTap: _selectTime,
                      ),
                    NotificationSettingsToggle(
                      loading: _saving,
                      title: l.budgetAlerts,
                      icon: Icons.warning_amber_outlined,
                      value: settings.warningsEnabled,
                      enabled: !_saving,
                      onChanged: (value) => _save(
                        settings.copyWith(warningsEnabled: value),
                      ),
                    ),
                  ],
                ]),
              ],
            ),
    );
  }
}

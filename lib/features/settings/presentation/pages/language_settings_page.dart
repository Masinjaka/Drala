import 'package:budgets/features/settings/domain/providers/locale_provider.dart';
import 'package:budgets/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_choice_tile.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({
    this.onSelected,
    this.syncNotifications = true,
    super.key,
  });

  final Future<void> Function(String)? onSelected;
  final bool syncNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final selected = ref.watch(localeProvider).languageCode;
    return SettingsPageShell(
      title: localizations.language,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
        children: [
          SettingsMenuGroup(
            flat: true,
            items: [
              _choice(ref, selected, 'en', localizations.english, '🇬🇧'),
              _choice(ref, selected, 'fr', localizations.french, '🇫🇷'),
              _choice(ref, selected, 'mg', localizations.malagasy, '🇲🇬'),
              _choice(ref, selected, 'de', localizations.german, '🇩🇪'),
              _choice(ref, selected, 'es', localizations.spanish, '🇪🇸'),
              _choice(ref, selected, 'it', localizations.italian, '🇮🇹'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _choice(
    WidgetRef ref,
    String selected,
    String languageCode,
    String label,
    String emoji,
  ) =>
      SettingsChoiceTile(
        title: label,
        leading: Text(emoji),
        selected: selected == languageCode,
        showSelectionIndicator: true,
        onTap: () async {
          await ref
              .read(localeProvider.notifier)
              .setLocale(Locale(languageCode));
          await onSelected?.call(languageCode);
          if (syncNotifications) {
            await ref
                .read(notificationControllerProvider.notifier)
                .syncLanguage();
          }
        },
      );
}

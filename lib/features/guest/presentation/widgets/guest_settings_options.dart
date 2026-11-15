import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class GuestSettingsOptions extends StatelessWidget {
  const GuestSettingsOptions({
    required this.onNotifications,
    required this.onCurrency,
    required this.onTheme,
    required this.onLanguage,
    super.key,
  });

  final VoidCallback onNotifications;
  final VoidCallback onCurrency;
  final VoidCallback onTheme;
  final VoidCallback onLanguage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsMenuGroup(
          flat: true,
          items: [
            SettingsMenuItem(
              title: l.notification,
              icon: Icons.notifications_rounded,
              onTap: onNotifications,
            ),
            SettingsMenuItem(
              title: l.currency,
              icon: Icons.currency_exchange_rounded,
              onTap: onCurrency,
            ),
            SettingsMenuItem(
              title: l.theme,
              icon: Icons.palette_rounded,
              onTap: onTheme,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 19),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppSettingsTheme.divider(context),
          ),
        ),
        SettingsMenuGroup(
          flat: true,
          items: [
            SettingsMenuItem(
              title: l.language,
              icon: Icons.language_rounded,
              onTap: onLanguage,
            ),
          ],
        ),
      ],
    );
  }
}

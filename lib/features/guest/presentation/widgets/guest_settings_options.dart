import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class GuestSettingsOptions extends StatelessWidget {
  const GuestSettingsOptions({
    required this.onNotifications,
    required this.onCurrency,
    required this.onDefaultWallet,
    required this.onTheme,
    required this.onLanguage,
    super.key,
  });

  final VoidCallback onNotifications;
  final VoidCallback onCurrency;
  final VoidCallback onDefaultWallet;
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
              iconAsset: 'assets/settings/notification.svg',
              onTap: onNotifications,
            ),
            SettingsMenuItem(
              title: l.currency,
              iconAsset: 'assets/settings/currency.svg',
              onTap: onCurrency,
            ),
            SettingsMenuItem(
              title: l.setDefaultWallet,
              iconAsset: 'assets/settings/privacy.svg',
              onTap: onDefaultWallet,
            ),
            SettingsMenuItem(
              title: l.theme,
              iconAsset: 'assets/settings/wallet.svg',
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
              iconAsset: 'assets/settings/language.svg',
              onTap: onLanguage,
            ),
          ],
        ),
      ],
    );
  }
}

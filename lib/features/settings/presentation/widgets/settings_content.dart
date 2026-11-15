import 'settings_legal_section.dart';
import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_summary_cards.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    required this.profileHeader,
    required this.categoryCount,
    required this.walletCount,
    required this.onCategories,
    required this.onWallets,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onNotifications,
    required this.onCurrency,
    required this.onTheme,
    required this.onLanguage,
    required this.onScannedReceipts,
    required this.onTerms,
    required this.onPrivacy,
    this.showAdPrivacyOptions = false,
    this.onAdPrivacyOptions,
    required this.accountActions,
    this.appVersion,
    this.syncFeedback,
    super.key,
  });

  final Widget profileHeader;
  final int categoryCount;
  final int walletCount;
  final VoidCallback onCategories;
  final VoidCallback onWallets;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onNotifications;
  final VoidCallback onCurrency;
  final VoidCallback onTheme;
  final VoidCallback onLanguage;
  final VoidCallback onScannedReceipts;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;
  final bool showAdPrivacyOptions;
  final VoidCallback? onAdPrivacyOptions;
  final Widget accountActions;
  final String? appVersion;
  final Widget? syncFeedback;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      key: const Key('settings-content'),
      padding: AppScrollPadding.insets(context, top: 0, bottom: 28),
      children: [
        if (syncFeedback != null) syncFeedback!,
        Align(alignment: Alignment.center, child: profileHeader),
        const SizedBox(height: 24),
        SettingsSummaryCards(
          categoriesLabel: l.categories,
          walletsLabel: l.wallets,
          categoryCount: categoryCount,
          walletCount: walletCount,
          onCategories: onCategories,
          onWallets: onWallets,
        ),
        const SizedBox(height: 24),
        SettingsSectionTitle(l.profile),
        SettingsMenuGroup(
          items: [
            SettingsMenuItem(
              title: l.editProfile,
              icon: Icons.person_rounded,
              height: 56,
              onTap: onEditProfile,
            ),
            SettingsMenuItem(
              title: l.changePassword,
              icon: Icons.lock_rounded,
              height: 56,
              onTap: onChangePassword,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionTitle(l.preferences),
        SettingsMenuGroup(
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
            SettingsMenuItem(
              title: l.language,
              icon: Icons.language_rounded,
              onTap: onLanguage,
            ),
            SettingsMenuItem(
              title: l.scannedReceipts,
              icon: Icons.receipt_long_rounded,
              onTap: onScannedReceipts,
            ),
            if (showAdPrivacyOptions && onAdPrivacyOptions != null)
              SettingsMenuItem(
                title: l.adPrivacyOptions,
                icon: Icons.ads_click,
                onTap: onAdPrivacyOptions!,
              ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsLegalSection(onTerms: onTerms, onPrivacy: onPrivacy),
        const SizedBox(height: 24),
        accountActions,
        const SizedBox(height: 24),
        if (appVersion != null) ...[
          const SizedBox(height: 12),
          Center(
            child: Text(
              l.appVersion(appVersion!),
              style: AppSettingsTheme.menuLabel(context),
            ),
          ),
        ],
      ],
    );
  }
}

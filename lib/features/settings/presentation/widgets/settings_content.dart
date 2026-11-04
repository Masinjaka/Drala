import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_logout_button.dart';
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
    required this.onLogout,
    required this.isLoggingOut,
    this.appVersion,
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
  final VoidCallback onLogout;
  final bool isLoggingOut;
  final String? appVersion;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      key: const Key('settings-content'),
      padding: AppPageSpacing.insets(context, top: 0, bottom: 28),
      children: [
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
              iconAsset: 'assets/settings/profile.svg',
              height: 56,
              onTap: onEditProfile,
            ),
            SettingsMenuItem(
              title: l.changePassword,
              iconAsset: 'assets/settings/password.svg',
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
              iconAsset: 'assets/settings/notification.svg',
              onTap: onNotifications,
            ),
            SettingsMenuItem(
              title: l.currency,
              iconAsset: 'assets/settings/currency.svg',
              onTap: onCurrency,
            ),
            SettingsMenuItem(
              title: l.theme,
              iconAsset: 'assets/settings/wallet.svg',
              onTap: onTheme,
            ),
            SettingsMenuItem(
              title: l.language,
              iconAsset: 'assets/settings/language.svg',
              onTap: onLanguage,
            ),
            SettingsMenuItem(
              title: l.scannedReceipts,
              iconAsset: 'assets/settings/scanned_receipts.svg',
              onTap: onScannedReceipts,
            ),
            if (showAdPrivacyOptions && onAdPrivacyOptions != null)
              SettingsMenuItem(
                title: l.adPrivacyOptions,
                icon: Icons.ads_click_outlined,
                onTap: onAdPrivacyOptions!,
              ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionTitle(l.legal),
        SettingsMenuGroup(
          items: [
            SettingsMenuItem(
              title: l.termsOfService,
              iconAsset: 'assets/settings/terms.svg',
              onTap: onTerms,
            ),
            SettingsMenuItem(
              title: l.privacyPolicy,
              iconAsset: 'assets/settings/theme.svg',
              onTap: onPrivacy,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsLogoutButton(
          label: l.logOut,
          isLoading: isLoggingOut,
          onPressed: onLogout,
        ),
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

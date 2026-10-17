import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'package:budgets/features/ads/data/admob_configuration.dart';
import 'package:budgets/features/ads/data/admob_consent_service.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/notifications/presentation/pages/notification_settings_page.dart';
import 'package:budgets/features/settings/presentation/pages/currency_selection_page.dart';
import 'package:budgets/features/settings/presentation/pages/default_wallet_page.dart';
import 'package:budgets/features/settings/presentation/pages/edit_password_page.dart';
import 'package:budgets/features/settings/presentation/pages/edit_profile_page.dart';
import 'package:budgets/features/settings/presentation/pages/language_settings_page.dart';
import 'package:budgets/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:budgets/features/settings/data/services/cloud_appearance_preferences.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_content.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_header.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:budgets/features/receipts/presentation/pages/receipt_gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({
    this.onDataDeleted,
    this.showBackButton = true,
    this.notificationViewModel,
    this.onNotificationsPressed,
    this.walletsListenable,
    this.walletCountReader,
    this.onCategoriesPressed,
    this.onWalletsPressed,
    this.legalLauncher = const UrlLegalDocumentLauncher(),
    super.key,
  });

  final VoidCallback? onDataDeleted;
  final bool showBackButton;
  final FinanceNotificationViewModel? notificationViewModel;
  final VoidCallback? onNotificationsPressed;
  final Listenable? walletsListenable;
  final int Function()? walletCountReader;
  final VoidCallback? onCategoriesPressed;
  final VoidCallback? onWalletsPressed;
  final LegalDocumentLauncher legalLauncher;

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  bool _isLoggingOut = false;
  Future<bool>? _privacyOptionsRequired;
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  void initState() {
    super.initState();
    if (AdMobConfiguration.nativeUnitId != null) {
      _privacyOptionsRequired = AdMobConsentService.privacyOptionsRequired;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryCount = ref.watch(categoriesProvider).value?.length ?? 0;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                SettingsPageHeader(
                  title: context.l10n.settings,
                  showBackButton: widget.showBackButton,
                  notificationViewModel: widget.notificationViewModel,
                  onNotifications: widget.onNotificationsPressed ??
                      () => _open(const NotificationSettingsPage()),
                ),
                Expanded(child: _content(categoryCount)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(int categoryCount) {
    final listenable = widget.walletsListenable;
    if (listenable == null) return _loadedContent(categoryCount);
    return ListenableBuilder(
      listenable: listenable,
      builder: (_, __) => _loadedContent(categoryCount),
    );
  }

  Widget _loadedContent(int categoryCount) => FutureBuilder<bool>(
        future: _privacyOptionsRequired,
        builder: (context, snapshot) => FutureBuilder<PackageInfo>(
          future: _packageInfo,
          builder: (context, packageSnapshot) => SettingsContent(
            profileHeader: const SettingsProfileHeader(),
            categoryCount: categoryCount,
            walletCount: widget.walletCountReader?.call() ?? 0,
            onCategories:
                widget.onCategoriesPressed ?? () => _open(const CategoryPage()),
            onWallets: widget.onWalletsPressed ??
                () => _open(const DefaultWalletPage()),
            onEditProfile: () => EditProfilePage.show(context,
                onDataDeleted: widget.onDataDeleted),
            onChangePassword: () => EditPasswordPage.show(context),
            onNotifications: () => _open(const NotificationSettingsPage()),
            onCurrency: () => _open(const CurrencySelectionPage()),
            onDefaultWallet: () => _open(const DefaultWalletPage()),
            onTheme: () => _open(ThemeSettingsPage(
              onSelected: (mode) => _saveAppearance('theme_mode', mode),
            )),
            onLanguage: () => _open(LanguageSettingsPage(
              onSelected: (code) => _saveAppearance('language_code', code),
            )),
            onScannedReceipts: () => _open(const ReceiptGalleryPage()),
            onTerms: () =>
                _openLegal(widget.legalLauncher.openTermsAndConditions),
            onPrivacy: () => _openLegal(widget.legalLauncher.openPrivacyPolicy),
            showAdPrivacyOptions: snapshot.data ?? false,
            onAdPrivacyOptions: _openAdPrivacyOptions,
            onLogout: _logout,
            isLoggingOut: _isLoggingOut,
            appVersion: packageSnapshot.data?.version,
          ),
        ),
      );

  Future<void> _open(Widget page) => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page),
      );

  Future<void> _saveAppearance(String key, String value) async {
    try {
      await CloudAppearancePreferences(Supabase.instance.client)
          .save(key, value);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _openLegal(Future<void> Function() open) async {
    try {
      await open();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _openAdPrivacyOptions() async {
    try {
      await AdMobConsentService.showPrivacyOptions();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    await ref.read(authControllerProvider.notifier).signOut();
    if (!mounted) return;
    context.go('/home');
  }
}

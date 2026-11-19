import 'package:budgets/features/settings/presentation/pages/settings_inbox_page.dart';
import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_legal_section.dart';
import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/ui/app_scroll_under_header.dart';
import 'package:budgets/core/navigation/app_modal_page_route.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/guest/data/guest_cloud_sync_service.dart';
import 'package:budgets/features/guest/presentation/widgets/guest_sync_card.dart';
import 'package:budgets/features/guest/presentation/widgets/guest_settings_options.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/pages/guest_notification_settings_page.dart';
import 'package:budgets/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:budgets/features/settings/presentation/pages/currency_selection_page.dart';
import 'package:budgets/features/settings/presentation/pages/language_settings_page.dart';
import 'package:budgets/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_header.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_summary_cards.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuestSettingsPage extends ConsumerStatefulWidget {
  const GuestSettingsPage({
    required this.onCategoriesPressed,
    required this.onWalletsPressed,
    required this.walletsListenable,
    required this.walletCountReader,
    this.isSignedIn,
    this.onNotificationsPressed,
    this.legalLauncher = const UrlLegalDocumentLauncher(),
    super.key,
  });

  final VoidCallback onCategoriesPressed;
  final VoidCallback onWalletsPressed;
  final Listenable walletsListenable;
  final int Function() walletCountReader;
  final bool Function()? isSignedIn;
  final VoidCallback? onNotificationsPressed;
  final LegalDocumentLauncher legalLauncher;

  @override
  ConsumerState<GuestSettingsPage> createState() => _GuestSettingsPageState();
}

class _GuestSettingsPageState extends ConsumerState<GuestSettingsPage> {
  bool _syncing = false;

  Future<void> _open(BuildContext context, Widget page) =>
      Navigator.of(context).push(AppModalPageRoute<void>(builder: (_) => page));

  Future<void> _openLegal(Future<void> Function() open) async {
    try {
      await open();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _sync() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    try {
      final guest = ref.read(guestSessionProvider)!;
      await GuestCloudSyncService(Supabase.instance.client, guest).sync();
      ref.invalidate(guestSessionProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(currencyControllerProvider);
      ref.invalidate(userModelProvider);
      ref.invalidate(notificationControllerProvider);
      if (mounted) context.go('/home');
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final guest = ref.read(guestSessionProvider)!;
    final preferences = GuestPreferenceStore(guest.database, guest.userId);
    return Scaffold(
      body: AppScrollUnderHeader(
        header: SettingsPageHeader(
            title: l.settings,
            showBackButton: false,
            onNotifications: widget.onNotificationsPressed ??
                () => _open(context, const SettingsInboxPage())),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: AppScrollPadding.insets(context, top: 24, bottom: 32),
            children: [
              GuestSyncCard(
                signedIn: widget.isSignedIn?.call() ??
                    Supabase.instance.client.auth.currentUser != null,
                isLoading: _syncing,
                onSignIn: () {
                  if (Supabase.instance.client.auth.currentUser != null) {
                    _sync();
                  } else {
                    context.push('/sign-in-choice');
                  }
                },
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: widget.walletsListenable,
                builder: (context, _) => SettingsSummaryCards(
                  categoriesLabel: l.categories,
                  walletsLabel: l.wallets,
                  categoryCount:
                      ref.watch(categoriesProvider).value?.length ?? 0,
                  walletCount: widget.walletCountReader(),
                  onCategories: widget.onCategoriesPressed,
                  onWallets: widget.onWalletsPressed,
                ),
              ),
              const SizedBox(height: 43),
              GuestSettingsOptions(
                onNotifications: () => _open(
                  context,
                  const GuestNotificationSettingsPage(),
                ),
                onCurrency: () => _open(
                  context,
                  const CurrencySelectionPage(),
                ),
                onTheme: () => _open(
                  context,
                  ThemeSettingsPage(
                    onSelected: (mode) =>
                        preferences.setProfile('theme_mode', mode),
                  ),
                ),
                onLanguage: () => _open(
                  context,
                  LanguageSettingsPage(
                    syncNotifications: false,
                    onSelected: (code) =>
                        preferences.setProfile('language_code', code),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SettingsLegalSection(
                onTerms: () =>
                    _openLegal(widget.legalLauncher.openTermsAndConditions),
                onPrivacy: () =>
                    _openLegal(widget.legalLauncher.openPrivacyPolicy),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

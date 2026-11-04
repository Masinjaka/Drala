import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_setup_theme.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/settings/domain/providers/locale_provider.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/onboarding_providers.dart';
import '../widgets/setup_page_view.dart';
import '../widgets/setup_submit_bar.dart';
import '../widgets/setup_preset_choices.dart';

part 'account_setup_page_actions.dart';

class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({
    this.completionRoute = '/home',
    this.onCompleted,
    this.onConfigured,
    super.key,
  });
  final String completionRoute;
  final Future<void> Function()? onCompleted;
  final Future<void> Function()? onConfigured;
  @override
  ConsumerState<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  int step = 2;
  String currency = 'MGA';
  late String language;
  Set<String> categories = {}, wallets = {};
  bool busy = false;
  bool moving = false;
  late final PageController pages;
  late final int initialStep;
  void _update(VoidCallback change) => setState(change);

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingRepositoryProvider).draft;
    step = (draft['step'] as int? ?? 2).clamp(2, 6);
    initialStep = step;
    currency = draft['currency'] as String? ?? 'MGA';
    language =
        draft['language'] as String? ?? ref.read(localeProvider).languageCode;
    categories = Set<String>.from(
        draft['categories'] as List? ?? SetupPresetChoices.visible);
    wallets = Set<String>.from(
        draft['wallets'] as List? ?? const ['cash', 'bank', 'mobile']);
    pages = PageController(initialPage: step - 2);
  }

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final titles = [
      l.setupLanguageTitle,
      l.setupCurrencyTitle,
      l.setupCategoriesTitle,
      l.setupWalletsTitle
    ];
    final bodies = [
      l.setupLanguageBody,
      l.setupCurrencyBody,
      l.setupCategoriesBody,
      l.setupWalletsBody
    ];
    final presets = ref.watch(onboardingPresetsProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !busy && !moving && step > 2 && step < 6) _back();
      },
      child: Scaffold(
        backgroundColor: step < 6 ? AppSetupTheme.background(context) : null,
        body: AppGridBackground(
            child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: SizedBox.expand(
                      child: AbsorbPointer(
                        absorbing: busy || moving,
                        child: SetupPageView(
                          controller: pages,
                          activeStep: step,
                          initialStep: initialStep,
                          titles: titles,
                          bodies: bodies,
                          completionTitle: l.setupCompleteTitle,
                          completionBody: l.setupCompleteBody,
                          language: language,
                          currency: currency,
                          categories: categories,
                          wallets: wallets,
                          onBack: _back,
                          onLanguageChanged: _selectLanguage,
                          onCurrencyChanged: (value) =>
                              setState(() => currency = value),
                          onCategoryChanged: (value) =>
                              _toggle(categories, value),
                          onWalletChanged: (value) => _toggle(wallets, value),
                        ),
                      ),
                    ),
                  ),
                ))),
        bottomNavigationBar: SetupSubmitBar(
          pill: step < 6,
          text: step == 6 ? l.setupDone : l.setupContinue,
          onPressed: step == 6
              ? () async {
                  try {
                    await widget.onCompleted?.call();
                    ref.invalidate(guestSessionProvider);
                    ref.invalidate(categoriesProvider);
                    ref.invalidate(currencyControllerProvider);
                    ref.invalidate(userModelProvider);
                    if (context.mounted) context.go(widget.completionRoute);
                  } catch (error) {
                    if (context.mounted) showErrorToast(context, error);
                  }
                }
              : busy || moving || (step == 4 && !presets.hasValue)
                  ? null
                  : _next,
          isLoading: busy,
          primary: true,
        ),
      ),
    );
  }
}

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/app_toast.dart';
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

class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({super.key});
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
        body: Center(
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
                  onCategoryChanged: (value) => _toggle(categories, value),
                  onWalletChanged: (value) => _toggle(wallets, value),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SetupSubmitBar(
          text: step == 6 ? l.setupDone : l.setupContinue,
          onPressed: step == 6
              ? () => context.go('/home')
              : busy || moving || (step == 4 && !presets.hasValue)
                  ? null
                  : _next,
          isLoading: busy,
          primary: true,
        ),
      ),
    );
  }

  void _toggle(Set<String> values, String value) => setState(() {
        if (!values.remove(value)) values.add(value);
      });

  Future<void> _selectLanguage(String code) async {
    setState(() => language = code);
    try {
      await ref.read(localeProvider.notifier).setLocale(Locale(code));
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  void _back() {
    if (!busy && !moving && step > 2 && step < 6) _moveTo(step - 1);
  }

  Future<void> _moveTo(int target) async {
    setState(() => moving = true);
    if (MediaQuery.disableAnimationsOf(context)) {
      pages.jumpToPage(target - 2);
    } else {
      await pages.animateToPage(
        target - 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
    if (mounted) {
      setState(() {
        step = target;
        moving = false;
      });
    }
  }

  Future<void> _next() async {
    if (busy || moving) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => busy = true);
    try {
      final repo = ref.read(onboardingRepositoryProvider);
      await ref.read(localeProvider.notifier).setLocale(Locale(language));
      if (step == 5) {
        await repo.save({
          'step': step,
          'language': language,
          'currency': currency,
          'categories': categories.toList(),
          'wallets': wallets.toList()
        });
        await repo.complete(
            currency: currency,
            language: language,
            categories: categories.toList(),
            wallets: wallets.toList());
        ref.invalidate(userModelProvider);
        ref.invalidate(currencyControllerProvider);
        if (mounted) await _moveTo(6);
      } else {
        await repo.save({
          'step': step + 1,
          'language': language,
          'currency': currency,
          'categories': categories.toList(),
          'wallets': wallets.toList()
        });
        if (mounted) await _moveTo(step + 1);
      }
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}

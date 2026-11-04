part of 'account_setup_page.dart';

extension _AccountSetupActions on _AccountSetupPageState {
  void _toggle(Set<String> values, String value) => _update(() {
        if (!values.remove(value)) values.add(value);
      });
  Future<void> _selectLanguage(String code) async {
    _update(() => language = code);
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
    _update(() => moving = true);
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
      _update(() {
        step = target;
        moving = false;
      });
    }
  }

  Future<void> _next() async {
    if (busy || moving) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _update(() => busy = true);
    try {
      final repo = ref.read(onboardingRepositoryProvider);
      await ref.read(localeProvider.notifier).setLocale(Locale(language));
      final selections = {
        'language': language,
        'currency': currency,
        'categories': categories.toList(),
        'wallets': wallets.toList(),
      };
      if (step == 5) {
        await repo.save({'step': step, ...selections});
        await repo.complete(
            currency: currency,
            language: language,
            categories: categories.toList(),
            wallets: wallets.toList());
        ref.invalidate(userModelProvider);
        ref.invalidate(currencyControllerProvider);
        if (widget.onConfigured != null) {
          ref.invalidate(categoriesProvider);
          await widget.onConfigured!();
        } else if (mounted) {
          await _moveTo(6);
        }
      } else {
        await repo.save({'step': step + 1, ...selections});
        if (mounted) await _moveTo(step + 1);
      }
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) _update(() => busy = false);
    }
  }
}

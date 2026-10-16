import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/detail_list_skeleton.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_choices.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/settings/presentation/widgets/guest_currency_rate_notice.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelectionPage extends ConsumerStatefulWidget {
  const CurrencySelectionPage({super.key});

  @override
  ConsumerState<CurrencySelectionPage> createState() =>
      _CurrencySelectionPageState();
}

class _CurrencySelectionPageState extends ConsumerState<CurrencySelectionPage> {
  String? _pendingCode;
  bool _retrying = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyControllerProvider);
    final isGuest = ref.watch(guestSessionProvider)?.isActive == true;
    final currency = state.value;
    return SettingsPageShell(
      title: context.l10n.currency,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
          child: Column(
            children: [
              if (isGuest &&
                  currency != null &&
                  currency.preferredCode != currency.code) ...[
                GuestCurrencyRateNotice(
                  preferred: currency.preferredCode,
                  displayed: currency.code,
                  onRetry: _retryRates,
                  isRetrying: _retrying,
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: state.when(
                  data: (value) => SetupCurrencyChoices(
                    selected: value.preferredCode,
                    pendingCode: _pendingCode,
                    onChanged: _select,
                  ),
                  loading: () => const DetailListSkeleton(),
                  error: (error, _) => Center(
                    child: Text(context.l10n.errorWithMessage('$error')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _select(String code) async {
    if (_pendingCode != null || _retrying) return;
    setState(() => _pendingCode = code);
    try {
      await ref.read(currencyControllerProvider.notifier).setCurrency(code);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _pendingCode = null);
    }
  }

  Future<void> _retryRates() async {
    if (_retrying || _pendingCode != null) return;
    setState(() => _retrying = true);
    final available =
        await ref.read(currencyControllerProvider.notifier).retryGuestRates();
    if (mounted && !available) {
      showErrorToast(context, context.l10n.guestCurrencyRateStillUnavailable);
    }
    if (mounted) setState(() => _retrying = false);
  }
}

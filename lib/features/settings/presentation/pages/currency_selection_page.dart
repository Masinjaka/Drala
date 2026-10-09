import 'package:budgets/core/ui/detail_list_skeleton.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/settings/presentation/widgets/currency_choice_list.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyControllerProvider);
    return SettingsPageShell(
      title: context.l10n.currency,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
          child: Column(
            children: [
              Expanded(
                child: state.when(
                  data: (value) => CurrencyChoiceList(
                    selectedCode: value.code,
                    availableCodes: value.rates.keys,
                    pendingCode: _pendingCode,
                    searchHint: context.l10n.searchCurrency,
                    onSelected: _select,
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
    if (_pendingCode != null) return;
    setState(() => _pendingCode = code);
    try {
      await ref.read(currencyControllerProvider.notifier).setCurrency(code);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _pendingCode = null);
    }
  }
}

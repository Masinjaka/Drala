import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/ui/scroll_edge_fade.dart';
import 'package:budgets/features/settings/presentation/widgets/currency_search_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'setup_choice.dart';
import 'setup_currency_names.dart';
import 'setup_currency_skeleton.dart';
import 'setup_list_choice_entrance.dart';

class SetupCurrencyChoices extends ConsumerStatefulWidget {
  const SetupCurrencyChoices(
      {required this.selected, required this.onChanged, super.key});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<SetupCurrencyChoices> createState() =>
      _SetupCurrencyChoicesState();
}

class _SetupCurrencyChoicesState extends ConsumerState<SetupCurrencyChoices> {
  final search = TextEditingController();
  String query = '';

  static const priority = ['EUR', 'MGA', 'USD'];

  @override
  void initState() {
    super.initState();
    search.addListener(_searchChanged);
  }

  @override
  void dispose() {
    search
      ..removeListener(_searchChanged)
      ..dispose();
    super.dispose();
  }

  void _searchChanged() => setState(() => query = search.text.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final rateState = ref.watch(exchangeRatesProvider);
    final rates = rateState.value;
    final all = <String>{
      ...priority,
      widget.selected,
      ...fallbackCurrencyCodes,
      ...?rates?.rates.keys,
    };
    final codes = all.where(_matches).toList()
      ..sort((a, b) {
        final ai = priority.indexOf(a);
        final bi = priority.indexOf(b);
        if (ai >= 0 || bi >= 0) {
          return (ai < 0 ? priority.length : ai)
              .compareTo(bi < 0 ? priority.length : bi);
        }
        return a.compareTo(b);
      });
    return Column(
      children: [
        CurrencySearchField(
          controller: search,
          hint: context.l10n.searchCurrency,
        ),
        const SizedBox(height: 38),
        Expanded(
          child: ScrollEdgeFade(
            child: rateState.isLoading && !rateState.hasValue
                ? const SetupCurrencySkeleton()
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 28),
                    itemCount: codes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final code = codes[index];
                      return SetupListChoiceEntrance(
                        key: ValueKey(code),
                        index: index,
                        child: SetupChoice(
                          title: setupCurrencyNames[code] ?? '$code currency',
                          selected: widget.selected == code,
                          trailing: Text(_symbol(code)),
                          onTap: () => widget.onChanged(code),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  bool _matches(String code) {
    final name = setupCurrencyNames[code];
    return query.isEmpty ||
        code.toLowerCase().contains(query) ||
        (name?.toLowerCase().contains(query) ?? false);
  }

  String _symbol(String code) => switch (code) {
        'MGA' => 'MGA',
        _ => NumberFormat.simpleCurrency(name: code).currencySymbol,
      };
}

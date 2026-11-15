import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_names.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_symbol.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_list_choice_entrance.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'currency_search_field.dart';
import 'settings_currency_choice.dart';

class SettingsCurrencyList extends StatelessWidget {
  const SettingsCurrencyList(
      {required this.search,
      required this.controller,
      required this.codes,
      required this.selected,
      required this.onChanged,
      this.pending,
      super.key});
  final TextEditingController search;
  final ScrollController controller;
  final List<String> codes;
  final String selected;
  final String? pending;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
              child: CurrencySearchField(
                  controller: search,
                  hint: context.l10n.searchCurrency,
                  onboarding: false)),
          SliverPadding(
            padding: EdgeInsets.only(
                top: 16, bottom: 28 + MediaQuery.paddingOf(context).bottom),
            sliver: SliverList.builder(
                itemCount: codes.length,
                itemBuilder: (context, index) {
                  final code = codes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: SetupListChoiceEntrance(
                      key: ValueKey(code),
                      index: index,
                      child: SettingsCurrencyChoice(
                          code: code,
                          title: setupCurrencyNames[code] ?? '$code currency',
                          symbol: setupCurrencySymbol(code),
                          selected: selected == code,
                          loading: pending == code,
                          first: index == 0,
                          last: index == codes.length - 1,
                          onTap: () => onChanged(code)),
                    ),
                  );
                }),
          ),
        ],
      );
}

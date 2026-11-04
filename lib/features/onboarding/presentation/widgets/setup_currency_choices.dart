import 'package:budgets/features/settings/presentation/widgets/settings_currency_choice.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/currency_defaults.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/settings/presentation/widgets/currency_search_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setup_choice.dart';
import 'setup_currency_names.dart';
import 'setup_currency_skeleton.dart';
import 'setup_currency_symbol.dart';
import 'setup_currency_trailing.dart';
import 'setup_list_choice_entrance.dart';

class SetupCurrencyChoices extends ConsumerStatefulWidget {
  const SetupCurrencyChoices({
    required this.selected,
    required this.onChanged,
    this.pendingCode,
    this.settingsMode = false,
    super.key,
  });
  final String selected;
  final ValueChanged<String> onChanged;
  final String? pendingCode;
  final bool settingsMode;

  @override
  ConsumerState<SetupCurrencyChoices> createState() =>
      _SetupCurrencyChoicesState();
}

class _SetupCurrencyChoicesState extends ConsumerState<SetupCurrencyChoices> {
  static const _choiceStride = 60.0;
  static const _choiceHeight = 50.0;
  final search = TextEditingController();
  final _scrollController = ScrollController();
  String query = '';
  bool _hasPositionedSelection = false;

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
    _scrollController.dispose();
    super.dispose();
  }

  void _searchChanged() => setState(() => query = search.text.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(guestSessionProvider)?.isActive == true;
    final rateState = isGuest ? null : ref.watch(exchangeRatesProvider);
    final rates = rateState?.value;
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
    _positionSelectedCurrency(codes);
    return Column(
      children: [
        CurrencySearchField(
          controller: search,
          hint: context.l10n.searchCurrency,
          onboarding: !widget.settingsMode,
        ),
        SizedBox(height: widget.settingsMode ? 16 : 27),
        Expanded(
          child: rateState?.isLoading == true && rateState?.hasValue != true
              ? const SetupCurrencySkeleton()
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 28),
                  itemCount: codes.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: widget.settingsMode ? 4 : 10),
                  itemBuilder: (_, index) {
                    final code = codes[index];
                    final isPending = widget.pendingCode == code;
                    return SetupListChoiceEntrance(
                      key: ValueKey(code),
                      index: index,
                      child: widget.settingsMode
                          ? SettingsCurrencyChoice(
                              code: code,
                              title:
                                  setupCurrencyNames[code] ?? '$code currency',
                              symbol: setupCurrencySymbol(code),
                              selected: widget.selected == code,
                              loading: isPending,
                              first: index == 0,
                              last: index == codes.length - 1,
                              onTap: () => widget.onChanged(code),
                            )
                          : SetupChoice(
                              title:
                                  setupCurrencyNames[code] ?? '$code currency',
                              pill: true,
                              height: _choiceHeight,
                              selected: widget.selected == code || isPending,
                              trailing: SetupCurrencyTrailing(
                                symbol: setupCurrencySymbol(code),
                                isLoading: isPending,
                              ),
                              onTap: () => widget.onChanged(code),
                            ),
                    );
                  },
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

  void _positionSelectedCurrency(List<String> codes) {
    if (query.isNotEmpty || _hasPositionedSelection) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final index = codes.indexOf(widget.selected);
      if (index < 0) return;
      final position = _scrollController.position;
      final height = widget.settingsMode ? 76 : _choiceHeight;
      final stride = widget.settingsMode ? 80 : _choiceStride;
      final centeredOffset =
          index * stride - (position.viewportDimension - height) / 2;
      _scrollController.jumpTo(
        centeredOffset.clamp(0, position.maxScrollExtent),
      );
      _hasPositionedSelection = true;
    });
  }
}

import 'package:budgets/core/ui/scroll_edge_fade.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'currency_search_field.dart';
import 'settings_choice_tile.dart';

class CurrencyChoiceList extends StatefulWidget {
  const CurrencyChoiceList({
    required this.selectedCode,
    required this.availableCodes,
    required this.onSelected,
    required this.searchHint,
    this.pendingCode,
    super.key,
  });

  final String selectedCode;
  final Iterable<String> availableCodes;
  final ValueChanged<String> onSelected;
  final String searchHint;
  final String? pendingCode;

  @override
  State<CurrencyChoiceList> createState() => _CurrencyChoiceListState();
}

class _CurrencyChoiceListState extends State<CurrencyChoiceList> {
  static const _rowStride = 62.0;
  final _searchController = TextEditingController();
  late final ScrollController _scrollController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _initialSelectedIndex() * _rowStride,
    );
    _searchController.addListener(_onSearch);
  }

  @override
  void didUpdateWidget(CurrencyChoiceList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currenciesChanged =
        oldWidget.availableCodes.length != widget.availableCodes.length;
    if (_query.isEmpty &&
        (currenciesChanged || oldWidget.selectedCode != widget.selectedCode)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSelection());
    }
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearch)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int _initialSelectedIndex() {
    final codes = <String>{'MGA', ...widget.availableCodes}.toList()..sort();
    final index = codes.indexOf(widget.selectedCode);
    return index < 0 ? 0 : index;
  }

  void _showSelection() {
    if (!mounted || !_scrollController.hasClients) return;
    final target = _initialSelectedIndex() * _rowStride;
    final position = _scrollController.position;
    _scrollController.jumpTo(target.clamp(0, position.maxScrollExtent));
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query == _query) return;
    setState(() => _query = query);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final codes = <String>{'MGA', ...widget.availableCodes}
        .where((code) => code.toLowerCase().contains(_query))
        .toList()
      ..sort();
    return Column(children: [
      CurrencySearchField(
        controller: _searchController,
        hint: widget.searchHint,
      ),
      const SizedBox(height: 16),
      Expanded(
        child: ScrollEdgeFade(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 28),
            itemCount: codes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _currencyTile(codes[index]),
          ),
        ),
      ),
    ]);
  }

  Widget _currencyTile(String code) => Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: SettingsChoiceTile(
          title: code,
          subtitle: NumberFormat.simpleCurrency(name: code).currencySymbol,
          leading: const Icon(Icons.currency_exchange_outlined, size: 20),
          trailing: _indicator(code),
          onTap:
              widget.pendingCode == null ? () => widget.onSelected(code) : null,
        ),
      );

  Widget? _indicator(String code) {
    if (widget.pendingCode == code) {
      return const SizedBox.square(
        dimension: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return code == widget.selectedCode
        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
        : null;
  }
}

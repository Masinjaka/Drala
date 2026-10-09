import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_list_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedFinanceEntryList extends StatefulWidget {
  const AnimatedFinanceEntryList({
    required this.entries,
    this.onEntryTap,
    this.currencyState,
    super.key,
  });

  final List<FinanceEntry> entries;
  final ValueChanged<FinanceEntry>? onEntryTap;
  final CurrencyState? currencyState;

  @override
  State<AnimatedFinanceEntryList> createState() =>
      _AnimatedFinanceEntryListState();
}

class _AnimatedFinanceEntryListState extends State<AnimatedFinanceEntryList> {
  static const _enterDuration = Duration(milliseconds: 220);
  static const _exitDuration = Duration(milliseconds: 160);
  GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  late List<FinanceEntry> _entries = [...widget.entries];
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        WidgetsBinding
            .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
  }

  @override
  void didUpdateWidget(covariant AnimatedFinanceEntryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasReorderedEntries()) {
      _entries = [...widget.entries];
      _listKey = GlobalKey();
      return;
    }
    _removeMissingEntries();
    _insertNewEntries();
    _updateExistingEntries();
  }

  bool _hasReorderedEntries() {
    final oldIds = _entries.map((entry) => entry.id).toSet();
    final nextIds = widget.entries.map((entry) => entry.id).toSet();
    final oldCommon = _entries
        .where((entry) => nextIds.contains(entry.id))
        .map((entry) => entry.id)
        .toList();
    final nextCommon = widget.entries
        .where((entry) => oldIds.contains(entry.id))
        .map((entry) => entry.id)
        .toList();
    return !listEquals(oldCommon, nextCommon);
  }

  void _removeMissingEntries() {
    final nextIds = widget.entries.map((entry) => entry.id).toSet();
    for (var index = _entries.length - 1; index >= 0; index--) {
      if (nextIds.contains(_entries[index].id)) continue;
      final removed = _entries.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _transition(removed, animation, false),
        duration: _reduceMotion ? Duration.zero : _exitDuration,
      );
    }
  }

  void _insertNewEntries() {
    final currentIds = _entries.map((entry) => entry.id).toSet();
    for (var index = 0; index < widget.entries.length; index++) {
      final entry = widget.entries[index];
      if (currentIds.add(entry.id)) {
        _entries.insert(index, entry);
        _listKey.currentState?.insertItem(
          index,
          duration: _reduceMotion ? Duration.zero : _enterDuration,
        );
      }
    }
  }

  void _updateExistingEntries() {
    final nextById = {for (final entry in widget.entries) entry.id: entry};
    for (var index = 0; index < _entries.length; index++) {
      _entries[index] = nextById[_entries[index].id] ?? _entries[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _entries.length,
      itemBuilder: (context, index, animation) {
        return _transition(_entries[index], animation, true);
      },
    );
  }

  Widget _transition(
    FinanceEntry entry,
    Animation<double> animation,
    bool entering,
  ) {
    return FinanceEntryListTransition(
      entry: entry,
      animation: animation,
      entering: entering,
      reduceMotion: _reduceMotion,
      currencyState: widget.currencyState,
      onEntryTap: widget.onEntryTap,
    );
  }
}

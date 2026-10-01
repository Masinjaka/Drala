import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_edit_changes.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_row.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeOperationsList extends StatelessWidget {
  const HomeOperationsList({
    required this.entries,
    required this.isLoading,
    required this.isAdding,
    required this.onEntryTap,
    this.currencyState,
    this.asSliver = false,
    this.pendingEdits = const {},
    super.key,
  });

  final List<FinanceEntry> entries;
  final bool isLoading;
  final bool isAdding;
  final ValueChanged<FinanceEntry> onEntryTap;
  final CurrencyState? currencyState;
  final bool asSliver;
  final Map<String, FinanceEntryEditChanges> pendingEdits;

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(29, 7, 28, 8),
          child: Text(
            '${entries.length} ${context.l10n.transactions.toLowerCase()}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 29),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (isLoading) {
                return _animateItem(
                    HomeOperationSkeleton(
                        key: ValueKey('loading-operation-$index')),
                    index);
              }
              if (isAdding && index == 0) {
                return _animateItem(
                    const HomeOperationSkeleton(
                        key: Key('pending-operation-skeleton')),
                    0);
              }
              final entryIndex = index - (isAdding ? 1 : 0);
              final entry = entries[entryIndex];
              return _animateItem(
                HomeOperationRow(
                  key: ValueKey('operation-${entry.id}'),
                  entry: entry,
                  pendingEdit: pendingEdits[entry.id],
                  currencyState: currencyState,
                  onTap: () => onEntryTap(entry),
                ),
                entryIndex,
              );
            },
            childCount: isLoading ? 3 : entries.length + (isAdding ? 1 : 0),
          ),
        ),
      ),
    ];
    if (asSliver) return SliverMainAxisGroup(slivers: slivers);
    return CustomScrollView(
      key: const Key('transaction-scroll-view'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );
  }

  Widget _animateItem(Widget child, int index) => child
      .animate(delay: (50 * index).ms)
      .fadeIn(duration: 200.ms)
      .slideY(begin: 0.5, duration: 200.ms, curve: Curves.easeOut);
}

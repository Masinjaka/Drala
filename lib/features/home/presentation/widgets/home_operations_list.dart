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
    this.isLoadingMore = false,
    required this.onEntryTap,
    this.currencyState,
    this.asSliver = false,
    this.pendingEdits = const {},
    super.key,
  });

  final List<FinanceEntry> entries;
  final bool isLoading;
  final bool isAdding;
  final bool isLoadingMore;
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
                return HomeOperationSkeleton(
                    key: ValueKey('loading-operation-$index'));
              }
              if (isAdding && index == 0) {
                return const HomeOperationSkeleton(
                    key: Key('pending-operation-skeleton'));
              }
              final entryIndex = index - (isAdding ? 1 : 0);
              if (entryIndex >= entries.length) {
                return HomeOperationSkeleton(
                    key: ValueKey('loading-more-operation-$entryIndex'));
              }
              final entry = entries[entryIndex];
              return KeyedSubtree(
                key: ValueKey('ready-operation-${entry.id}'),
                child: _animateItem(
                  HomeOperationRow(
                    key: ValueKey('operation-${entry.id}'),
                    entry: entry,
                    pendingEdit: pendingEdits[entry.id],
                    currencyState: currencyState,
                    onTap: () => onEntryTap(entry),
                  ),
                  entryIndex,
                ),
              );
            },
            childCount: isLoading
                ? 3
                : entries.length + (isAdding ? 1 : 0) + (isLoadingMore ? 3 : 0),
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
      .animate(delay: (index < 3 ? 25 * index : 0).ms)
      .fadeIn(duration: 180.ms)
      .slideY(begin: 0.15, duration: 180.ms, curve: Curves.easeOutCubic);
}

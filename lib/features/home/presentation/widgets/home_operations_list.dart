import 'package:budgets/core/widgets/delayed_skeleton.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_edit_changes.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_row.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/activity_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/activities_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeOperationsList extends StatelessWidget {
  const HomeOperationsList({
    required this.entries,
    required this.isLoading,
    this.resolved = true,
    this.date,
    required this.isAdding,
    this.isLoadingMore = false,
    this.onCreate,
    required this.onEntryTap,
    this.currencyState,
    this.asSliver = false,
    this.pendingEdits = const {},
    super.key,
  });

  final VoidCallback? onCreate;
  final List<FinanceEntry> entries;
  final bool isLoading;
  final bool resolved;
  final DateTime? date;
  final bool isAdding;
  final bool isLoadingMore;
  final ValueChanged<FinanceEntry> onEntryTap;
  final CurrencyState? currencyState;
  final bool asSliver;
  final Map<String, FinanceEntryEditChanges> pendingEdits;

  @override
  Widget build(BuildContext context) => DelayedSkeleton(
        pending: isLoading && entries.isEmpty,
        requestKey: date,
        builder: _buildList,
      );

  Widget _buildList(BuildContext context, bool showSkeleton) {
    final slivers = <Widget>[
      if (resolved)
        SliverToBoxAdapter(
            child:
                ActivitiesSummary(entries: entries, currency: currencyState)),
      SliverPadding(
        padding: AppPageSpacing.insets(context),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (showSkeleton) {
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
              return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: KeyedSubtree(
                    key: ValueKey('ready-operation-${entry.id}'),
                    child: _animateItem(
                      context,
                      HomeOperationRow(
                        key: ValueKey('operation-${entry.id}'),
                        entry: entry,
                        isFirst: entryIndex == 0,
                        isLast: entryIndex == entries.length - 1,
                        pendingEdit: pendingEdits[entry.id],
                        currencyState: currencyState,
                        onTap: () => onEntryTap(entry),
                      ),
                      entryIndex,
                    ),
                  ));
            },
            childCount: showSkeleton
                ? 3
                : entries.length + (isAdding ? 1 : 0) + (isLoadingMore ? 3 : 0),
          ),
        ),
      ),
      if (resolved && !isAdding && entries.isEmpty)
        SliverToBoxAdapter(child: ActivityEmptyState(onAdd: onCreate)),
    ];
    if (asSliver) return SliverMainAxisGroup(slivers: slivers);
    return CustomScrollView(
      key: const Key('transaction-scroll-view'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );
  }

  Widget _animateItem(BuildContext context, Widget child, int index) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return child
        .animate(delay: (index < 3 ? 25 * index : 0).ms)
        .fadeIn(duration: 180.ms)
        .slideY(begin: 0.15, duration: 180.ms, curve: Curves.easeOutCubic);
  }
}

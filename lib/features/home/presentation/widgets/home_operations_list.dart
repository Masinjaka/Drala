import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
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
    super.key,
  });

  final List<FinanceEntry> entries;
  final bool isLoading;
  final bool isAdding;
  final ValueChanged<FinanceEntry> onEntryTap;
  final CurrencyState? currencyState;

  @override
  Widget build(BuildContext context) {
    final expenses = entries.where((entry) => entry.isExpense).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(29, 7, 28, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(context.l10n.operations,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              Text(context.l10n.expenseCount(expenses),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: isLoading
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  itemCount: 3,
                  itemBuilder: (context, index) => _animateItem(
                    HomeOperationSkeleton(
                      key: ValueKey('loading-operation-$index'),
                    ),
                    index,
                  ),
                )
              : ListView.builder(
                  key: const Key('transaction-scroll-view'),
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  itemCount: entries.length + (isAdding ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isAdding && index == 0) {
                      return _animateItem(
                        const HomeOperationSkeleton(
                          key: Key('pending-operation-skeleton'),
                        ),
                        0,
                      );
                    }
                    final entryIndex = index - (isAdding ? 1 : 0);
                    final entry = entries[entryIndex];
                    return _animateItem(
                      HomeOperationRow(
                        key: ValueKey('operation-${entry.id}'),
                        entry: entry,
                        currencyState: currencyState,
                        onTap: () => onEntryTap(entry),
                      ),
                      entryIndex,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _animateItem(Widget child, int index) => child
      .animate(delay: (50 * index).ms)
      .fadeIn(duration: 200.ms)
      .slideY(begin: 0.5, duration: 200.ms, curve: Curves.easeOut);
}

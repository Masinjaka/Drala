import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_section_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_tile.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverviewTransactionsSection extends StatelessWidget {
  const HomeOverviewTransactionsSection(
      {required this.entries,
      required this.loading,
      required this.viewModel,
      required this.onActivities,
      required this.onRefresh,
      this.currency,
      super.key});
  final List<FinanceEntry> entries;
  final bool loading;
  final AiEntryViewModel viewModel;
  final VoidCallback onActivities;
  final Future<void> Function() onRefresh;
  final CurrencyState? currency;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeOverviewSectionHeader(
              showSeeMore: entries.isNotEmpty,
              title: context.l10n.recentTransactions,
              onSeeMore: onActivities),
          if (loading && entries.isEmpty)
            const LinearProgressIndicator()
          else if (entries.isEmpty)
            HomeOverviewEmptyState(
                key: const Key('home-empty-transactions'),
                title: context.l10n.noRecentTransactions,
                asset:
                    'assets/illustrations/empty_states/home_transactions.png',
                actionLabel: context.l10n.trackYourBudget,
                actionKey: const Key('home-track-budget'),
                onPressed: onActivities)
          else
            for (var i = 0; i < entries.length; i++) ...[
              HomeOverviewTransactionTile(
                  entry: entries[i],
                  isFirst: i == 0,
                  isLast: i == entries.length - 1,
                  currency: currency,
                  onPressed: () async {
                    if (entries[i].isTransfer) {
                      onActivities();
                      return;
                    }
                    await HomeEntryActions(viewModel, currencyState: currency)
                        .editEntry(context, entries[i]);
                    await onRefresh();
                  }),
              if (i < entries.length - 1) const SizedBox(height: 4),
            ],
        ],
      );
}

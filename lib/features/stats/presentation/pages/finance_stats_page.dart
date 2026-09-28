import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:budgets/core/ui/month_carousel.dart';
import 'package:budgets/features/stats/data/repositories/supabase_monthly_stats_repository.dart';
import 'package:budgets/features/stats/data/services/monthly_stats_service.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/view_models/monthly_stats_view_model.dart';
import 'package:budgets/features/stats/presentation/widgets/monthly_spending_chart.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metrics_grid.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceStatsPage extends StatefulWidget {
  const FinanceStatsPage({
    this.repository,
    this.initialMonth,
    this.displayCurrency,
    super.key,
  });

  final MonthlyStatsRepository? repository;
  final DateTime? initialMonth;
  final CurrencyState? displayCurrency;

  @override
  State<FinanceStatsPage> createState() => _FinanceStatsPageState();
}

class _FinanceStatsPageState extends State<FinanceStatsPage> {
  late final MonthlyStatsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MonthlyStatsViewModel(
      widget.repository ??
          SupabaseMonthlyStatsRepository(
            MonthlyStatsService(Supabase.instance.client),
          ),
      widget.initialMonth ?? DateTime.now(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      await _viewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _changeMonth(int offset) async {
    try {
      await _viewModel.changeMonth(offset);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final stats = _viewModel.stats;
          if (stats == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(29, 0, 29, 32),
                  children: [
                    DetailPageHeader(title: context.l10n.stats),
                    const SizedBox(height: 24),
                    MonthCarousel(
                      month: _viewModel.month,
                      onChanged: _changeMonth,
                      canGoNext: _canGoForward,
                    ),
                    const SizedBox(height: 28),
                    StatsMetricsGrid(
                      stats: stats,
                      displayCurrency: widget.displayCurrency,
                    ),
                    const SizedBox(height: 17),
                    MonthlySpendingChart(values: stats.dailyExpenses),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return _viewModel.month.isBefore(DateTime(now.year, now.month));
  }
}

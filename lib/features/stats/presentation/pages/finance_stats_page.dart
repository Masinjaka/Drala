import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/month_scroll_layout.dart';
import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/month_carousel.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_page_header.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/features/stats/data/repositories/supabase_monthly_stats_repository.dart';
import 'package:budgets/features/stats/data/services/monthly_stats_service.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/view_models/monthly_stats_view_model.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_month_page.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceStatsPage extends StatefulWidget {
  const FinanceStatsPage({
    this.repository,
    this.showBackButton = true,
    this.initialMonth,
    this.displayCurrency,
    super.key,
  });

  final MonthlyStatsRepository? repository;
  final DateTime? initialMonth;
  final bool showBackButton;
  final CurrencyState? displayCurrency;

  @override
  State<FinanceStatsPage> createState() => _FinanceStatsPageState();
}

class _FinanceStatsPageState extends State<FinanceStatsPage> {
  static const _initialPage = 1200;
  late final MonthlyStatsViewModel _viewModel;
  late final DateTime _origin;
  late final PageController _pages;
  int _visit = 0;
  bool _categories = false;
  bool _active = false;

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
    _origin = _viewModel.month;
    _pages = PageController(initialPage: _initialPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = TickerMode.of(context);
    if (active && !_active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _active) _load();
      });
    }
    _active = active;
  }

  Future<void> _load() async {
    try {
      await _viewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _changeMonth(int offset) =>
      _pages.animateToPage(_pageFor(_viewModel.month) + offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);

  Future<void> _selectPage(int page) async {
    setState(() => _visit++);
    try {
      await _viewModel.selectMonth(_monthFor(page));
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _pickMonth() async {
    final selected = await AppWheelPicker.monthYear(context,
        initialDate: _viewModel.month,
        firstDate: _monthFor(0),
        lastDate: DateTime.now(),
        title: context.l10n.selectDate);
    if (selected != null && mounted) _pages.jumpToPage(_pageFor(selected));
  }

  DateTime _monthFor(int page) =>
      DateTime(_origin.year, _origin.month + page - _initialPage);
  int _pageFor(DateTime month) =>
      _initialPage +
      (month.year - _origin.year) * 12 +
      month.month -
      _origin.month;

  @override
  void dispose() {
    _pages.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStatsTheme.background(context),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final stats = _viewModel.stats;
          final amount = stats == null
              ? 0
              : widget.displayCurrency
                      ?.convertToSelected(stats.balance, stats.currencyCode) ??
                  stats.balance;
          return AppGridBackground(
              gravity: true,
              backgroundColor: AppStatsTheme.background(context),
              amount: amount,
              loading: stats == null,
              builder: (amountKey) => SafeArea(
                  bottom: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: AppHeaderMetrics.topPadding),
                    child: MonthScrollLayout(
                      scrollKey: const Key('stats-page-scroll'),
                      headerBuilder: (showMonth) => Padding(
                          padding: AppPageSpacing.insets(context),
                          child: StatsPageHeader(
                              showMonth: showMonth,
                              month: _viewModel.month,
                              onPickMonth: _pickMonth,
                              showBackButton: widget.showBackButton)),
                      carousel: MonthCarousel(
                          month: _viewModel.month,
                          onChanged: _changeMonth,
                          pillStyle: true,
                          canGoNext: _canGoForward),
                      child: PageView.builder(
                        key: const Key('stats-month-pages'),
                        controller: _pages,
                        itemCount: _pageFor(DateTime.now()) + 1,
                        onPageChanged: _selectPage,
                        itemBuilder: (context, page) {
                          final month = _monthFor(page);
                          return StatsMonthPage(
                              amountKey:
                                  month == _viewModel.month ? amountKey : null,
                              key: ValueKey(
                                  'stats-$month-${month == _viewModel.month ? _visit : -1}'),
                              categories: _categories,
                              onTabChanged: (value) =>
                                  setState(() => _categories = value),
                              stats: _viewModel.statsForMonth(month),
                              loading: _viewModel.isMonthLoading(month),
                              onRefresh: _load,
                              displayCurrency: widget.displayCurrency);
                        },
                      ),
                    ),
                  )));
        },
      ),
    );
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return _viewModel.month.isBefore(DateTime(now.year, now.month));
  }
}

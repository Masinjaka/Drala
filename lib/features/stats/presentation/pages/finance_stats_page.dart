import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:budgets/core/ui/month_picker_header.dart';
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
  static const _initialPage = 1200;
  late final MonthlyStatsViewModel _viewModel;
  late final DateTime _origin;
  late final PageController _pages;
  int _visit = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
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
        title: MaterialLocalizations.of(context).datePickerHelpText);
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 29),
                      child: DetailPageHeader(title: context.l10n.stats)),
                  const SizedBox(height: 32),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 29),
                      child: MonthPickerHeader(
                          month: _viewModel.month,
                          onChanged: _changeMonth,
                          onPickMonth: _pickMonth,
                          pickerKey: const Key('stats-pick-month'),
                          canGoNext: _canGoForward)),
                  const SizedBox(height: 28),
                  Expanded(
                      child: PageView.builder(
                    key: const Key('stats-month-pages'),
                    controller: _pages,
                    itemCount: _pageFor(DateTime.now()) + 1,
                    onPageChanged: _selectPage,
                    itemBuilder: (context, page) {
                      final month = _monthFor(page);
                      return StatsMonthPage(
                          key: ValueKey(
                              'stats-$month-${month == _viewModel.month ? _visit : -1}'),
                          stats: _viewModel.statsForMonth(month),
                          loading: _viewModel.isMonthLoading(month),
                          onRefresh: _load,
                          displayCurrency: widget.displayCurrency);
                    },
                  )),
                ]),
              ));
        },
      ),
    );
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return _viewModel.month.isBefore(DateTime(now.year, now.month));
  }
}

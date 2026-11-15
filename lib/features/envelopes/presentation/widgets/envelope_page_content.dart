import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/month_scroll_layout.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'envelope_page_header.dart';
import 'envelope_month_controls.dart';
import 'package:budgets/features/envelopes/presentation/view_models/envelope_view_model.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_month_page.dart';
import 'package:flutter/material.dart';

class EnvelopePageContent extends StatelessWidget {
  const EnvelopePageContent({
    required this.viewModel,
    required this.pageController,
    required this.pageOrigin,
    required this.initialPage,
    required this.onAdd,
    required this.onMonthChanged,
    required this.onPickMonth,
    required this.onPageChanged,
    required this.onRefresh,
    this.initialEnvelopeId,
    this.selectionBar,
    this.onSelect,
    this.selectedIds,
    this.onToggleSelection,
    this.displayCurrency,
    this.onEdit,
    this.showBackButton = true,
    super.key,
  });

  final EnvelopeViewModel viewModel;
  final bool showBackButton;
  final PageController pageController;
  final DateTime pageOrigin;
  final int initialPage;
  final VoidCallback onAdd;
  final VoidCallback onPickMonth;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function() onRefresh;
  final String? initialEnvelopeId;
  final Widget? selectionBar;
  final VoidCallback? onSelect;
  final Set<String>? selectedIds;
  final ValueChanged<String>? onToggleSelection;
  final CurrencyState? displayCurrency;
  final ValueChanged<Envelope>? onEdit;

  @override
  Widget build(BuildContext context) {
    final canScroll = viewModel.envelopes.isNotEmpty ||
        viewModel.isMonthLoading(viewModel.month);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: AppHeaderMetrics.topPadding),
        child: MonthScrollLayout(
          scrollKey: const Key('envelope-page-scroll'),
          canScroll: canScroll,
          carouselBottomPadding: 46,
          headerBuilder: (showMonth) => Column(children: [
            Padding(
              padding: AppPageSpacing.insets(context),
              child: EnvelopePageHeader(
                showMonth: showMonth,
                showBackButton: showBackButton,
                month: viewModel.month,
                onPickMonth: onPickMonth,
                onAdd: onAdd,
                onSelect: onSelect,
              ),
            ),
            if (selectionBar != null)
              Padding(
                  padding: AppPageSpacing.insets(context),
                  child: selectionBar!),
          ]),
          carousel: EnvelopeMonthControls(
              month: viewModel.month,
              onChanged: onMonthChanged,
              canGoNext: _canGoForward),
          child: PageView.builder(
            key: const Key('envelope-month-pages'),
            controller: pageController,
            itemCount: _pageForMonth(DateTime.now()) + 1,
            onPageChanged: onPageChanged,
            itemBuilder: (context, page) {
              final month = _monthForPage(page);
              return EnvelopeMonthPage(
                key: ValueKey('envelope-page-${month.year}-${month.month}'),
                envelopes: viewModel.envelopesForMonth(month),
                selectedIds: selectedIds,
                onToggleSelection: onToggleSelection,
                selectionEnabled: !viewModel.isSaving,
                isLoading: viewModel.isMonthLoading(month),
                resolved: viewModel.hasMonthData(month),
                onRefresh: onRefresh,
                onDelete: viewModel.delete,
                onEdit: onEdit,
                displayCurrency: displayCurrency,
                targetEnvelopeId:
                    _sameMonth(month, pageOrigin) ? initialEnvelopeId : null,
              );
            },
          ),
        ),
      ),
    );
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return viewModel.month.isBefore(DateTime(now.year, now.month));
  }

  DateTime _monthForPage(int page) =>
      DateTime(pageOrigin.year, pageOrigin.month + page - initialPage);
  int _pageForMonth(DateTime month) =>
      initialPage +
      (month.year - pageOrigin.year) * 12 +
      month.month -
      pageOrigin.month;
  bool _sameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;
}

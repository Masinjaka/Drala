import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:budgets/core/ui/month_picker_header.dart';
import 'package:budgets/features/envelopes/presentation/view_models/envelope_view_model.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_month_page.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
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
    this.displayCurrency,
    this.onEdit,
    super.key,
  });

  final EnvelopeViewModel viewModel;
  final PageController pageController;
  final DateTime pageOrigin;
  final int initialPage;
  final VoidCallback onAdd;
  final VoidCallback onPickMonth;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function() onRefresh;
  final String? initialEnvelopeId;
  final CurrencyState? displayCurrency;
  final ValueChanged<Envelope>? onEdit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DetailPageHeader(
                title: context.l10n.envelope,
                onAdd: onAdd,
                addTooltip: context.l10n.addEnvelope,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: MonthPickerHeader(
                month: viewModel.month,
                onChanged: onMonthChanged,
                canGoNext: _canGoForward,
                onPickMonth: onPickMonth,
                pickerKey: const Key('envelope-pick-month'),
              ),
            ),
            const SizedBox(height: 48),
            Expanded(
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
                    isLoading: viewModel.isMonthLoading(month),
                    onRefresh: onRefresh,
                    onDelete: viewModel.delete,
                    onEdit: onEdit,
                    displayCurrency: displayCurrency,
                    targetEnvelopeId: _sameMonth(month, pageOrigin)
                        ? initialEnvelopeId
                        : null,
                  );
                },
              ),
            ),
          ],
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

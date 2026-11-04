import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/month_calendar_button.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:flutter/material.dart';
import 'envelope_page_title.dart';

class EnvelopePageHeader extends StatelessWidget {
  const EnvelopePageHeader(
      {required this.onAdd,
      required this.showBackButton,
      required this.month,
      required this.onPickMonth,
      this.onSelect,
      this.showMonth = false,
      super.key});
  final bool showMonth;
  final VoidCallback onAdd;
  final VoidCallback? onSelect;
  final bool showBackButton;
  final DateTime month;
  final VoidCallback onPickMonth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Row(children: [
            Expanded(child: EnvelopePageTitle(onSelect: onSelect)),
            const SizedBox(width: AppHeaderMetrics.titleGap),
            MonthCalendarButton(
                month: month,
                showMonth: showMonth,
                maxWidth:
                    (constraints.maxWidth - (showBackButton ? 56 : 0) - 164)
                        .clamp(70.0, 190.0),
                onPressed: onPickMonth,
                buttonKey: const Key('envelope-pick-month'),
                yearKey: const Key('month-year')),
            if (showBackButton) ...[
              const SizedBox(width: AppHeaderMetrics.actionGap),
              AppCloseButton(onPressed: () => Navigator.maybePop(context)),
            ],
          ]));
}

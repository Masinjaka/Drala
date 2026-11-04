import 'package:budgets/core/ui/month_calendar_button.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class StatsPageHeader extends StatelessWidget {
  const StatsPageHeader(
      {required this.month,
      required this.onPickMonth,
      required this.showBackButton,
      this.showMonth = false,
      super.key});
  final bool showMonth;
  final DateTime month;
  final VoidCallback onPickMonth;
  final bool showBackButton;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Row(children: [
            Expanded(
                child: Text(context.l10n.stats,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStatsTheme.title(context))),
            MonthCalendarButton(
                month: month,
                showMonth: showMonth,
                maxWidth:
                    (constraints.maxWidth - (showBackButton ? 56 : 0) - 64)
                        .clamp(70.0, 190.0),
                onPressed: onPickMonth,
                buttonKey: const Key('stats-pick-month')),
            if (showBackButton) ...[
              const SizedBox(width: 8),
              AppCloseButton(onPressed: () => Navigator.maybePop(context)),
            ],
          ]));
}

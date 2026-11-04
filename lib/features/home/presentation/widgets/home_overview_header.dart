import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_notification_button.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeOverviewHeader extends StatelessWidget {
  const HomeOverviewHeader(
      {required this.today,
      required this.notifications,
      required this.onNotificationsPressed,
      this.displayName,
      super.key});
  final DateTime today;
  final String? displayName;
  final FinanceNotificationViewModel notifications;
  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    final name = displayName?.trim();
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            name == null || name.isEmpty
                ? context.l10n.homeHello
                : context.l10n.homeGreeting(name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppHomeOverviewTheme.welcome(context)),
        const SizedBox(height: 2),
        Text(DateFormat.MMMMEEEEd(locale).format(today),
            style: AppHomeOverviewTheme.date(context)),
      ])),
      const SizedBox(width: AppHeaderMetrics.titleGap),
      Theme(
          data: Theme.of(context)
              .copyWith(cardColor: AppHomeOverviewTheme.surface(context)),
          child: HomeNotificationButton(
              viewModel: notifications, onPressed: onNotificationsPressed)),
    ]);
  }
}

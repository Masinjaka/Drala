import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/features/home/presentation/widgets/home_notification_button.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';

class HomeDashboardHeader extends StatelessWidget {
  const HomeDashboardHeader({
    required this.notificationViewModel,
    required this.onNotificationsPressed,
    super.key,
  });

  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppPageSpacing.insets(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.activities,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppActivitiesTheme.title(context),
              ),
            ),
            const SizedBox(width: AppHeaderMetrics.titleGap),
            Theme(
                data: Theme.of(context)
                    .copyWith(cardColor: AppActivitiesTheme.card(context)),
                child: HomeNotificationButton(
                    viewModel: notificationViewModel,
                    onPressed: onNotificationsPressed)),
          ],
        ),
      );
}

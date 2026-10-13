import 'package:budgets/features/home/presentation/widgets/home_notification_button.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const SizedBox(width: 48),
            Expanded(
              child: Text(
                context.l10n.homeWelcome,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            HomeNotificationButton(
              viewModel: notificationViewModel,
              onPressed: onNotificationsPressed,
            ),
          ],
        ),
      );
}

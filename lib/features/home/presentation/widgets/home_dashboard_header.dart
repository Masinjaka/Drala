import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/home/presentation/widgets/home_notification_button.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeDashboardHeader extends StatelessWidget {
  const HomeDashboardHeader({
    required this.drawerProgress,
    required this.onMenuPressed,
    required this.notificationViewModel,
    required this.onNotificationsPressed,
    super.key,
  });

  final Animation<double> drawerProgress;
  final VoidCallback onMenuPressed;
  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: drawerProgress,
              builder: (context, child) => IgnorePointer(
                ignoring: drawerProgress.value > 0,
                child: Opacity(opacity: 1 - drawerProgress.value, child: child),
              ),
              child: OutlinedSquareButton(
                key: const Key('home-menu-button'),
                icon: Icons.menu_rounded,
                tooltip: context.l10n.menu,
                onPressed: onMenuPressed,
              ),
            ),
            Expanded(
              child: Text(
                context.l10n.homeWelcome,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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

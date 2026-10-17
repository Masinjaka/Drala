import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_count_badge.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';

class HomeNotificationButton extends StatelessWidget {
  const HomeNotificationButton({
    required this.viewModel,
    required this.onPressed,
    super.key,
  });

  final FinanceNotificationViewModel viewModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Stack(
        clipBehavior: Clip.none,
        children: [
          OutlinedSquareButton(
            key: const Key('notification-inbox-button'),
            icon: Icons.notifications_none_rounded,
            onPressed: onPressed,
          ),
          if (viewModel.unreadCount > 0)
            Positioned(
              right: -1,
              top: -2,
              child: NotificationCountBadge(
                key: const Key('notification-warning-badge'),
                count: viewModel.unreadCount,
              ),
            ),
        ],
      ),
    );
  }
}

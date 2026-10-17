import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_count_badge.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';

class SettingsNotificationButton extends StatelessWidget {
  const SettingsNotificationButton({
    required this.onPressed,
    this.viewModel,
    super.key,
  });

  final FinanceNotificationViewModel? viewModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final model = viewModel;
    if (model == null) return _button(context, 0);
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) => _button(context, model.unreadCount),
    );
  }

  Widget _button(BuildContext context, int unreadCount) => Stack(
        clipBehavior: Clip.none,
        children: [
          OutlinedSquareButton(
            key: const Key('settings-notification-button'),
            icon: Icons.notifications_none_rounded,
            onPressed: onPressed,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -1,
              top: -2,
              child: NotificationCountBadge(
                key: const Key('settings-notification-badge'),
                count: unreadCount,
              ),
            ),
        ],
      );
}

import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class NotificationCountBadge extends StatelessWidget {
  const NotificationCountBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          shape: BoxShape.circle,
        ),
        child: Text(
          '${count.clamp(0, 9)}',
          style: AppTextTheme.notificationBadge(context),
        ),
      );
}

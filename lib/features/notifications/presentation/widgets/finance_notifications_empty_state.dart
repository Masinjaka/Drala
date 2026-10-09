import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class FinanceNotificationsEmptyState extends StatelessWidget {
  const FinanceNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 38,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.noNotifications,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            Text(
              context.l10n.noNotificationsDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

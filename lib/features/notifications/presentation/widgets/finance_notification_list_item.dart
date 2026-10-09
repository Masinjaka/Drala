import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceNotificationListItem extends StatelessWidget {
  const FinanceNotificationListItem({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final FinanceNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Material(
      color:
          notification.isRead ? colors.surface : colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: Key('finance-notification-${notification.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_rounded,
                color: colors.error,
                size: 25,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      switch (notification.notificationType) {
                        'envelope_near_limit' => context.l10n
                            .envelopeBudgetAlmostReached(
                                notification.envelopeName),
                        'envelope_limit_reached' => context.l10n
                            .envelopeBudgetReached(notification.envelopeName),
                        _ => context.l10n
                            .envelopeBudgetExceeded(notification.envelopeName),
                      },
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat.yMMMd(locale).add_Hm().format(
                            notification.createdAt.toLocal(),
                          ),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

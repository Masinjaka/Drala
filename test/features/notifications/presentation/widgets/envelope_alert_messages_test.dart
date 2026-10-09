import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/widgets/finance_notification_list_item.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final (type, expected) in [
    ('envelope_near_limit', 'The Food envelope is almost spent.'),
    ('envelope_limit_reached', 'The Food envelope budget has been reached.'),
    ('envelope_overspent', 'You went over your budget for the Food envelope.'),
  ]) {
    testWidgets('shows $type message in the notification inbox',
        (tester) async {
      final notification = FinanceNotification(
        id: 'alert',
        envelopeId: 'envelope',
        envelopeName: 'Food',
        amount: 10,
        periodMonth: DateTime(2026, 10),
        isRead: false,
        createdAt: DateTime(2026, 10, 5),
        notificationType: type,
      );
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FinanceNotificationListItem(
            notification: notification,
            onTap: () {},
          ),
        ),
      ));
      expect(find.text(expected), findsOneWidget);
    });
  }
}

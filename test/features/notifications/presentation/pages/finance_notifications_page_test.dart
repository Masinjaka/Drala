import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/pages/finance_notifications_page.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_finance_notification_repository.dart';

void main() {
  testWidgets('friendly empty inbox offers notification settings',
      (tester) async {
    final viewModel =
        FinanceNotificationViewModel(FakeFinanceNotificationRepository([]));
    addTearDown(viewModel.dispose);
    var opened = false;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: FinanceNotificationsPage(
          viewModel: viewModel,
          onSelected: (_, __) async {},
          onSettings: () => opened = true),
    ));
    await tester.pumpAndSettle();
    expect(find.text('You’re all caught up! We’ll keep you posted here.'),
        findsOneWidget);
    await tester.tap(find.text('Manage notifications'));
    expect(opened, isTrue);
  });

  testWidgets('marks a warning read and opens its envelope', (tester) async {
    final repository = FakeFinanceNotificationRepository([_notification]);
    final viewModel = FinanceNotificationViewModel(repository);
    FinanceNotification? selected;
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinanceNotificationsPage(
          viewModel: viewModel,
          onSelected: (_, notification) async => selected = notification,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('You went over your budget for the Food envelope.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('finance-notification-warning')));
    await tester.pump();

    expect(repository.markedRead, ['warning']);
    expect(selected?.envelopeId, 'food');
    expect(viewModel.unreadCount, 0);
  });
}

final _notification = FinanceNotification(
  id: 'warning',
  envelopeId: 'food',
  envelopeName: 'Food',
  amount: 25000,
  periodMonth: DateTime(2026, 7),
  isRead: false,
  createdAt: DateTime(2026, 7, 26),
);

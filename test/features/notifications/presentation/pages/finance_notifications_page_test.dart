import 'package:budgets/core/widgets/empty_state_illustration.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/pages/finance_notifications_page.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_finance_notification_repository.dart';

void main() {
  for (final overflow in [false, true]) {
    testWidgets(
        'empty inbox is informational and scrolls only if needed '
        '(overflow=$overflow)', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize =
          overflow ? const Size(350, 280) : const Size(412, 917);
      const safeInsets = FakeViewPadding(top: 48, bottom: 34);
      tester.view.padding = safeInsets;
      tester.view.viewPadding = safeInsets;
      addTearDown(tester.view.reset);
      final viewModel =
          FinanceNotificationViewModel(FakeFinanceNotificationRepository([]));
      addTearDown(viewModel.dispose);
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(overflow ? 3 : 1)),
          child: child!,
        ),
        home: FinanceNotificationsPage(
          viewModel: viewModel,
          onSelected: (_, __) async {},
        ),
      ));
      await tester.pumpAndSettle();

      final message =
          find.text('You’re all caught up! We’ll keep you posted here.');
      expect(message, findsOneWidget);
      expect(find.text('Manage notifications'), findsNothing);
      final close = find.byTooltip('Close');
      final headerPosition = tester.getCenter(close);
      final scroll = find.byType(Scrollable);
      if (!overflow) {
        final illustration =
            tester.getRect(find.byType(EmptyStateIllustration));
        final copy = tester.getRect(message);
        final viewport = tester.getRect(scroll);
        expect(viewport.bottom, 917 - safeInsets.bottom);
        expect((illustration.top + copy.bottom) / 2,
            closeTo(viewport.center.dy, .01));
        expect(illustration.center.dx, viewport.center.dx);
        expect(copy.center.dx, viewport.center.dx);
      }
      final position = tester.state<ScrollableState>(scroll).position;
      await tester.drag(scroll, const Offset(0, -160));
      await tester.pumpAndSettle();
      expect(position.pixels, overflow ? greaterThan(0) : 0);
      expect(tester.getCenter(close), headerPosition);
      expect(tester.takeException(), isNull);
    });
  }

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

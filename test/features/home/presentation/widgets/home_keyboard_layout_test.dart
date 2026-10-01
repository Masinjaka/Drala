import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_transition.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../../notifications/support/fake_finance_notification_repository.dart';

void main() {
  for (final month in [false, true]) {
    testWidgets('keyboard fits with suggestions and month view $month',
        (tester) async {
      await _pumpDashboard(tester);
      if (month) {
        await tester.tap(find.byKey(const Key('calendar-view-toggle')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byType(TextField));
      await tester.pump(const Duration(milliseconds: 350));
      for (final inset in [180.0, 300.0, 430.0, 500.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: inset);
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.pump(const Duration(milliseconds: 350));
        expect(tester.takeException(), isNull);
        expect(find.byType(HomeWeekTransition), findsOneWidget);
        final composer =
            tester.getRect(find.byKey(const Key('chat-input-container')));
        expect(composer.bottom, lessThanOrEqualTo(800 - inset));
      }
      await tester.enterText(
          find.byType(TextField), 'Food\nLunch\nCoffee\nDinner');
      await tester.pump(const Duration(milliseconds: 350));
      expect(tester.takeException(), isNull);
      tester.view.viewInsets = const FakeViewPadding();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeMonthCalendar),
          month ? findsOneWidget : findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('short landscape and large French text fit without keyboard',
      (tester) async {
    await _pumpDashboard(tester);
    tester.view.physicalSize = const Size(800, 320);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeWeekTransition), findsOneWidget);
    expect(
        tester.getSize(find.byKey(const Key('transaction-scroll-view'))).height,
        greaterThan(0));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _pumpDashboard(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(411.4, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetViewInsets);
  final today = DateTime(2026, 9, 26);
  final model = AiEntryViewModel(FakeAiEntryRepository(), today);
  final notifications =
      FinanceNotificationViewModel(FakeFinanceNotificationRepository());
  addTearDown(model.dispose);
  addTearDown(notifications.dispose);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.3)),
      child: child!,
    ),
    home: Scaffold(
        body: HomeDashboard(
      today: today,
      drawerProgress: const AlwaysStoppedAnimation(0),
      onMenuPressed: () {},
      viewModel: model,
      notificationViewModel: notifications,
      onNotificationsPressed: () {},
      onFinanceChanged: () async {},
      onDateSelected: (_) {},
    )),
  ));
  await tester.pumpAndSettle();
}

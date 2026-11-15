import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/chat_home_layout.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../../notifications/support/fake_finance_notification_repository.dart';
import '../../support/home_test_window.dart';

void main() {
  testWidgets(
      'guest activities shows a manual entry FAB instead of the composer',
      (tester) async {
    await _pumpLayout(tester, manualOnly: true);

    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsOneWidget);
    expect(find.byTooltip('Manual entry'), findsOneWidget);

    await tester.tap(find.byKey(const Key('guest-manual-entry-fab')));
    await tester.pumpAndSettle();
    expect(find.byType(ManualEntrySheet), findsOneWidget);
  });

  testWidgets('signed-in activities keeps the composer and has no manual FAB',
      (tester) async {
    await _pumpLayout(tester, manualOnly: false);

    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsNothing);
  });

  testWidgets(
      'exhausted credits show manual entry and restore the composer after reset',
      (tester) async {
    final repository = FakeAiEntryRepository()..remaining = 5;
    final model =
        await _pumpLayout(tester, manualOnly: false, repository: repository);
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('activity-ai-credits')), findsOneWidget);
    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    repository.remaining = 0;
    await model.refreshAiQuota();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsOneWidget);
    expect(find.byKey(const Key('ai-credit-exhausted-notice')), findsOneWidget);
    repository.remaining = 5;
    await model.refreshAiQuota();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    expect(find.byKey(const Key('ai-credit-exhausted-notice')), findsNothing);
  });

  testWidgets('guest manual FAB only appears on the activities tab',
      (tester) async {
    await _pumpLayout(tester, manualOnly: true);

    await tester.tap(find.byKey(const ValueKey('home-navigation-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsOneWidget);
  });
}

Future<AiEntryViewModel> _pumpLayout(
  WidgetTester tester, {
  required bool manualOnly,
  FakeAiEntryRepository? repository,
}) async {
  usePhoneWindow(tester);
  repository ??= FakeAiEntryRepository();
  final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 25));
  await viewModel.loadDate(DateTime(2026, 7, 25));
  final activity = ActivityCalendarViewModel(repository);
  final notifications = FinanceNotificationViewModel(
    FakeFinanceNotificationRepository(),
  );
  addTearDown(viewModel.dispose);
  addTearDown(activity.dispose);
  addTearDown(notifications.dispose);

  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ChatHomeLayout(
      today: DateTime(2026, 7, 25),
      viewModel: viewModel,
      activityCalendarViewModel: activity,
      notificationViewModel: notifications,
      onNotificationsPressed: () {},
      onFinanceChanged: () async {},
      onDateSelected: (_) {},
      destinations: const [
        SizedBox.shrink(),
        SizedBox.shrink(),
        SizedBox.shrink(),
      ],
      onActivitiesSelected: () {},
      manualOnly: manualOnly,
    ),
  ));
  await tester.pumpAndSettle();
  return viewModel;
}

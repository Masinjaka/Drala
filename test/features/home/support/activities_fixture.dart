import 'dart:async';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/chat_home_layout.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../notifications/support/fake_finance_notification_repository.dart';

class ActivitiesFixture {
  ActivitiesFixture({int entryCount = 4}) {
    repository.entries = List.generate(
        entryCount,
        (i) => FinanceEntry(
            id: '$i',
            title: i == 1 ? 'Salary this month' : 'Week food',
            categoryName: i == 1 ? 'Salary' : 'Food & drinks',
            amount: 30000,
            occurredAt: DateTime(2026, 9, 26),
            transactionType: i == 1 ? 'income' : 'expense',
            currencyCode: 'MGA',
            iconKey: i == 1 ? 'salary' : 'food',
            emoji: ''));
    repository.activityDates = {DateTime(2026, 9, 23), DateTime(2026, 9, 24)};
    model = AiEntryViewModel(repository, today);
    calendar = ActivityCalendarViewModel(repository);
    notifications = FinanceNotificationViewModel(
        FakeFinanceNotificationRepository(List.generate(
            5,
            (i) => FinanceNotification(
                id: '$i',
                envelopeId: 'food',
                envelopeName: 'Food',
                amount: 100,
                periodMonth: today,
                isRead: false,
                createdAt: today))));
  }
  final today = DateTime(2026, 9, 26);
  final repository = FakeAiEntryRepository();
  late final AiEntryViewModel model;
  late final ActivityCalendarViewModel calendar;
  late final FinanceNotificationViewModel notifications;

  Future<void> load() => Future.wait(
      [model.loadDate(today), calendar.loadMonth(today), notifications.load()]);
  void dispose() {
    model.dispose();
    calendar.dispose();
    notifications.dispose();
  }

  Widget app(
          {bool dark = false,
          bool manualOnly = false,
          bool reducedMotion = false,
          double scale = 1}) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                disableAnimations: reducedMotion,
                textScaler: TextScaler.linear(scale)),
            child: child!),
        home: RepaintBoundary(
            key: const Key('activities-golden'),
            child: ChatHomeLayout(
              today: today,
              viewModel: model,
              activityCalendarViewModel: calendar,
              notificationViewModel: notifications,
              onNotificationsPressed: () {},
              onFinanceChanged: () async {},
              onDateSelected: (date) => unawaited(model.loadDate(date)),
              onActivitiesSelected: () {},
              manualOnly: manualOnly,
              destinations: const [
                SizedBox.shrink(),
                SizedBox.shrink(),
                SizedBox.shrink()
              ],
            )),
      );
}

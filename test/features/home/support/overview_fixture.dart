import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../notifications/support/fake_finance_notification_repository.dart';
import 'overview_envelope_repository.dart';

FakeAiEntryRepository overviewEntries() => FakeAiEntryRepository()
  ..walletItems = const [
    WalletSummary(
        id: 'cash',
        name: 'Cash',
        balance: 2350000,
        currencyCode: 'MGA',
        iconKey: 'wallet',
        isDefault: true)
  ]
  ..monthlyEntries = List.generate(
      4,
      (i) => FinanceEntry(
          id: '$i',
          title: [
            'Salary this month',
            'Week food',
            'Week food',
            'Week food'
          ][i],
          categoryName: i == 0 ? 'Salary' : 'Food & drinks',
          amount: i == 0
              ? 300000
              : i == 1
                  ? 100000
                  : 50000,
          occurredAt: DateTime(2026, 10, 21 - i),
          transactionType: i == 0 ? 'income' : 'expense',
          currencyCode: 'MGA',
          iconKey: i == 0 ? 'salary' : 'food',
          emoji: ''));

Widget overviewFixture(
    {bool dark = false,
    double scale = 1,
    AmountVisibilityController? visibility,
    FakeAiEntryRepository? entryRepository,
    OverviewEnvelopeRepository? envelopeRepository,
    MonthlyStatsRepository? statsRepository,
    Key? homeKey}) {
  final page = ChatHomePage(
      key: homeKey,
      today: DateTime(2026, 10, 23),
      displayName: 'Masy',
      aiEntryRepository: entryRepository ?? overviewEntries(),
      envelopeRepository: envelopeRepository ?? OverviewEnvelopeRepository(),
      statsRepository: statsRepository,
      notificationRepository: FakeFinanceNotificationRepository(),
      isGuest: true);
  return MaterialApp(
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: visibility == null
              ? child!
              : AmountVisibilityScope(controller: visibility, child: child!)),
      home: RepaintBoundary(key: const Key('overview-golden'), child: page));
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../envelopes/support/funding_envelope_repository.dart';
import '../../notifications/support/fake_finance_notification_repository.dart';

Widget emptyHomeFixture({bool dark = false, double scale = 1}) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!),
      home: RepaintBoundary(
          key: const Key('empty-home-golden'),
          child: ChatHomePage(
            today: DateTime(2026, 10, 28),
            displayName: 'Masy',
            isGuest: true,
            aiEntryRepository: FakeAiEntryRepository(),
            envelopeRepository: FundingEnvelopeRepository(),
            notificationRepository: FakeFinanceNotificationRepository(),
          )),
    );

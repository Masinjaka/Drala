import 'dart:async';

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_choices.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_skeleton.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest currency choices work without requesting cloud rates',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    var rateRequests = 0;
    String? selected;
    final pendingRates = Completer<ExchangeRates?>();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        guestSessionProvider.overrideWithValue(guest),
        exchangeRatesProvider.overrideWith((ref) {
          rateRequests++;
          return pendingRates.future;
        }),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SafeArea(
            child: SetupCurrencyChoices(
              selected: 'MGA',
              onChanged: (code) => selected = code,
            ),
          ),
        ),
      ),
    ));
    await tester.pump(const Duration(seconds: 1));

    expect(rateRequests, 0);
    expect(find.byType(SetupCurrencySkeleton), findsNothing);
    expect(find.text('Euro'), findsOneWidget);
    await tester.tap(find.text('Euro'));
    expect(selected, 'EUR');
  });
}

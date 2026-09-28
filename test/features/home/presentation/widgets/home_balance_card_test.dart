import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a dash while loading then counts near the final values',
      (tester) async {
    var isLoading = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SizedBox(),
        ),
        builder: (context, _) => StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: HomeBalanceCard(
                balance: 500,
                income: 400,
                expenses: 300,
                currencyCode: 'MGA',
                isLoading: isLoading,
              ),
            );
          },
        ),
      ),
    );

    expect(
      find.byKey(const Key('home-balance-loading-amount')),
      findsOneWidget,
    );
    expect(find.text('-'), findsOneWidget);
    expect(find.byKey(const Key('home-balance-amount')), findsNothing);
    expect(find.byKey(const Key('home-balance-currency')), findsNothing);
    expect(find.byKey(const Key('home-balance-monthly-group')), findsNothing);

    update(() => isLoading = false);
    await tester.pump();

    expect(
      find.byKey(const Key('home-balance-loading-amount')),
      findsNothing,
    );
    expect(find.byType(AnimatedDigitWidget), findsOneWidget);
    final balanceController = tester
        .widget<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
        .controller;

    await tester.pump(const Duration(milliseconds: 799));
    expect(find.byKey(const Key('home-balance-monthly-group')), findsNothing);

    await tester.pump(const Duration(milliseconds: 2));
    expect(find.byKey(const Key('home-balance-monthly-group')), findsOneWidget);
    expect(find.byType(AnimatedDigitWidget), findsNWidgets(3));
    expect(
      tester
          .widgetList<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
          .first
          .controller,
      same(balanceController),
    );

    await tester.pumpAndSettle();
    final counters = tester
        .widgetList<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
        .toList();
    expect(
        counters.map((counter) => counter.controller?.value), [500, 400, 300]);

    update(() {});
    await tester.pump();

    expect(
      tester
          .widgetList<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
          .toList(),
      orderedEquals(counters),
    );
  });

  testWidgets('matches the reference balance banner', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(354, 110);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: HomeBalanceCard(
            balance: 1500000,
            income: 300000,
            expenses: 100000,
            currencyCode: 'MGA',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final amount = tester.getRect(find.byKey(const Key('home-balance-amount')));
    final currency =
        tester.getRect(find.byKey(const Key('home-balance-currency')));
    final income = tester.getRect(find.byKey(const Key('home-balance-income')));
    final expenses =
        tester.getRect(find.byKey(const Key('home-balance-expenses')));
    final card = tester.getRect(find.byKey(const Key('home-balance-card')));
    final label = tester.getRect(find.byKey(const Key('home-balance-label')));
    final month =
        tester.getRect(find.byKey(const Key('home-balance-month-label')));
    final eye = tester.getRect(find.byKey(const Key('home-balance-eye')));

    expect(amount.left, 24);
    expect(currency.left, greaterThan(amount.right));
    expect(month.left, currency.right + 20);
    expect(income.left, month.left);
    expect(expenses.left, greaterThan(income.right));
    for (final bottom in [
      amount.bottom,
      currency.bottom,
      income.bottom,
      expenses.bottom,
    ]) {
      expect(bottom, closeTo(90, 0.01));
    }
    expect(eye.left, greaterThan(label.right));
    expect(eye.right, card.right - 22);

    await expectLater(
      find.byKey(const Key('home-balance-card')),
      matchesGoldenFile('goldens/home_balance_card.png'),
    );
  });
}

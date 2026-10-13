import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('banner toggle animates between the amount and obfuscation',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(354, 200);
    addTearDown(tester.view.reset);
    final controller = AmountVisibilityController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => AmountVisibilityScope(
          controller: controller,
          child: child ?? const SizedBox.shrink(),
        ),
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

    expect(find.byType(AnimatedDigitWidget), findsOneWidget);
    expect(find.byKey(const Key('home-balance-currency')), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('home-balance-visibility-toggle')),
    );
    await tester.pump();

    expect(find.text('***'), findsOneWidget);
    expect(find.byType(AnimatedDigitWidget), findsOneWidget);

    final hidden = find.byKey(const ValueKey('hidden-home-balance'));
    final startLeft = tester.getTopLeft(hidden).dx;
    await tester.pump(const Duration(milliseconds: 130));
    final middleLeft = tester.getTopLeft(hidden).dx;
    await tester.pump(const Duration(milliseconds: 130));
    final endLeft = tester.getTopLeft(hidden).dx;
    await tester.pump(const Duration(milliseconds: 16));
    final settledLeft = tester.getTopLeft(hidden).dx;

    expect(middleLeft, lessThan(startLeft));
    expect(endLeft, lessThan(middleLeft));
    expect(settledLeft, closeTo(endLeft, .01));

    await tester.pumpAndSettle();
    expect(find.byType(AnimatedDigitWidget), findsNothing);
    expect(find.byKey(const Key('home-balance-currency')), findsNothing);

    await tester.tap(
      find.byKey(const Key('home-balance-visibility-toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('***'), findsNothing);
    expect(find.byType(AnimatedDigitWidget), findsOneWidget);
    expect(find.byKey(const Key('home-balance-currency')), findsOneWidget);
  });
}

import 'dart:async';

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/ui/app_glass_backdrop.dart';
import 'package:budgets/features/settings/presentation/pages/currency_selection_page.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_currency_list.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../core/forms/support/form_currency_controller.dart';

void main() {
  testWidgets('Currency scrolls through the footer fade to the last option',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 680);
    const safeArea = FakeViewPadding(bottom: 34);
    tester.view.padding = safeArea;
    tester.view.viewPadding = safeArea;
    addTearDown(tester.view.reset);
    final rates = Completer<ExchangeRates?>();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        currencyControllerProvider.overrideWith(FormCurrencyController.new),
        exchangeRatesProvider.overrideWith((_) => rates.future),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CurrencySelectionPage(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Ariary'), findsOneWidget);
    final footerFade = find.byWidgetPredicate(
        (widget) => widget is AppGlassBackdrop && widget.top);
    expect(footerFade, findsOneWidget);
    final scroll = find
        .descendant(
          of: find.byType(SettingsCurrencyList),
          matching: find.byType(Scrollable),
        )
        .first;
    final last = find.byKey(const ValueKey('ZAR'));
    await tester.scrollUntilVisible(last, 350, scrollable: scroll);
    await tester.drag(scroll, const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.text('South African Rand').hitTestable(), findsOneWidget);
    expect(tester.getRect(last).bottom,
        lessThanOrEqualTo(tester.getRect(footerFade).top));

    final position = tester.state<ScrollableState>(scroll).position;
    position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'jpy');
    await tester.pumpAndSettle();
    expect(find.text('Japanese Yen'), findsOneWidget);
    expect(find.text('Ariary'), findsNothing);
    rates.complete(null);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

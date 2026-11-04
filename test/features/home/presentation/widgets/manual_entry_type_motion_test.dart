import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_type_pages.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tabs slide in both directions and retain transaction inputs',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => ManualEntrySheet.show(context,
                categories: Future.value(const []),
                targetDate: DateTime(2026, 11, 3),
                allowTransfers: true),
            child: const Text('Open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('transaction-amount')), '123');
    await tester.enterText(find.byType(TextFormField).at(1), 'Retained title');
    final pages = tester.widget<PageView>(find.descendant(
        of: find.byType(ManualEntryTypePages),
        matching: find.byType(PageView)));
    final controller = pages.controller!;
    final close = find.byKey(const Key('close-transaction-sheet'));
    final expense = find.byKey(const Key('transaction-type-expense'));
    final closeBounds = tester.getRect(close);
    final tabBounds = tester.getRect(expense);
    void expectFixedHeader() {
      expect(close, findsOneWidget);
      expect(expense, findsOneWidget);
      expect(tester.getRect(close), closeBounds);
      expect(tester.getRect(expense), tabBounds);
      expect(
          find.descendant(
              of: find.byType(ManualEntryTypePages), matching: close),
          findsNothing);
    }

    await tester
        .tap(find.byKey(const Key('transaction-type-income')).hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expectFixedHeader();
    // Envelope's 300 ms easeOutCubic horizontal page motion.
    expect(controller.page, closeTo(Curves.easeOutCubic.transform(.5), .01));
    await tester.pump(const Duration(milliseconds: 150));
    expect(controller.page, 1);
    await tester.pumpAndSettle();

    await tester
        .tap(find.byKey(const Key('transaction-type-transfer')).hitTestable());
    await tester.pumpAndSettle();
    expect(controller.page, 2);
    expectFixedHeader();
    expect(find.byKey(const Key('save-manual-transfer')), findsOneWidget);
    await tester
        .tap(find.byKey(const Key('transaction-type-expense')).hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expectFixedHeader();
    expect(controller.page,
        closeTo(2 * (1 - Curves.easeOutCubic.transform(.5)), .01));
    await tester.pumpAndSettle();
    expect(controller.page, 0);
    expect(
        tester
            .widget<TextFormField>(
                find.byKey(const Key('transaction-amount')).hitTestable())
            .controller!
            .text,
        '123');
    expect(
        tester
            .widget<TextFormField>(
                find.byType(TextFormField).hitTestable().last)
            .controller!
            .text,
        'Retained title');
    expect(tester.takeException(), isNull);
  });
}

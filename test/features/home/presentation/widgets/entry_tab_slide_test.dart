import 'package:budgets/core/ui/sliding_tab_indicator.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'entry indicator slides continuously through income and transfer tabs',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => ManualEntrySheet.show(context,
                        categories: Future.value([]),
                        targetDate: DateTime(2026, 11, 2),
                        allowTransfers: true),
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    Animation<double> indicator() => tester
        .widget<SlidingTabIndicator>(
            find.byKey(const Key('entry-selected-pill')))
        .animation;
    expect(indicator().value, 0);
    for (final (tab, end) in [
      ('income', 1.0),
      ('transfer', 2.0),
      ('expense', 0.0)
    ]) {
      final start = indicator().value;
      await tester.tap(find.byKey(Key('transaction-type-$tab')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(indicator().value, greaterThan(start < end ? start : end));
      expect(indicator().value, lessThan(start > end ? start : end));
      await tester.pumpAndSettle();
      expect(indicator().value, end);
    }
    expect(tester.takeException(), isNull);
  });
}

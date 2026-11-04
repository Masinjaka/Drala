import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'long validation messages and Save remain reachable by touch on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('de'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!),
      home: Scaffold(
          body: Builder(
              builder: (context) => TextButton(
                    onPressed: () => AddEnvelopeSheet.show(context,
                        categories: const [],
                        month: DateTime(2026, 10),
                        onSave: (_, __, ___, ____) async {}),
                    child: const Text('Open'),
                  ))),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final scroll = find.descendant(
        of: find.byType(TransactionEditScrollView),
        matching: find.byType(CustomScrollView));
    await tester.drag(scroll, const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('de'));
    expect(find.text(l10n.envelopeNameRequired), findsOneWidget);
    expect(find.text(l10n.envelopeCategoryRequired), findsOneWidget);
    expect(find.text(l10n.positiveAmountRequired), findsOneWidget);
    await tester.drag(scroll, const Offset(0, 800));
    await tester.pumpAndSettle();
    expect(
        tester
            .getRect(find.text(l10n.positiveAmountRequired))
            .overlaps(tester.getRect(scroll)),
        isTrue);
    await tester.drag(scroll, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(const Key('save-envelope-button'))).bottom,
        lessThanOrEqualTo(640));
    expect(tester.takeException(), isNull);
  });
}

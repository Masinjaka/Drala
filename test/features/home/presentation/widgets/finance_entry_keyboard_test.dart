import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet_route.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final height in [640.0, 917.0]) {
      testWidgets('edit fields stay above keyboard on $platform at $height',
          (tester) async {
        tester.view.physicalSize = Size(412, height);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          theme: ThemeData(platform: platform),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Builder(builder: (context) {
            return TextButton(
              onPressed: () => showFinanceEntryDetailSheet(
                context,
                entry: FinanceEntry(
                  id: 'entry',
                  title: 'Lunch',
                  description: 'With a friend',
                  categoryName: 'Food',
                  categoryId: 'food',
                  amount: 12000,
                  occurredAt: DateTime(2026, 7, 20),
                  transactionType: 'expense',
                  currencyCode: 'MGA',
                  iconKey: 'food',
                  emoji: '🍔',
                ),
                categories: Future.value(const []),
              ),
              child: const Text('Open'),
            );
          })),
        ));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        final originalSurface = tester.getRect(
          find.byKey(const Key('transaction-sheet-surface')),
        );

        // Focus the lowest field before opening the keyboard, then switch
        // fields while it remains open, as with keyboard Next navigation.
        for (final (index, keyboardHeight) in [
          (2, 240.0),
          (0, 320.0),
          (1, 280.0),
          (2, 360.0),
        ]) {
          final field = find.byType(TextFormField).at(index);
          await tester.showKeyboard(field);
          tester.view.viewInsets = FakeViewPadding(bottom: keyboardHeight);
          await tester.pumpAndSettle();
          final bounds = tester.getRect(field);
          final surface = tester.getRect(
            find.byKey(const Key('transaction-sheet-surface')),
          );
          expect(bounds.top, greaterThanOrEqualTo(surface.top),
              reason: 'Field $index: $bounds');
          expect(bounds.bottom, lessThanOrEqualTo(height - keyboardHeight));
          expect(surface.size, originalSurface.size);
          expect(surface.bottom, closeTo(height - keyboardHeight - 12, 0.1));
          expect(tester.takeException(), isNull);
        }

        final description = find.byType(TextFormField).at(2);
        await tester.tap(description);
        await tester.pumpAndSettle();
        final editable = tester.widget<EditableText>(
          find.descendant(of: description, matching: find.byType(EditableText)),
        );
        expect(editable.focusNode.hasFocus, isTrue);

        final surface = tester.getRect(
          find.byKey(const Key('transaction-sheet-surface')),
        );
        await tester.tapAt(Offset(surface.left + 8, surface.center.dy));
        await tester.pumpAndSettle();
        expect(editable.focusNode.hasFocus, isFalse);
        expect(tester.testTextInput.isVisible, isFalse);
        expect(
            find.byKey(const Key('transaction-sheet-surface')), findsOneWidget);

        tester.view.viewInsets = FakeViewPadding.zero;
        await tester.pumpAndSettle();
        expect(
          tester.getRect(find.byKey(const Key('transaction-sheet-surface'))),
          originalSurface,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}

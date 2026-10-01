import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet_route.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('existing expense opens the redesigned detail sheet and saves',
      (tester) async {
    ManualEntrySheetResult? result;
    await _pumpApp(tester, (context) async {
      result = await showFinanceEntryDetailSheet(
        context,
        entry: _entry,
        categories: Future.value(const [_food, _utility]),
        currencyState: _currency,
      );
    });

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Edit transaction'), findsOneWidget);
    expect(find.byKey(const Key('transaction-sheet-surface')), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);

    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('category-search')), findsOneWidget);
    await tester.tap(find.text('🔦 Utility'));
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), 'Team lunch');
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();

    expect(result?.action, ManualEntrySheetAction.save);
    expect(result?.input?.title, 'Team lunch');
    expect(result?.input?.categoryId, 'utility');
    expect(result?.input?.sourceWalletId, 'cash');
  });

  testWidgets('delete returns through the existing edit action flow',
      (tester) async {
    ManualEntrySheetResult? result;
    await _pumpApp(tester, (context) async {
      result = await showFinanceEntryDetailSheet(
        context,
        entry: _entry,
        categories: Future.value(const [_food]),
      );
    });

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete-transaction')));
    await tester.pumpAndSettle();

    expect(result?.action, ManualEntrySheetAction.delete);
  });
}

Future<void> _pumpApp(
  WidgetTester tester,
  Future<void> Function(BuildContext context) open,
) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => open(context),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

const _food = ManualEntryCategory(
  id: 'food',
  name: 'Food',
  emoji: '🍔',
  transactionType: 'expense',
);

const _utility = ManualEntryCategory(
  id: 'utility',
  name: 'Utility',
  emoji: '🔦',
  transactionType: 'expense',
);

final _entry = FinanceEntry(
  id: 'entry',
  title: 'Lunch',
  description: 'With a friend',
  categoryName: 'Food',
  categoryId: 'food',
  amount: 12000,
  occurredAt: DateTime(2026, 7, 20, 12, 30),
  transactionType: 'expense',
  currencyCode: 'MGA',
  iconKey: 'food',
  emoji: '🍔',
  sourceWalletId: 'cash',
);

const _currency = CurrencyState(
  code: 'MGA',
  baseCode: 'MGA',
  rates: {'MGA': 1},
);

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/reference_wallet_field.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_selection_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'wallet and category use the same surface, slide, height and return',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
          body: Builder(
              builder: (context) => TextButton(
                  onPressed: () => ManualEntrySheet.show(context,
                      categories: Future.value(const [
                        ManualEntryCategory(
                            id: 'food',
                            name: 'Food',
                            emoji: '',
                            iconKey: 'food',
                            transactionType: 'expense')
                      ]),
                      wallets: const [
                        WalletSummary(
                            id: 'cash',
                            name: 'Cash',
                            balance: 100,
                            currencyCode: 'MGA',
                            iconKey: 'cash',
                            isDefault: true)
                      ],
                      targetDate: DateTime(2026, 11, 3)),
                  child: const Text('Open')))),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final surface = find.byKey(const Key('transaction-sheet-surface'));
    PageController pages() =>
        tester.widget<PageView>(find.byType(PageView)).controller!;
    final controller = pages();
    final route =
        ModalRoute.of(tester.element(find.byType(ReferenceWalletField)));
    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    final categoryPage = controller.page!;
    final categoryHeight = tester.getSize(surface).height;
    expect(categoryPage, inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ReferenceWalletField));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    expect(pages(), same(controller));
    expect(controller.page, closeTo(categoryPage, .001));
    expect(tester.getSize(surface).height, closeTo(categoryHeight, .1));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('transaction-sheet-surface')), findsOneWidget);
    final picker = find.byType(WalletSelectionPage);
    expect(ModalRoute.of(tester.element(picker)), same(route));
    final label = tester.widget<WalletSelectionPage>(picker).label;
    expect(
        find.descendant(of: picker, matching: find.text(label)), findsNothing);
    await tester.enterText(find.byKey(const Key('wallet-search')), 'Ca');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('wallet-picker-close')));
    await tester.pumpAndSettle();
    expect(controller.page, 0);
    expect(tester.testTextInput.isVisible, false);
    await tester.tap(find.byType(ReferenceWalletField));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(controller.page, 0);
    expect(find.byType(ManualEntrySheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

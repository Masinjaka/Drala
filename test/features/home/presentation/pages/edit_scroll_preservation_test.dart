import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../ai_entry/support/delayed_edit_repository.dart';
import '../../../notifications/support/fake_finance_notification_repository.dart';

void main() {
  testWidgets('save and refresh preserve activity offset with hidden banner',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final date = DateTime(2026, 10, 22);
    final repository = DelayedEditRepository()
      ..entries = List.generate(
          1,
          (index) => FinanceEntry(
              id: '$index',
              title: 'Income $index',
              categoryId: 'salary',
              categoryName: 'Salary',
              amount: 100,
              occurredAt: date,
              transactionType: 'income',
              currencyCode: 'MGA',
              iconKey: 'income',
              emoji: '💰'))
      ..manualCategories = const [
        ManualEntryCategory(
            id: 'salary',
            name: 'Salary',
            emoji: '💰',
            transactionType: 'income')
      ];
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatHomePage(
          today: date,
          aiEntryRepository: repository,
          notificationRepository: FakeFinanceNotificationRepository(),
          currencyState: const CurrencyState(
              code: 'MGA', baseCode: 'MGA', rates: {'MGA': 1})),
    ));
    await tester.pumpAndSettle();
    final list = find.byKey(const Key('transaction-scroll-view'));
    final scrollable =
        find.descendant(of: list, matching: find.byType(Scrollable)).first;
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(180);
    await tester.pumpAndSettle();
    final before = position.pixels;
    await tester.tap(find.byKey(const Key('operation-0')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Changed income');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pump();
    tester.view.resetViewInsets();
    await tester.pump(const Duration(seconds: 1));
    repository.edit.complete();
    await tester.pumpAndSettle();
    expect(repository.updatedEntryId, '0');
    expect(tester.state<ScrollableState>(scrollable).position.pixels,
        closeTo(before, 1));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(scrollable).position.pixels,
        closeTo(before, 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/home/presentation/widgets/home_scroll_layout.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_panel.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'home_test_window.dart';

Future<void> pumpHomeScrollApp(
  WidgetTester tester, {
  int count = 50,
  bool reduceMotion = false,
  ScrollPhysics physics = const ClampingScrollPhysics(),
}) async {
  usePhoneWindow(tester);
  final today = DateTime(2026, 9, 26);
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(
          size: const Size(400, 800), disableAnimations: reduceMotion),
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(physics: physics),
        child: Scaffold(
          body: HomeScrollLayout(
            header: const SizedBox(key: Key('fixed-header'), height: 44),
            banner: const SizedBox(height: 109, child: Text('Balance')),
            calendarBuilder: (compact, onVisibilityChanged) => HomeWeekPanel(
              onControlsVisibilityChanged: onVisibilityChanged,
              compact: compact,
              today: today,
              selectedDate: today,
              onDateSelected: (_) {},
            ),
            transactions: HomeOperationsList(
              asSliver: true,
              entries: List.generate(
                  count,
                  (index) => FinanceEntry(
                        id: '$index',
                        title: 'Transaction $index',
                        categoryName: 'Food',
                        amount: 10,
                        occurredAt: today,
                        transactionType: 'expense',
                        currencyCode: 'MGA',
                        iconKey: 'food',
                        emoji: '🍔',
                      )),
              isLoading: false,
              isAdding: false,
              onEntryTap: (_) {},
            ),
            composer: const SizedBox(key: Key('fixed-composer'), height: 46),
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

Finder get transactions => find.byKey(const Key('transaction-scroll-view'));

ScrollPosition transactionPosition(WidgetTester tester) => tester
    .state<ScrollableState>(find
        .descendant(of: transactions, matching: find.byType(Scrollable))
        .first)
    .position;

double revealHeight(WidgetTester tester, String key) =>
    tester.getSize(find.byKey(Key(key))).height;

Future<TestGesture> startListGesture(WidgetTester tester) =>
    tester.startGesture(tester.getCenter(transactions));

Future<void> moveList(
  WidgetTester tester,
  TestGesture gesture,
  double dy,
) async {
  final steps = (dy.abs() / 10).ceil();
  for (var index = 0; index < steps; index++) {
    await gesture.moveBy(Offset(0, dy / steps));
    await tester.pump(const Duration(milliseconds: 5));
  }
}

Future<void> finishListGesture(
  WidgetTester tester,
  TestGesture gesture,
) async {
  // Hold before releasing to exercise a drag without adding a fling.
  await tester.pump(const Duration(milliseconds: 300));
  await gesture.up();
  await tester.pumpAndSettle();
  // Let the existing staggered row entrance timers finish after scrolling.
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

Future<void> scrollList(WidgetTester tester, double dy) async {
  final gesture = await startListGesture(tester);
  await moveList(tester, gesture, dy / 2);
  await moveList(tester, gesture, dy / 2);
  await finishListGesture(tester, gesture);
}

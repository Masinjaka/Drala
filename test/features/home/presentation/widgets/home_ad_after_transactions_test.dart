import 'package:budgets/features/home/presentation/widgets/home_scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ad follows the last transaction after another page is added',
      (tester) async {
    final count = ValueNotifier<int>(20);
    addTearDown(count.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: count,
          builder: (context, length, _) => HomeScrollLayout(
            header: const SizedBox(height: 48),
            banner: const SizedBox(height: 100),
            calendarBuilder: (_, __) =>
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
            transactions: SliverList.builder(
              itemCount: length,
              itemBuilder: (_, index) => SizedBox(
                key: ValueKey('transaction-$index'),
                height: 56,
              ),
            ),
            ad: const SizedBox(key: Key('ad-after-transactions'), height: 120),
            composer: const SizedBox(height: 48),
          ),
        ),
      ),
    ));

    await _expectAdAfter(tester, 19);
    count.value = 35;
    await tester.pump();
    await _expectAdAfter(tester, 34);
  });
}

Future<void> _expectAdAfter(WidgetTester tester, int lastIndex) async {
  final ad = find.byKey(const Key('ad-after-transactions'));
  final list = find.descendant(
    of: find.byKey(const Key('transaction-scroll-view')),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(ad, 300, scrollable: list);
  await tester.pumpAndSettle();
  final last = find.byKey(ValueKey('transaction-$lastIndex'));
  expect(last, findsOneWidget);
  expect(tester.getTopLeft(ad).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(last).dy));
}

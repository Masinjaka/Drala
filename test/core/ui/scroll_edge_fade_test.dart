import 'package:budgets/core/ui/scroll_edge_fade.dart';
import 'package:budgets/core/ui/scroll_edge_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder edge(bool top) => find.byWidgetPredicate(
    (widget) => widget is ScrollEdgeGradient && widget.top == top);

Widget app(ScrollController controller,
        {int count = 30, bool reverse = false}) =>
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            child: ScrollEdgeFade(
              child: ListView.builder(
                controller: controller,
                reverse: reverse,
                itemExtent: 60,
                itemCount: count,
                itemBuilder: (_, index) => Text('Item $index'),
              ),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('fades only edges with more content and restores them on return',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(controller));
    await tester.pumpAndSettle();
    expect(edge(true), findsNothing);
    expect(edge(false), findsOneWidget);

    controller.jumpTo(200);
    await tester.pumpAndSettle();
    expect(edge(true), findsOneWidget);
    expect(edge(false), findsOneWidget);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(edge(true), findsOneWidget);
    expect(edge(false), findsNothing);
    expect(find.text('Item 29').hitTestable(), findsOneWidget);

    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(edge(true), findsNothing);
    expect(edge(false), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('short, empty and filtered lists have no unnecessary fades',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(controller));
    await tester.pumpAndSettle();
    expect(edge(false), findsOneWidget);
    for (final count in [2, 0, 30]) {
      await tester.pumpWidget(app(controller, count: count));
      await tester.pumpAndSettle();
      expect(edge(true), findsNothing);
      expect(edge(false), count == 30 ? findsOneWidget : findsNothing);
    }
  });

  testWidgets('fades do not block dragging and handle reversed lists',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(controller, reverse: true));
    await tester.pumpAndSettle();
    expect(edge(true), findsOneWidget);
    expect(edge(false), findsNothing);
    await tester.dragFrom(
        tester.getTopLeft(find.byType(ScrollEdgeFade)) + const Offset(50, 10),
        const Offset(0, 150));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    expect(edge(false), findsOneWidget);
  });
}

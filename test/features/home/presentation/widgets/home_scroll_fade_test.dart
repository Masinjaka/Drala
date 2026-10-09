import 'package:budgets/core/ui/scroll_edge_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets(
      'home fades below the pinned calendar and clears the bottom at end',
      (tester) async {
    final top = find.byWidgetPredicate(
        (widget) => widget is ScrollEdgeGradient && widget.top);
    final bottom = find.byWidgetPredicate(
        (widget) => widget is ScrollEdgeGradient && !widget.top);
    await pumpHomeScrollApp(tester);
    expect(top, findsNothing);
    expect(bottom, findsOneWidget);
    await scrollList(tester, -600);
    expect(top, findsOneWidget);
    expect(tester.getTopLeft(top).dy,
        tester.getBottomLeft(find.byKey(const Key('home-week-panel'))).dy);
    final position = transactionPosition(tester);
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(bottom, findsNothing);
    expect(top, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

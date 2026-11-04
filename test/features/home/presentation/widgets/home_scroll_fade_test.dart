import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets('scrolling lists and pinned calendar have no edge shades',
      (tester) async {
    final shades = find.byWidgetPredicate((widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).gradient is LinearGradient);
    await pumpHomeScrollApp(tester);
    expect(shades, findsNothing);
    await scrollList(tester, -600);
    expect(shades, findsNothing);
    final position = transactionPosition(tester);
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(shades, findsNothing);
    expect(tester.takeException(), isNull);
  });
}

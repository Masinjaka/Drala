import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('bottom navigation exposes only the four primary destinations',
      (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    expect(find.byKey(const Key('drawer-plan-button')), findsNothing);
    expect(find.text('Plan'), findsNothing);
    expect(find.byKey(const ValueKey('home-navigation-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-3')), findsOneWidget);
  });
}

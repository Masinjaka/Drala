import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('home uses the four destination bottom bar', (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    expect(find.byKey(const ValueKey('home-navigation-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-3')), findsOneWidget);
    expect(find.byKey(const Key('home-menu-button')), findsNothing);
    expect(find.byKey(const Key('drawer-panel')), findsNothing);
  });

  testWidgets('tablet home uses the same bottom navigation', (tester) async {
    useTabletWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    expect(find.byKey(const ValueKey('home-navigation-0')), findsOneWidget);
    expect(find.byKey(const Key('persistent-sidebar-layout')), findsNothing);
  });
}

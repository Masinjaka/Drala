import 'package:budgets/core/layout/app_breakpoints.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('menu overlays the dashboard and can be closed', (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    final homePanel = find.byKey(const Key('home-page-panel'));
    final drawerPanel = find.byKey(const Key('drawer-panel'));
    final drawerWidth = AppBreakpoints.mobileDrawerWidth(400);
    expect(tester.getTopLeft(homePanel).dx, 0);
    expect(_translation(tester, drawerPanel), closeTo(-drawerWidth, .01));
    expect(_dimming(tester), 0);

    await tester.tap(find.byKey(const Key('home-menu-button')));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(homePanel).dx, 0);
    expect(_translation(tester, drawerPanel), 0);
    expect(_dimming(tester), closeTo(.59, .005));
    expect(find.text('Envelope'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byKey(const Key('collapse-sidebar-button')));
    await tester.pumpAndSettle();
    expect(_translation(tester, drawerPanel), closeTo(-drawerWidth, .01));
    expect(_dimming(tester), 0);
  });

  testWidgets('edge drag controls the overlay drawer', (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    final homePanel = find.byKey(const Key('home-page-panel'));
    final drawerPanel = find.byKey(const Key('drawer-panel'));
    final dragSurface = find.byKey(const Key('home-drag-surface'));
    final drawerWidth = AppBreakpoints.mobileDrawerWidth(400);
    final start = tester.getTopLeft(dragSurface) + const Offset(8, 120);
    final gesture = await tester.startGesture(start);

    await gesture.moveBy(const Offset(120, 0));
    await tester.pump();

    expect(tester.getTopLeft(homePanel).dx, 0);
    expect(_translation(tester, drawerPanel), closeTo(120 - drawerWidth, 1));
    expect(_dimming(tester), closeTo(.59 * 120 / drawerWidth, .005));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(_translation(tester, drawerPanel), closeTo(-drawerWidth, .01));
  });

  testWidgets('tablet uses a collapsible persistent side panel',
      (tester) async {
    useTabletWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    final sidebar = find.byKey(const Key('persistent-sidebar-container'));
    expect(find.byKey(const Key('persistent-sidebar-layout')), findsOneWidget);
    expect(tester.getSize(sidebar).width, 68);

    await tester.tap(find.byKey(const Key('persistent-sidebar-toggle')));
    await tester.pumpAndSettle();
    expect(tester.getSize(sidebar).width, 320);
    expect(find.text('Wallets'), findsOneWidget);

    await tester.tap(find.byKey(const Key('collapse-sidebar-button')));
    await tester.pumpAndSettle();
    expect(tester.getSize(sidebar).width, 68);
  });
}

double _translation(WidgetTester tester, Finder finder) =>
    tester.widget<Transform>(finder).transform.getTranslation().x;

double _dimming(WidgetTester tester) {
  final color = tester
      .widget<ColoredBox>(find.byKey(const Key('home-dim-overlay')))
      .color;
  return (color.toARGB32() >> 24) / 255;
}

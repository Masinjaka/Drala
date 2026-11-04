import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'selected pill slides across tabs and retargets from its current position',
      (tester) async {
    await _open(tester);
    final highlight =
        find.byKey(const Key('home-navigation-selection-highlight'));
    final before = tester.getRect(highlight);
    final targetLeft = before.left + before.width;
    await tester.tap(find.byKey(const ValueKey('home-navigation-2')));
    await tester.pump();
    expect(tester.getRect(highlight), before);
    await tester.pump(const Duration(milliseconds: 180));
    final middle = tester.getRect(highlight);
    expect(middle.left, inExclusiveRange(before.left, targetLeft));
    await tester.tap(find.byKey(const ValueKey('home-navigation-4')));
    await tester.pump();
    expect(tester.getRect(highlight).left, closeTo(middle.left, .01));
    await tester.pumpAndSettle();
    final target =
        tester.getRect(find.byKey(const ValueKey('home-navigation-4')));
    expect(tester.getRect(highlight).left, closeTo(target.left, .01));
    expect(tester.getRect(highlight).width, closeTo(target.width, .01));
    expect(highlight, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pill follows the layout direction on a narrow screen',
      (tester) async {
    await _open(tester, rtl: true, width: 320);
    final highlight =
        find.byKey(const Key('home-navigation-selection-highlight'));
    final before = tester.getRect(highlight);
    await tester.tap(find.byKey(const ValueKey('home-navigation-4')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(tester.getRect(highlight).left, lessThan(before.left));
    await tester.pumpAndSettle();
    final target =
        tester.getRect(find.byKey(const ValueKey('home-navigation-4')));
    expect(tester.getRect(highlight).left, closeTo(target.left, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion updates the selection without sliding',
      (tester) async {
    await _open(tester, reducedMotion: true);
    await tester.tap(find.byKey(const ValueKey('home-navigation-3')));
    await tester.pump();
    final highlight = tester
        .getRect(find.byKey(const Key('home-navigation-selection-highlight')));
    final target =
        tester.getRect(find.byKey(const ValueKey('home-navigation-3')));
    expect(highlight.left, closeTo(target.left, .01));
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester,
    {bool reducedMotion = false, bool rtl = false, double width = 412}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 917);
  addTearDown(tester.view.reset);
  var selected = 0;
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
        child: child!),
    home: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            bottomNavigationBar: StatefulBuilder(
          builder: (context, setState) => HomeBottomNavigationBar(
              selectedIndex: selected,
              onSelected: (index) => setState(() => selected = index)),
        ))),
  ));
  await tester.pumpAndSettle();
}

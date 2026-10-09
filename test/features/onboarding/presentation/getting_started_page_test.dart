import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('category bubbles expand from Drala into the reference layout',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: const MediaQuery(
        data: MediaQueryData(
          size: Size(412, 917),
          padding: EdgeInsets.only(top: 59, bottom: 34),
        ),
        child: GettingStartedPage(),
      ),
    ));

    final drala = tester.getCenter(find.text('Drala'));
    final firstBubble = find.byType(CategoryBubble).first;
    final start = tester.getCenter(firstBubble);
    final logoOpacity = find.byKey(const Key('drala-logo-opacity'));
    Opacity bubbleOpacity() => tester.widget<Opacity>(
        find.ancestor(of: firstBubble, matching: find.byType(Opacity)));
    expect(tester.widget<Opacity>(logoOpacity).opacity, 0);
    expect(bubbleOpacity().opacity, 0);

    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.widget<Opacity>(logoOpacity).opacity, inExclusiveRange(0, 1));
    expect(bubbleOpacity().opacity, 0);
    await tester.pump(const Duration(milliseconds: 75));
    expect(tester.widget<Opacity>(logoOpacity).opacity, 1);
    expect(bubbleOpacity().opacity, 0);
    await tester.pump(const Duration(milliseconds: 300));
    final middle = tester.getCenter(firstBubble);
    expect(bubbleOpacity().opacity, greaterThan(0));
    await tester.pump(const Duration(milliseconds: 600));
    final end = tester.getCenter(firstBubble);

    expect((middle - drala).distance, greaterThan((start - drala).distance));
    expect((end - drala).distance, greaterThan((middle - drala).distance));
    expect((end - const Offset(193, 221)).distance, lessThan(1));
    expect(find.byType(CategoryBubble), findsNWidgets(18));
    final icons = tester
        .widgetList<CategoryBubble>(find.byType(CategoryBubble))
        .map((bubble) => bubble.emoji)
        .toList();
    expect(icons, hasLength(18));
    expect(icons.toSet(), hasLength(icons.length));
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    await expectLater(find.byType(GettingStartedPage),
        matchesGoldenFile('goldens/getting_started_reference.png'));
  });
}

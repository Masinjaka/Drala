import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:budgets/features/home/presentation/widgets/activities_calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/load_category_icon_font.dart';
import '../../../../support/soft_shadow_test_binding.dart';
import '../../support/activities_fixture.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await loadCategoryIconFont();
    await (FontLoader(AppTheme.fontFamily)
          ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    testWidgets(
        'calendar keeps only its soft card shadow across scroll overlap dark=$dark',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 917);
      addTearDown(tester.view.reset);
      final fixture = ActivitiesFixture();
      addTearDown(fixture.dispose);
      await fixture.load();
      await tester.pumpWidget(fixture.app(dark: dark));
      await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
      await tester.pumpAndSettle();
      final calendar = find.byType(ActivitiesCalendarCard);
      final panel = find.byKey(const Key('home-week-panel'));
      final scrollable = tester.state<ScrollableState>(find
          .descendant(
              of: find.byKey(const Key('transaction-scroll-view')),
              matching: find.byType(Scrollable))
          .first);
      // Cross the collapse/overlap boundary in both directions, including the
      // first frame where the scroll fade begins below the pinned calendar.
      for (final offset in [0.0, 60.0, 65.0, 69.0, 40.0, 0.0, 69.0]) {
        scrollable.position.jumpTo(offset);
        await tester.pump();
        expect(
            find.descendant(
                of: panel,
                matching: find.byWidgetPredicate((widget) =>
                    widget is DecoratedBox &&
                    widget.decoration is BoxDecoration &&
                    (widget.decoration as BoxDecoration).gradient
                        is LinearGradient)),
            findsNothing);
        final decorated = find
            .descendant(
                of: panel,
                matching: find.byWidgetPredicate((widget) =>
                    widget is DecoratedBox &&
                    widget.decoration is ShapeDecoration))
            .first;
        final decoration = tester.widget<DecoratedBox>(decorated).decoration
            as ShapeDecoration;
        expect(
            decoration.shadows, AppCardTheme.shadows(tester.element(calendar)));
        expect(tester.takeException(), isNull);
      }
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(const Key('activities-golden')),
          matchesGoldenFile(
              'goldens/activities-scrolled-${dark ? 'dark' : 'light'}.png'));
    });
  }
}

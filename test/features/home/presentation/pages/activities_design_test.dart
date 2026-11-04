import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/soft_shadow_test_binding.dart';
import '../../../../support/load_category_icon_font.dart';
import '../../support/activities_fixture.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await loadCategoryIconFont();
    await (FontLoader('Alexandria')
          ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    testWidgets('activities matches the reference layout dark=$dark',
        (tester) async {
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 24);
      tester.view.viewPadding = const FakeViewPadding(top: 24);
      addTearDown(tester.view.reset);
      final fixture = ActivitiesFixture();
      addTearDown(fixture.dispose);
      await fixture.load();
      await tester.pumpWidget(fixture.app(dark: dark));
      await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(const Key('home-week-panel'))).dy,
          closeTo(98, 2));
      final composer =
          tester.getRect(find.byKey(const Key('chat-input-container')));
      final navigation =
          tester.getRect(find.byKey(const Key('home-navigation-surface')));
      expect(navigation.contains(composer.topLeft), isTrue);
      expect(composer.height, 46);
      expect(tester.takeException(), isNull);
      await expectLater(
          find.byKey(const Key('activities-golden')),
          matchesGoldenFile(
              'goldens/activities-${dark ? 'dark' : 'light'}.png'));
    });
  }
}

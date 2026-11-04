import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/soft_shadow_test_binding.dart';
import '../../support/empty_home_fixture.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await (FontLoader(AppTheme.fontFamily)
          ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf')))
        .load();
    await (FontLoader(AppTypography.amountFontFamily)
          ..addFont(rootBundle.load('assets/fonts/Inter.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    testWidgets('empty Home illustration and actions dark=$dark',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 917);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(emptyHomeFixture(dark: dark));
      await tester.pumpAndSettle();
      final context =
          tester.element(find.byKey(const Key('empty-home-golden')));
      final providers = tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => image.image)
          .toList();
      await tester.runAsync(() => Future.wait(
          providers.map((provider) => precacheImage(provider, context))));
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(const Key('empty-home-golden')),
          matchesGoldenFile(
              'goldens/home-empty-${dark ? 'dark' : 'light'}.png'));
      expect(tester.takeException(), isNull);
    });
  }
}

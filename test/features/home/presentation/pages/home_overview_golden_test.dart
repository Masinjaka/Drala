import '../../../../support/soft_shadow_test_binding.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/load_app_fonts.dart';
import '../../support/overview_fixture.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('packages/ionicons/Ionicons')
          ..addFont(
              rootBundle.load('packages/ionicons/assets/fonts/Ionicons.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    testWidgets('home overview reference dark=$dark', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 917);
      addTearDown(tester.view.reset);
      final visibility = AmountVisibilityController();
      addTearDown(visibility.dispose);
      await tester
          .pumpWidget(overviewFixture(dark: dark, visibility: visibility));
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(const Key('overview-golden')),
          matchesGoldenFile(
              'goldens/home-overview-${dark ? 'dark' : 'light'}.png'));
    });
  }
}

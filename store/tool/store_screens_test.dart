// ignore_for_file: invalid_use_of_visible_for_testing_member
// Host render of the store captures (fast preview, not for Google Play).
// Run: fvm flutter test store/tool/store_screens_test.dart
import 'dart:io';

import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test/support/load_app_fonts.dart';
import '../../test/support/soft_shadow_test_binding.dart';
import 'store_capture_flow.dart';
import 'store_feature_flow.dart';

final _out = Platform.environment['STORE_RAW_DIR'] ?? 'build/store_raw';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
        url: 'https://demo.invalid',
        anonKey: 'demo',
        authOptions:
            const FlutterAuthClientOptions(localStorage: EmptyLocalStorage()));
    await loadAppFonts();
    for (final (family, path) in [
      (
        'packages/ionicons/Ionicons',
        'packages/ionicons/assets/fonts/Ionicons.ttf'
      ),
      ('MaterialIcons', 'fonts/MaterialIcons-Regular.otf'),
    ]) {
      await (FontLoader(family)..addFont(rootBundle.load(path))).load();
    }
  });

  Future<StoreCaptureFlow> flow(WidgetTester tester) async {
    tester.view.devicePixelRatio = 2.625;
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.padding = const FakeViewPadding(top: 63, bottom: 42);
    tester.view.viewPadding = const FakeViewPadding(top: 63, bottom: 42);
    addTearDown(tester.view.reset);
    await Directory(_out).create(recursive: true);
    return StoreCaptureFlow(
        tester, (name, png) => File('$_out/$name.png').writeAsBytes(png),
        pixelRatio: 2.625);
  }

  AmountVisibilityController visibility() {
    final v = AmountVisibilityController();
    addTearDown(v.dispose);
    return v;
  }

  testWidgets(
      'guest screens', (t) async => (await flow(t)).guestScreens(visibility()));
  testWidgets(
      'dark screens', (t) async => (await flow(t)).darkScreens(visibility()));
  testWidgets(
      'AI entry screens', (t) async => (await flow(t)).aiScreens(visibility()));
  testWidgets('feature screens',
      (t) async => (await flow(t)).featureScreens(visibility()));
  testWidgets(
      'currency home', (t) async => (await flow(t)).currencyHome(visibility()));
}

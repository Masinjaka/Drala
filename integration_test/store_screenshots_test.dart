// ignore_for_file: invalid_use_of_visible_for_testing_member
// Captures the store screens from the app running on an Android device or
// emulator (the pixels used for Google Play). Run: fvm flutter test integration_test/store_screenshots_test.dart -d <device>
import 'dart:convert';

import 'package:budgets/core/ui/amount_visibility_controller.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../store/tool/store_capture_flow.dart';
import '../store/tool/store_feature_flow.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
        url: 'https://demo.invalid',
        anonKey: 'demo',
        authOptions:
            const FlutterAuthClientOptions(localStorage: EmptyLocalStorage()));
  });

  Future<StoreCaptureFlow> flow(WidgetTester tester) async {
    final view = tester.view;
    return StoreCaptureFlow(tester, (name, png) async {
      // The test run uninstalls the app, so stream the PNG to the host log.
      final data = base64Encode(png);
      for (var i = 0; i < data.length; i += 2000) {
        final end = i + 2000 < data.length ? i + 2000 : data.length;
        // ignore: avoid_print
        print('STOREPNG $name ${data.substring(i, end)}');
      }
    }, pixelRatio: view.devicePixelRatio);
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

import 'dart:math' as math;

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ads/data/admob_configuration.dart';
import 'package:budgets/features/ads/presentation/widgets/home_native_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads a Google native test ad into the home slot',
      (tester) async {
    expect(AdMobConfiguration.nativeUnitId, isNotNull);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: const Scaffold(body: HomeNativeAd()),
    ));

    final area = find.byKey(const Key('home-native-ad-area'));
    for (var second = 0; second < 45 && area.evaluate().isEmpty; second++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(seconds: 1)),
      );
      await tester.pump();
    }
    expect(area, findsOneWidget);
    final adSize = tester.getSize(find.byType(AdWidget));
    expect(
        adSize.height, closeTo(math.max(320, adSize.width * 9 / 16 + 135), 1));
    expect(adSize.width * 9 / 16, greaterThanOrEqualTo(120));
  });
}

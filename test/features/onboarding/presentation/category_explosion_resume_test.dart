import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_explosion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('big bang restarts when its route becomes active again',
      (tester) async {
    final routeIsActive = ValueNotifier(true);
    addTearDown(routeIsActive.dispose);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: ValueListenableBuilder<bool>(
        valueListenable: routeIsActive,
        builder: (_, active, child) => TickerMode(
          enabled: active,
          child: child!,
        ),
        child: const CategoryExplosion(),
      ),
    ));
    await tester.pumpAndSettle();

    Opacity logo() => tester.widget<Opacity>(
          find.byKey(const Key('drala-logo-opacity')),
        );
    expect(logo().opacity, 1);

    routeIsActive.value = false;
    await tester.pump();
    routeIsActive.value = true;
    await tester.pump();
    expect(logo().opacity, 0);

    await tester.pump(const Duration(milliseconds: 200));
    expect(logo().opacity, inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(logo().opacity, 1);
  });
}

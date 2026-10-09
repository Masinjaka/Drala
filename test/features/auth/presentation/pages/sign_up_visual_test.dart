import 'package:budgets/core/theme.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/auth/presentation/widgets/legal_consent_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/load_app_fonts.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });

  testWidgets('sign-up layout retains legal consent at the reference size',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(412, 917),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: RepaintBoundary(
            key: Key('screen'),
            child: SignUpPage(),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byType(LegalConsentCheckbox), findsOneWidget);
    await expectLater(find.byKey(const Key('screen')),
        matchesGoldenFile('goldens/sign_up_reference.png'));
  });
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/auth/presentation/pages/verify_reset_code_page.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:budgets/features/auth/presentation/widgets/reset_code_otp_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/load_app_fonts.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });

  testWidgets('reset code and password use the login visual style',
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
            child: VerifyResetCodePage(email: 'example@mail.com'),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.byType(AuthTextField), findsNWidgets(2));
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byType(ResetCodeOtpRow), findsOneWidget);
    expect(find.text('example@mail.com'), findsOneWidget);
    await expectLater(find.byKey(const Key('screen')),
        matchesGoldenFile('goldens/verify_reset_code_reference.png'));
  });
}

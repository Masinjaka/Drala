import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/auth/presentation/pages/reset_password_page.dart';
import 'package:budgets/features/auth/presentation/pages/verify_reset_code_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cases = <(String, Widget, String, List<String>)>[
    (
      'login',
      const LoginPage(),
      'Login',
      ['Enter an email address', 'Enter a password']
    ),
    (
      'forgot password',
      const ResetPasswordPage(),
      'Send',
      ['Enter an email address']
    ),
    (
      'reset password',
      const VerifyResetCodePage(email: 'test@example.com'),
      'Reset password',
      ['Enter the 6-digit code', 'Enter a password']
    ),
    (
      'sign up',
      const SignUpPage(),
      'Continue',
      ['Enter an email address', 'Enter a password']
    ),
  ];
  for (final item in cases) {
    testWidgets('${item.$1} shows inline errors without a toast or submission',
        (tester) async {
      tester.view.physicalSize = const Size(412, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: item.$2,
      )));
      await tester.pumpAndSettle();
      if (item.$1 == 'sign up') {
        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      }
      final button = item.$1 == 'sign up'
          ? find.byKey(const Key('sign-up-submit'))
          : find.text(item.$3).last;
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      for (final message in item.$4) {
        expect(find.textContaining(message), findsWidgets);
      }
      expect(find.byType(AppToastOverlay), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

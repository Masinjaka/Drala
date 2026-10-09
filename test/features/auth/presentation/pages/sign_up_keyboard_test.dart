import 'package:budgets/core/theme.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'small-phone keyboard still allows confirmation and legal consent',
      (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(ProviderScope(
        child:
            MaterialApp(theme: AppTheme.lightTheme, home: const SignUpPage())));
    final password = find.byType(TextFormField).at(2);
    await tester.ensureVisible(password);
    await tester.tap(password);
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    await tester.enterText(password, 'Abcdef1!');
    await tester.pumpAndSettle();
    final confirmation = find.byKey(const Key('confirm-password-field'));
    await tester.ensureVisible(confirmation);
    await tester.enterText(
        find.descendant(of: confirmation, matching: find.byType(TextFormField)),
        'Abcdef1!');
    await tester.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    final consent = find.byKey(const Key('legal-consent-checkbox'));
    await tester.ensureVisible(consent);
    await tester.tap(consent);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(consent).value, isTrue);
    expect(tester.takeException(), isNull);
    expect(
      tester
          .widget<FilledButton>(find.descendant(
            of: find.byKey(const Key('sign-up-submit')),
            matching: find.byType(FilledButton),
          ))
          .onPressed,
      isNotNull,
    );
  });
}

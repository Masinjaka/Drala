import 'dart:async';

import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signed-out users can log in but cannot open home',
      (tester) async {
    final authChanges = StreamController<Object?>.broadcast();
    final navigation = AppNavigation(
      isSignedIn: () => false,
      authChanges: authChanges.stream,
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: navigation.router,
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(GettingStartedPage), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(GettingStartedPage), findsOneWidget);

    navigation.router.go('/getting-started');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(GettingStartedPage), findsOneWidget);

    navigation.router.go('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(GettingStartedPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    navigation.dispose();
    await authChanges.close();
  });
}

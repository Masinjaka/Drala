import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_choice.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_progress_dots.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_onboarding_repository.dart';

void main() {
  setUp(
      () => SharedPreferences.setMockInitialValues({'selected_locale': 'en'}));

  testWidgets('Continue and Back move between setup pages', (tester) async {
    final router = _router();
    await tester.pumpWidget(_app(router, FakeOnboardingRepository()));
    router.push('/onboarding');
    await tester.pumpAndSettle();

    expect(find.text('Your language'), findsOneWidget);
    expect(tester.widget<Text>(find.text('Your language')).textAlign,
        TextAlign.center);
    expect(
      tester
          .widget<Text>(find.text(
              'Select your prefered language. You can always change it later in the settings.'))
          .textAlign,
      TextAlign.center,
    );
    final dotsTop = tester.getTopLeft(find.byType(SetupProgressDots)).dy;
    expect(tester.getSize(find.byKey(const Key('setup-progress-2'))).width, 24);
    expect(find.widgetWithText(SetupChoice, 'English'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(find.text('Sign up'), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Your language'), findsOneWidget);
    expect(find.text('Sign up'), findsNothing);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final page = tester.widget<PageView>(find.byType(PageView));
    expect(page.controller!.page, greaterThan(0));
    expect(page.controller!.page, lessThan(1));
    expect(find.widgetWithText(SetupChoice, 'Euro'), findsNothing);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.widgetWithText(SetupChoice, 'Euro'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Your currency'), findsOneWidget);
    expect(tester.widget<Text>(find.text('Your currency')).textAlign,
        TextAlign.center);
    expect(tester.getTopLeft(find.byType(SetupProgressDots)).dy, dotsTop);
    expect(tester.getSize(find.byKey(const Key('setup-progress-3'))).width, 24);
    expect(tester.getSize(find.byKey(const Key('setup-progress-2'))).width, 8);
    expect(find.widgetWithText(SetupChoice, 'Euro'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Your language'), findsOneWidget);
    expect(find.text('Sign up'), findsNothing);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your currency'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Your language'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    router.dispose();
  });

  testWidgets('completion screen disables Back', (tester) async {
    final router = _router();
    final repo = FakeOnboardingRepository()..draft = {'step': 6};
    await tester.pumpWidget(_app(router, repo));
    router.push('/onboarding');
    await tester.pumpAndSettle();

    expect(find.text('You’re all set !'), findsOneWidget);
    expect(tester.getSize(find.byKey(const Key('setup-progress-6'))).width, 24);
    expect(_backButton(tester).onPressed, isNull);
    expect(find.text('Sign up'), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('You’re all set !'), findsOneWidget);
    expect(find.text('Sign up'), findsNothing);
    router.dispose();
  });
}

CustomButton _backButton(WidgetTester tester) => tester.widget<CustomButton>(
      find.widgetWithIcon(CustomButton, Icons.arrow_back_rounded),
    );

GoRouter _router() => GoRouter(initialLocation: '/signup', routes: [
      GoRoute(
        path: '/signup',
        builder: (_, __) => const Scaffold(body: Text('Sign up')),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const AccountSetupPage(),
      ),
    ]);

Widget _app(GoRouter router, FakeOnboardingRepository repo) => ProviderScope(
      overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );

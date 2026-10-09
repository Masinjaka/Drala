import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/scroll_edge_fade.dart';
import 'package:budgets/core/ui/scroll_edge_gradient.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_choice.dart';
import 'package:budgets/features/settings/presentation/widgets/currency_search_field.dart';
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
  testWidgets('completes ordered setup with chosen presets and wallets',
      (tester) async {
    final repo = FakeOnboardingRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    expect(find.text('Your language'), findsOneWidget);
    expect(find.byType(CustomButton), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your currency'), findsOneWidget);
    expect(find.byType(CurrencySearchField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'EUR');
    await tester.pump();
    await tester.tap(find.text('Euro'));
    expect(find.text('€'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your categories'), findsOneWidget);
    await tester.tap(find.text('Food & drinks'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your wallets'), findsOneWidget);
    await tester.tap(find.text('Cash'));
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(repo.draft['categories'], isNot(contains('food')));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(repo.completed?['currency'], 'EUR');
    expect(repo.completed?['categories'], isNot(contains('food')));
    expect(repo.completed?['wallets'], isNot(contains('cash')));
    expect(find.text('You’re all set !'), findsOneWidget);
    await tester.tap(find.text('Nice'));
    await tester.pumpAndSettle();
    expect(find.text('Home destination'), findsOneWidget);
  });
  testWidgets('resumes draft and keeps step after a failed save',
      (tester) async {
    final repo = FakeOnboardingRepository()
      ..draft = {'step': 3, 'currency': 'EUR'}
      ..failSave = true;
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    expect(find.text('Your currency'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your currency'), findsOneWidget);
    repo.failSave = false;
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your categories'), findsOneWidget);
  });
  testWidgets('currency step uses settings search and selection behavior',
      (tester) async {
    final repo = FakeOnboardingRepository()
      ..draft = {'step': 3, 'currency': 'MGA'};
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    expect(find.text('Ariary'), findsOneWidget);
    expect(find.text('MGA'), findsOneWidget);
    expect(tester.getRect(find.text('Ariary')).bottom, lessThan(667));
    expect(find.byType(ScrollEdgeFade), findsOneWidget);
    expect(_edge(top: false), findsOneWidget);

    await tester.drag(find.byType(ScrollEdgeFade), const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(_edge(top: true), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'EUR');
    await tester.pump();
    final euro = find.widgetWithText(SetupChoice, 'Euro');
    expect(euro, findsOneWidget);
    expect(find.widgetWithText(SetupChoice, 'US Dollar'), findsNothing);

    await tester.tap(find.text('Euro'));
    await tester.pump();
    expect(tester.widget<SetupChoice>(euro).selected, isTrue);

    await tester.enterText(find.byType(TextField), 'CAD');
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SetupChoice && widget.title == 'Canadian Dollar',
      ),
      findsOneWidget,
    );
    expect(find.text(r'$'), findsOneWidget);
  });
  testWidgets('failed completion retains choices and can retry',
      (tester) async {
    final repo = FakeOnboardingRepository()
      ..draft = {
        'step': 5,
        'currency': 'USD',
        'categories': ['salary'],
        'wallets': ['bank']
      }
      ..failComplete = true;
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your wallets'), findsOneWidget);
    repo.failComplete = false;
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(repo.completed?['wallets'], ['bank']);
    expect(find.text('You’re all set !'), findsOneWidget);
  });
  testWidgets('small phone with large text keeps action reachable',
      (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app(FakeOnboardingRepository(), scale: 1.6));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getBottomRight(find.text('Continue')).dy, lessThan(667));
  });
}

Finder _edge({required bool top}) => find.byWidgetPredicate(
      (widget) => widget is ScrollEdgeGradient && widget.top == top,
    );

Widget _app(FakeOnboardingRepository repo, {double scale = 1}) {
  final router = GoRouter(initialLocation: '/onboarding', routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const AccountSetupPage()),
    GoRoute(
        path: '/home',
        builder: (_, __) => const Scaffold(body: Text('Home destination'))),
  ]);
  return ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(repo),
        exchangeRatesProvider.overrideWith((ref) async => null),
      ],
      child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!)));
}

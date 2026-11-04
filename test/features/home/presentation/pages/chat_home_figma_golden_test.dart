import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'home shows the five navigation destinations with an active Home label',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    tester.view.padding = const FakeViewPadding(top: 24);
    tester.view.viewPadding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatHomePage(today: DateTime(2026, 7, 18)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-navigation-4')), findsOneWidget);
    expect(find.byKey(const Key('home-menu-button')), findsNothing);
  });
}

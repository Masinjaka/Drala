import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma home and drawer frames', (tester) async {
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

    expect(
      tester.getRect(find.byKey(const Key('home-balance-card'))),
      const Rect.fromLTWH(30, 100, 354, 110),
    );
    final label = tester.getRect(find.byKey(const Key('home-balance-label')));
    final eye = tester.getRect(find.byKey(const Key('home-balance-eye')));
    expect(label.topLeft, const Offset(54, 120));
    expect(eye.left, greaterThan(label.right));
    expect(
      tester.getTopLeft(find.byKey(const Key('home-balance-amount'))).dx,
      54,
    );
    _expectBottom(tester, 'home-balance-currency', 190);
    final currency =
        tester.getRect(find.byKey(const Key('home-balance-currency')));
    final month =
        tester.getRect(find.byKey(const Key('home-balance-month-label')));
    expect(month.left, currency.right + 20);
    _expectBottom(tester, 'home-balance-amount', 190);
    _expectBottom(tester, 'home-balance-income', 190);
    _expectBottom(tester, 'home-balance-expenses', 190);
    expect(
      tester.getTopLeft(find.byKey(const Key('home-balance-income'))).dx,
      month.left,
    );
    _expectRect(
      tester,
      'home-balance-eye',
      const Rect.fromLTWH(339, 120, 23, 16),
    );

    expect(
      tester.getRect(
        find
            .descendant(
              of: find.byKey(const Key('chat-input-container')),
              matching: find.byType(DecoratedBox),
            )
            .first,
      ),
      const Rect.fromLTWH(29, 826, 354, 56),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/chat_home_figma.png'),
    );

    await tester.tap(find.byKey(const Key('home-menu-button')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/chat_drawer_figma.png'),
    );
  });
}

void _expectRect(WidgetTester tester, String key, Rect expected) {
  expect(tester.getRect(find.byKey(Key(key))), expected);
}

void _expectBottom(WidgetTester tester, String key, double expected) {
  expect(
    tester.getBottomLeft(find.byKey(Key(key))).dy,
    closeTo(expected, 0.01),
  );
}

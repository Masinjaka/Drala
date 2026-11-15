import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/home_test_window.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'settings scrolls beneath fixed header and nav in ${theme.brightness}',
        (tester) async {
      usePhoneWindow(tester);
      await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
              theme: theme, home: ChatHomePage(today: DateTime(2026, 11, 4)))));
      await tester.tap(find.byKey(const Key('home-navigation-4')));
      await tester.pumpAndSettle();
      final header = tester.getRect(find.text('Settings'));
      final before = tester.getTopLeft(find.text('Edit profile')).dy;
      final list = find.byKey(const Key('settings-content'));
      await tester.drag(list, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Edit profile')).dy, lessThan(before));
      expect(tester.getRect(find.text('Settings')), header);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

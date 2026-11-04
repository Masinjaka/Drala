import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/pages/setting_page.dart';
import 'package:budgets/features/settings/presentation/pages/edit_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('settings opens as a root bottom-navigation destination',
      (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChatHomePage(today: DateTime(2026, 7, 16)),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('home-navigation-4')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SettingPage), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);
    expect(
      tester.widget<Text>(find.text('Settings')).style?.fontSize,
      AppSettingsTheme.pageTitle(
        tester.element(find.text('Settings')),
      ).fontSize,
    );
    expect(
      tester.widget<Text>(find.text('Edit profile')).style?.fontSize,
      AppSettingsTheme.menuLabel(
        tester.element(find.text('Edit profile')),
      ).fontSize,
    );

    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();
    expect(find.byType(EditPasswordPage), findsOneWidget);
    await tester.tap(find.byKey(const Key('detail-page-close')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingPage), findsOneWidget);
    expect(find.byType(ChatHomePage), findsOneWidget);
  });
}

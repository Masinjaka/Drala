import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/pages/settings_with_back_page.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_editor_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('settings opens the redesigned page and back returns home',
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

    await tester.tap(find.byKey(const Key('home-menu-button')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    final settingsButton = find.byKey(const Key('drawer-settings-button'));
    await tester.tap(settingsButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SettingsWithBackPage), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Settings')).style?.fontSize,
      AppTheme.lightTheme.textTheme.titleLarge?.fontSize,
    );
    expect(
      tester.widget<Text>(find.text('Edit profile')).style?.fontSize,
      AppTheme.lightTheme.textTheme.bodySmall?.fontSize,
    );

    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsEditorSheet), findsOneWidget);
    expect(find.byType(TransactionSheetSurface), findsOneWidget);
    await tester.tap(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsWithBackPage), findsNothing);
    expect(find.byType(ChatHomePage), findsOneWidget);
  });
}

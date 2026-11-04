import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses shared compact controls and theme typography',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SettingsPageShell(
          title: 'Settings',
          child: SizedBox(),
        ),
      ),
    );

    expect(find.byType(DetailPageHeader), findsOneWidget);
    expect(find.byType(AppCloseButton), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(tester.getCenter(find.byType(AppCloseButton)).dx,
        greaterThan(tester.getCenter(find.text('Settings')).dx));
    final title = tester.widget<Text>(find.text('Settings'));
    expect(title.style?.fontFamily, AppTheme.fontFamily);
    expect(
        title.style?.fontSize,
        AppFinanceSurfaceTheme.title(tester.element(find.text('Settings')))
            .fontSize);
  });
}

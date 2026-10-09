import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
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
    final button =
        tester.widget<OutlinedSquareButton>(find.byType(OutlinedSquareButton));
    expect(button.visualSize, 34);
    expect(button.iconSize, 22);
    final title = tester.widget<Text>(find.text('Settings'));
    expect(title.style?.fontFamily, AppTheme.fontFamily);
    expect(title.style?.fontSize,
        AppTheme.lightTheme.textTheme.titleLarge?.fontSize);
  });
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'drawer menu labels use regular themed text in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: HomeDrawer(
              width: 320,
              onEnvelopePressed: () {},
              onStatsPressed: () {},
              onWalletsPressed: () {},
              onCategoriesPressed: () {},
              onSettingsPressed: () async {},
              onCollapsePressed: () {},
            ),
          ),
        ),
      );

      for (final label in [
        'Envelope',
        'Stats',
        'Wallets',
        'Categories',
        'Settings',
      ]) {
        final text = tester.widget<Text>(find.text(label));
        expect(text.style?.fontWeight, FontWeight.w400);
        expect(text.style?.fontSize, theme.textTheme.bodyMedium?.fontSize);
        expect(text.style?.color, theme.textTheme.bodyMedium?.color);
      }
    });
  }
}

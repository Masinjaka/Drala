import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_choice_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'selected Settings check has visible contrast in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Scaffold(
              body: SettingsChoiceTile(
                  title: 'Theme',
                  leading: const Icon(Icons.palette),
                  selected: true,
                  showSelectionIndicator: true,
                  onTap: () {}))));
      final check = find.byIcon(Icons.check_rounded);
      final foreground = tester.widget<Icon>(check).color!;
      final badge = tester.widget<DecoratedBox>(
          find.ancestor(of: check, matching: find.byType(DecoratedBox)).first);
      final background = (badge.decoration as BoxDecoration).color!;
      final a = foreground.computeLuminance();
      final b = background.computeLuminance();
      final contrast = a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
  }

  testWidgets('aligns a custom subtitle directly below its title',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsChoiceTile(
            title: 'Cash',
            leading: const Text('👛'),
            subtitleWidget: const Text(
              '400 000 MGA',
              key: Key('wallet-balance'),
            ),
            onTap: () {},
          ),
        ),
      ),
    );

    final titleBounds = tester.getRect(find.text('Cash'));
    final balanceBounds = tester.getRect(
      find.byKey(const Key('wallet-balance')),
    );

    expect(balanceBounds.left, titleBounds.left);
    expect(balanceBounds.top, greaterThan(titleBounds.bottom));
  });
}

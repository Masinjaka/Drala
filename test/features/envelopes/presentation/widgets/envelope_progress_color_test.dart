import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Envelope _envelope({String color = 'FF3864FF', int overspent = 0}) =>
    Envelope(
      id: 'transport',
      name: 'Transport',
      categoryId: 'category',
      categoryName: 'Transport',
      emoji: '🚗',
      color: color,
      amount: 100000,
      spent: overspent > 0 ? 100000 + overspent : 40000,
      currencyCode: 'MGA',
      overspentAmount: overspent,
    );

void main() {
  Future<void> pump(WidgetTester tester, Envelope envelope,
          {ThemeData? theme}) =>
      tester.pumpWidget(MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        home: Scaffold(
          body: EnvelopeCard(envelope: envelope, onDelete: () {}),
        ),
      ));

  Color barColor(WidgetTester tester) => tester
      .widget<EnvelopeProgress>(find.byType(EnvelopeProgress))
      .foregroundColor;

  for (final (name, theme) in [
    ('light', AppTheme.lightTheme),
    ('dark', AppTheme.darkTheme),
  ]) {
    testWidgets('bar matches the category icon color ($name)', (tester) async {
      await pump(tester, _envelope(), theme: theme);
      final context = tester.element(find.byType(EnvelopeProgress));
      final icon = tester.widget<Icon>(find.descendant(
          of: find.byType(CategoryIcon), matching: find.byType(Icon)));

      expect(barColor(tester), icon.color);
      expect(
          barColor(tester),
          AppCategoryIconTheme.color(context, 'FF3864FF',
              background: AppEnvelopeTheme.surface(context)));
    });
  }

  testWidgets('each category gets its own bar color', (tester) async {
    await pump(tester, _envelope(color: 'FFE52D68'));
    final pink = barColor(tester);
    await pump(tester, _envelope(color: 'FF10B981'));
    expect(barColor(tester), isNot(pink));
  });

  testWidgets('overspent envelopes keep the warning color', (tester) async {
    await pump(tester, _envelope(overspent: 5000));
    final context = tester.element(find.byType(EnvelopeProgress));
    expect(barColor(tester), AppDangerTheme.criticalWarning(context));
  });

  testWidgets('falls back to the accent color for an invalid category color',
      (tester) async {
    await pump(tester, _envelope(color: 'not-a-color'));
    final context = tester.element(find.byType(EnvelopeProgress));
    // The accent gets the same readability toning as category colors.
    expect(
        barColor(tester),
        AppCategoryIconTheme.color(context, null,
            background: AppEnvelopeTheme.surface(context),
            fallback: AppEnvelopeTheme.accent(context)));
  });
}

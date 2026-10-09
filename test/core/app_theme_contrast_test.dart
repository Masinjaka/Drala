import 'package:budgets/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dark graphite base sits between near-black and the home banner', () {
    final colors = AppTheme.darkTheme.colorScheme;
    final base = AppTheme.darkTheme.scaffoldBackgroundColor.computeLuminance();
    expect(base, greaterThan(const Color(0xFF08090A).computeLuminance()));
    expect(base, lessThan(AppTheme.homeBanner.computeLuminance()));
    expect(colors.surface.computeLuminance(), greaterThan(base));
    expect(colors.surfaceContainerLowest.computeLuminance(),
        greaterThan(colors.surface.computeLuminance()));
    expect(colors.surface, isNot(colors.surfaceDim));
    expect(colors.surfaceContainerLowest, isNot(colors.surface));
    expect(_contrast(colors.onSurface, colors.surfaceContainerLowest),
        greaterThan(4.5));
    expect(_contrast(colors.surfaceBright, colors.surface), greaterThan(1.5));
    expect(
        _contrast(colors.surfaceContainerHigh, colors.surface), greaterThan(2));
  });

  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    test('text and status colors remain legible in ${theme.brightness}', () {
      final colors = theme.colorScheme;
      expect(_contrast(colors.onSurface, colors.surface), greaterThan(4.5));
      expect(
          _contrast(colors.onSurfaceVariant, colors.surface), greaterThan(4.5));
      expect(_contrast(colors.error, colors.surface), greaterThan(4.5));
      expect(_contrast(colors.onError, colors.error), greaterThan(4.5));
      expect(
          _contrast(theme.iconTheme.color!, colors.surface), greaterThan(4.5));
    });
  }
}

double _contrast(Color foreground, Color background) {
  final first = foreground.computeLuminance();
  final second = background.computeLuminance();
  return (first > second ? first + 0.05 : second + 0.05) /
      (first > second ? second + 0.05 : first + 0.05);
}

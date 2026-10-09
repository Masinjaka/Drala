import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('transaction skeleton is visible in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: const Scaffold(body: HomeOperationSkeleton()),
      ));

      final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
      final colors = (shimmer.gradient as LinearGradient).colors;
      expect(colors.first, theme.colorScheme.surfaceBright);
      expect(colors[2], theme.colorScheme.surfaceContainerHigh);
      expect(colors.first.a, 1);
      expect(colors[2].a, 1);
      expect(_contrast(colors.first, theme.scaffoldBackgroundColor),
          greaterThan(1.2));
    });
  }
}

double _contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (a > b ? a + .05 : b + .05) / (a > b ? b + .05 : a + .05);
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_row.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('home transaction text and badges use dark theme contrast',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Column(children: [
          HomeOperationRow(
            entry: FinanceEntry(
              id: 'coffee',
              title: 'Coffee',
              categoryName: 'Food',
              amount: 5000,
              occurredAt: DateTime(2026, 10, 2),
              transactionType: 'expense',
              currencyCode: 'MGA',
              iconKey: 'food',
              emoji: '☕',
            ),
            currencyState: null,
            onTap: () {},
          ),
          const HomeOperationSkeleton(),
        ]),
      ),
    ));

    expect(tester.widget<Text>(find.text('Coffee')).style?.color,
        AppTheme.darkTheme.colorScheme.onSurface);
    expect(tester.widget<Text>(find.text('Food')).style?.color,
        AppTheme.darkTheme.colorScheme.onSurfaceVariant);
    final badge = tester.widget<Container>(find
        .ancestor(
          of: find.text('-5 000 MGA'),
          matching: find.byType(Container),
        )
        .first);
    expect(
        (badge.decoration as BoxDecoration).color, AppTheme.expenseBadgeDark);
    expect(find.byType(HomeOperationSkeleton), findsOneWidget);
    final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    final gradient = shimmer.gradient as LinearGradient;
    expect(gradient.colors.first, AppTheme.darkTheme.colorScheme.surfaceBright);
    expect(gradient.colors[2],
        AppTheme.darkTheme.colorScheme.surfaceContainerHigh);
  });
}

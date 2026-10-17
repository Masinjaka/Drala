import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/home/presentation/widgets/activity_empty_state.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows three skeleton rows while operations load',
      (tester) async {
    await tester.pumpWidget(_app(isLoading: true));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(HomeOperationSkeleton), findsNWidgets(3));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows a pending row while adding a transaction', (tester) async {
    await tester.pumpWidget(_app(isAdding: true));
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.byKey(const Key('pending-operation-skeleton')),
      findsOneWidget,
    );
  });

  testWidgets('shows the daily empty state once loading finishes',
      (tester) async {
    await tester.pumpWidget(_app());

    expect(find.byType(ActivityEmptyState), findsOneWidget);
    expect(find.text('No activity on this day'), findsOneWidget);
    expect(find.byType(HomeOperationSkeleton), findsNothing);
  });
}

Widget _app({bool isLoading = false, bool isAdding = false}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: HomeOperationsList(
        entries: const [],
        isLoading: isLoading,
        isAdding: isAdding,
        onEntryTap: (_) {},
      ),
    ),
  );
}

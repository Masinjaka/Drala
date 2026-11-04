import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/planning/presentation/widgets/add_budget_bottom_sheet.dart';
import 'package:budgets/features/planning/presentation/widgets/add_goal_bottom_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../features/categories/support/recording_categories.dart';
import 'support/form_currency_controller.dart';

void main() {
  testWidgets('budget reports missing amount and category inline',
      (tester) async {
    await _pump(tester, const AddBudgetBottomSheet());
    await tester.ensureVisible(find.text('Ajouter'));
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
    expect(find.text('This field is required.'), findsOneWidget);
    expect(find.byType(AppToastOverlay), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('goal reports missing name below the field on Next',
      (tester) async {
    await _pump(tester, const AddGoalBottomSheet());
    await tester.ensureVisible(find.text('Suivant'));
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Veuillez renseigner le nom'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Trip');
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ajouter'));
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
    expect(find.text('This field is required.'), findsOneWidget);
    expect(find.byType(AppToastOverlay), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
      overrides: [
        currencyControllerProvider.overrideWith(FormCurrencyController.new),
        categoriesProvider.overrideWith(RecordingCategories.new),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      )));
  await tester.pumpAndSettle();
}

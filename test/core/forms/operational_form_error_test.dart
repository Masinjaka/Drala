import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'support/failing_form_categories.dart';

void main() {
  testWidgets('a valid form keeps operational save failures as toast errors',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
        overrides: [
          categoriesProvider.overrideWith(FailingFormCategories.new),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
              body: Builder(
                  builder: (context) => TextButton(
                        onPressed: () => CategoryEditorSheet.show(context,
                            type: TransactionType.expense),
                        child: const Text('Open'),
                      ))),
        )));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Internet');
    await tester.ensureVisible(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();
    expect(find.byType(AppToastOverlay), findsOneWidget);
    expect(find.byType(CategoryEditorSheet), findsOneWidget);
    expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        'Internet');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}

import 'package:budgets/core/forms/submit_validated_form.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/transactions/presentation/widgets/amount_validation_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final reducedMotion in [false, true]) {
    testWidgets(
        'amount feedback is submit-only, accessible, and respects reduced motion=$reducedMotion',
        (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final form = GlobalKey<FormState>();
      var saved = false;
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: Scaffold(
                body: FinanceSheetScope(
                    child: SubmitValidatedForm(
              formKey: form,
              child: Column(children: [
                TransactionAmountField(
                    controller: controller, currencyCode: 'MGA'),
                TransactionFormActions(
                    saving: false,
                    onSave: () {
                      if (form.currentState!.validate()) saved = true;
                    }),
              ]),
            )))),
      ));
      Offset offset() {
        final delta = tester
            .widget<Transform>(find.byKey(const Key('amount-shake')))
            .transform
            .getTranslation();
        return Offset(delta.x, delta.y);
      }

      final input = find.byKey(const Key('transaction-amount'));
      await tester.enterText(input, '20');
      await tester.enterText(input, '');
      await tester.pumpAndSettle();
      expect(offset(), Offset.zero);
      expect(
          tester
              .state<FormFieldState<String>>(find.byType(AmountValidationField))
              .hasError,
          false);
      for (var attempt = 0; attempt < 2; attempt++) {
        await tester.tap(find.byKey(const Key('save-transaction')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        expect(saved, false);
        expect(offset().dx, reducedMotion ? 0 : isNot(0));
        final feedback = tester.widget<Semantics>(
            find.byKey(const Key('amount-validation-feedback')));
        expect(feedback.properties.label, isNotEmpty);
        expect(feedback.properties.liveRegion, true);
        expect(find.text(feedback.properties.label!), findsNothing);
        await tester.pumpAndSettle();
        expect(offset().dx, closeTo(0, .001));
      }
      await tester.enterText(input, '30');
      await tester.pumpAndSettle();
      expect(offset().dx, closeTo(0, .001));
      expect(
          tester
              .state<FormFieldState<String>>(find.byType(AmountValidationField))
              .hasError,
          false);
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(saved, true);
      expect(tester.takeException(), isNull);
    });
  }
}

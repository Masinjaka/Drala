import 'package:budgets/core/theme.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('save label uses button contrast in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TransactionFormActions(saving: false, onSave: () {}),
        ),
      ));

      final button = find.byKey(const ValueKey('save-transaction'));
      final text = find.descendant(of: button, matching: find.byType(Text));
      expect(tester.widget<Text>(text).style?.color,
          theme.colorScheme.onInverseSurface);
    });
  }
}

import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['en', 'fr', 'mg', 'de', 'es', 'it']) {
    testWidgets('$language explains an empty category name', (tester) async {
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final locale = Locale(language);
      final l10n = lookupAppLocalizations(locale);
      await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          const MalagasyMaterialLocalizationsDelegate(),
          const MalagasyCupertinoLocalizationsDelegate(),
        ],
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
      final save = find.byKey(const Key('save-transaction'));
      await tester.enterText(find.byType(TextFormField), '   ');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text(l10n.categoryNameRequired), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    });
  }
}

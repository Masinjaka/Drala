import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['en', 'fr', 'mg', 'de', 'es', 'it']) {
    testWidgets('$language explains missing envelope name and category',
        (tester) async {
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var saves = 0;
      final l10n = lookupAppLocalizations(Locale(language));
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        locale: Locale(language),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          const MalagasyMaterialLocalizationsDelegate(),
          const MalagasyCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                      onPressed: () => AddEnvelopeSheet.show(context,
                          categories: const [], month: DateTime(2026, 10),
                          onSave: (_, __, ___, ____) async {
                        saves++;
                      }),
                      child: const Text('Open'),
                    ))),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '100');
      await tester.enterText(find.byType(TextFormField).at(1), '   ');
      final save = find.byKey(const Key('save-envelope-button'));
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text(l10n.envelopeNameRequired), findsOneWidget);
      expect(saves, 0);
      expect(find.byType(AddEnvelopeSheet), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(1), 'Internet');
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text(l10n.envelopeCategoryRequired), findsOneWidget);
      expect(saves, 0);
      expect(find.byType(AddEnvelopeSheet), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    });
  }
}

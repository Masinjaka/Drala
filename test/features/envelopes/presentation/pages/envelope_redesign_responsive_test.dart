import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/editable_envelope_repository.dart';

void main() {
  for (final empty in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('envelopes fit large French text empty=$empty dark=$dark',
          (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 640);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.6)),
              child: child!),
          home: EnvelopePage(
              showBackButton: false,
              repository: EditableEnvelopeRepository()..deleted = empty),
        ));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('month-carousel')), findsOneWidget);
        expect(find.byKey(const Key('detail-add-button')).hitTestable(),
            findsOneWidget);
        if (empty) {
          await tester.ensureVisible(find.text('Créer une enveloppe'));
          await tester.pumpAndSettle();
          expect(
              find.text('Créer une enveloppe').hitTestable(), findsOneWidget);
        } else {
          expect(find.text('Food budget'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}

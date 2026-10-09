import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/editable_envelope_repository.dart';

void main() {
  testWidgets('tap edits the envelope then delete removes its card',
      (tester) async {
    final repository = EditableEnvelopeRepository();
    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EnvelopePage(
            repository: repository, initialMonth: DateTime(2025, 6))));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('envelope-food')));
    await tester.pumpAndSettle();
    expect(find.byType(AddEnvelopeSheet), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'Renamed budget');
    await tester.ensureVisible(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    expect(find.text('🍔 Renamed budget'), findsOneWidget);
    await tester.tap(find.byKey(const Key('envelope-food')));
    await tester.pumpAndSettle();
    await tester
        .ensureVisible(find.byKey(const ValueKey('delete-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('delete-transaction')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('envelope-food')), findsNothing);
    expect(repository.deleted, isTrue);
    expect(tester.takeException(), isNull);
  });
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/editable_envelope_repository.dart';

void main() {
  for (final empty in [false, true]) {
    testWidgets('carousel scrolls away and month enters header empty=$empty',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 717);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EnvelopePage(
              showBackButton: false,
              initialMonth: DateTime(2026, 9),
              repository: EditableEnvelopeRepository()..deleted = empty)));
      await tester.pumpAndSettle();
      final carousel = find.byKey(const Key('month-carousel'));
      final button = find.byKey(const Key('envelope-pick-month'));
      final monthLabel = find.byKey(const Key('calendar-button-month'));
      final start = tester.getTopLeft(carousel).dy;
      final headerTop = tester.getTopLeft(button).dy;
      expect(monthLabel, findsNothing);
      await tester.drag(
          find.byKey(const Key('envelope-month-list')), const Offset(0, -50));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(carousel).dy, lessThan(start));
      expect(monthLabel, findsNothing);
      await tester.drag(
          find.byKey(const Key('envelope-month-list')), const Offset(0, -180));
      await tester.pumpAndSettle();
      expect(carousel, findsNothing);
      expect(tester.getTopLeft(button).dy, headerTop);
      expect(monthLabel, findsOneWidget);
      expect(tester.widget<Text>(monthLabel).data, 'September');
      await tester.drag(
          find.byKey(const Key('envelope-month-list')), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(carousel).dy, closeTo(start, .1));
      expect(monthLabel, findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

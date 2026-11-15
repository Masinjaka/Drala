import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/editable_envelope_repository.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('create matches the calendar colors in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EnvelopePage(
          showBackButton: false,
          repository: EditableEnvelopeRepository()..deleted = true,
        ),
      ));
      await tester.pumpAndSettle();
      final create = find.byKey(const Key('envelope-create'));
      final calendar = find.byKey(const Key('envelope-pick-month'));
      Color? foreground(Finder button) => IconTheme.of(tester.element(
              find.descendant(of: button, matching: find.byType(Icon)).first))
          .color;
      Color? background(Finder button) => tester
          .widget<Material>(find
              .descendant(of: button, matching: find.byType(Material))
              .first)
          .color;
      expect(foreground(create), foreground(calendar));
      expect(background(create), background(calendar));
    });
  }

  for (final empty in [false, true]) {
    testWidgets('Envelope calendar and create action work for empty=$empty',
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
      final add = find.byKey(const Key('envelope-create'));
      expect(tester.getCenter(add).dy, tester.getCenter(button).dy);
      expect(
          tester.getCenter(add).dx, greaterThan(tester.getCenter(button).dx));
      if (empty) {
        await tester.drag(find.byKey(const Key('envelope-month-list')),
            const Offset(0, -180));
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(carousel).dy, start);
        expect(monthLabel, findsNothing);
        await tester.tap(add);
        await tester.pumpAndSettle();
        expect(find.byType(AddEnvelopeSheet), findsOneWidget);
        return;
      }
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
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(find.byType(AddEnvelopeSheet), findsOneWidget);
    });
  }
}

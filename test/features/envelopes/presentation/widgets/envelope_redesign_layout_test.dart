import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_panel.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _envelope = Envelope(
    id: 'food',
    name: 'Courses et repas de la semaine',
    categoryId: 'food',
    categoryName: 'Food',
    emoji: '',
    iconKey: 'food',
    color: 'FFFFFFFF',
    amount: 1234567890,
    spent: 123450000,
    currencyCode: 'MGA');

void main() {
  for (final dark in [false, true]) {
    testWidgets(
        'redesigned card fits a narrow phone with large French text dark=$dark',
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
        home: Scaffold(
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: EnvelopeCard(envelope: _envelope, onDelete: () {}))),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Dépensé'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('card entrance still fades and slides, then opens on tap',
      (tester) async {
    var opened = false;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
      child: EnvelopeListPanel(
          envelopes: const [_envelope],
          onDelete: (_) {},
          onEdit: (_) => opened = true),
    ))));
    final card = find.byKey(const Key('envelope-food'));
    final fade = find
        .descendant(
            of: find.byType(EnvelopeListPanel),
            matching: find.byType(FadeTransition))
        .first;
    final slide = find
        .descendant(
            of: find.byType(EnvelopeListPanel),
            matching: find.byType(SlideTransition))
        .first;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 75));
    expect(tester.widget<FadeTransition>(fade).opacity.value,
        inExclusiveRange(0, 1));
    expect(tester.widget<SlideTransition>(slide).position.value.dy,
        greaterThan(0));
    await tester.pumpAndSettle();
    expect(tester.widget<FadeTransition>(fade).opacity.value, 1);
    expect(tester.widget<SlideTransition>(slide).position.value, Offset.zero);
    await tester.tap(card);
    expect(opened, isTrue);
  });
}

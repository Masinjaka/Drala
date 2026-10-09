import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses text-height skeletons for loading amounts', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvelopeCard(
            loading: true,
            envelope: const Envelope(
              id: 'food',
              name: 'Food',
              categoryId: 'category',
              categoryName: 'Food',
              emoji: '🍔',
              color: 'FFFF9800',
              amount: 100000,
              spent: 25000,
              currencyCode: 'MGA',
            ),
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('🍔 Food'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('envelope-spent-skeleton'))),
      const Size(64, 18),
    );
    expect(
      tester.getSize(find.byKey(const Key('envelope-budget-skeleton'))),
      const Size(56, 18),
    );
  });

  testWidgets('uses the themed rounded surface without an outline',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvelopeCard(
            envelope: const Envelope(
              id: 'food',
              name: 'Food',
              categoryId: 'category',
              categoryName: 'Food',
              emoji: '🍔',
              color: 'FFFF9800',
              amount: 100000,
              spent: 25000,
              currencyCode: 'MGA',
            ),
            onDelete: () {},
          ),
        ),
      ),
    );

    final surface = tester.widget<Container>(
      find.byKey(const Key('envelope-card-surface')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    final context = tester.element(find.byType(EnvelopeCard));
    expect(decoration.color, Theme.of(context).colorScheme.surfaceContainer);
    expect(decoration.border, isNull);
  });

  testWidgets('shows a red warning when an envelope is over budget',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EnvelopeCard(
            envelope: const Envelope(
              id: 'food',
              name: 'Food',
              categoryId: 'category',
              categoryName: 'Food',
              emoji: '🍔',
              color: 'FFFF9800',
              amount: 100000,
              spent: 125000,
              currencyCode: 'MGA',
              overspentAmount: 25000,
            ),
            onDelete: () {},
          ),
        ),
      ),
    );

    final warning = find.byKey(const Key('envelope-overspend-warning'));
    expect(warning, findsOneWidget);
    expect(find.text('Over by 25k'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(const Key('envelope-card-surface')),
            matching: warning),
        findsOneWidget);
    final amount =
        tester.widget<RichText>(find.text('125 k MGA', findRichText: true));
    final span = amount.text as TextSpan;
    final content = span.children!.single as TextSpan;
    final suffix = content.children!.last as TextSpan;
    expect(suffix.style!.fontSize,
        Theme.of(tester.element(warning)).textTheme.bodyLarge!.fontSize);
  });
}

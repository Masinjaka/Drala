import 'dart:async';

import '../../support/overview_entry_repository.dart';
import '../../support/overview_envelope_repository.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/overview_fixture.dart';

void main() {
  testWidgets(
      'a quick Home load displays data without a loading or empty flash',
      (tester) async {
    await tester.pumpWidget(overviewFixture());
    expect(find.byType(HomeOverviewTransactionSkeleton), findsNothing);
    expect(find.byKey(const Key('home-empty-transactions')), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byType(HomeOverviewTransactionSkeleton), findsNothing);
    expect(find.byType(HomeOverviewTransactionTile), findsNWidgets(4));
  });

  testWidgets('a previous account cannot fill the new account Home',
      (tester) async {
    final oldGate = Completer<void>();
    final oldEntries = OverviewEntryRepository()
      ..recent = overviewEntries().monthlyEntries
      ..loadGate = oldGate.future;
    await tester.pumpWidget(overviewFixture(
        homeKey: const ValueKey('old-account'), entryRepository: oldEntries));
    await tester.pump();
    await tester.pumpWidget(overviewFixture(
        homeKey: const ValueKey('new-account'),
        entryRepository: OverviewEntryRepository()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-empty-transactions')), findsOneWidget);

    oldGate.complete();
    await tester.pumpAndSettle();
    expect(find.byType(HomeOverviewTransactionTile), findsNothing);
    expect(find.byKey(const Key('home-empty-transactions')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets('Home loading reserves the loaded card layout, dark=$dark',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 760);
      addTearDown(tester.view.reset);
      final gate = Completer<void>();
      final entries = OverviewEntryRepository()
        ..monthlyEntries = overviewEntries().monthlyEntries
        ..recent = overviewEntries().monthlyEntries
        ..loadGate = gate.future;
      final envelopeRepository = OverviewEnvelopeRepository()
        ..loadGate = gate.future;
      await tester.pumpWidget(overviewFixture(
          dark: dark,
          entryRepository: entries,
          envelopeRepository: envelopeRepository));
      final envelopes = find.byType(HomeOverviewEnvelopeSkeleton);
      final transactions = find.byType(HomeOverviewTransactionSkeleton);
      await tester.pump(const Duration(milliseconds: 199));
      expect(envelopes, findsNothing);
      expect(transactions, findsNothing);
      expect(find.byKey(const Key('home-empty-transactions')), findsNothing);
      await tester.pump(const Duration(milliseconds: 1));
      expect(envelopes, findsNWidgets(2));
      expect(transactions, findsNWidgets(4));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      final envelopeSize = tester.getSize(envelopes.first);
      final transactionSize = tester.getSize(transactions.first);

      gate.complete();
      await tester.pumpAndSettle();
      expect(envelopes, findsNothing);
      expect(transactions, findsNothing);
      expect(tester.getSize(find.byType(HomeOverviewEnvelopeCard).first),
          envelopeSize);
      expect(tester.getSize(find.byType(HomeOverviewTransactionTile).first),
          transactionSize);
      expect(tester.takeException(), isNull);
    });
  }
}

import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/overview_fixture.dart';

void main() {
  for (final scale in [1.0, 1.6]) {
    testWidgets('envelope cards stay 170 pixels tall at text scale $scale',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 917);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(overviewFixture(scale: scale));
      await tester.pumpAndSettle();
      for (final card in find.byType(HomeOverviewEnvelopeCard).evaluate()) {
        expect(tester.getSize(find.byWidget(card.widget)).height, 170);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('transaction group has rounded inner corners and four pixel gaps',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(overviewFixture());
    await tester.pumpAndSettle();
    final tiles = find.byType(HomeOverviewTransactionTile);
    expect(tiles, findsNWidgets(4));
    for (var i = 0; i < 4; i++) {
      final material = tester.widget<Material>(find
          .descendant(of: tiles.at(i), matching: find.byType(Material))
          .first);
      final radius = (material.shape! as RoundedRectangleBorder).borderRadius;
      expect(
          radius,
          BorderRadius.vertical(
              top: Radius.circular(i == 0 ? 24 : 10),
              bottom: Radius.circular(i == 3 ? 24 : 10)));
      expect(tester.getSize(tiles.at(i)).height, 60);
      final amount = find.descendant(
          of: tiles.at(i), matching: find.byType(HomeOverviewAmount));
      expect(tester.getTopRight(amount).dx,
          closeTo(tester.getTopRight(tiles.at(i)).dx - 16, 0.01));
      if (i > 0) {
        expect(
            tester.getTopLeft(tiles.at(i)).dy -
                tester.getBottomLeft(tiles.at(i - 1)).dy,
            4);
      }
    }
  });
}

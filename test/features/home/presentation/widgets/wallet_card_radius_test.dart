import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_card_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('wallet card and loading skeleton have ten pixel corners',
      (tester) async {
    const wallet = WalletSummary(
      id: 'cash',
      name: 'Cash',
      balance: 1000,
      currencyCode: 'MGA',
      iconKey: 'cash',
      isDefault: false,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(children: [
          WalletOverviewCard(wallet: wallet, index: 0, onPressed: () {}),
          const WalletCardSkeleton(),
        ]),
      ),
    ));
    final card = tester.widget<Material>(
      find.descendant(
        of: find.byType(WalletOverviewCard),
        matching: find.byType(Material),
      ).first,
    );
    final skeleton = tester.widget<Container>(
      find.descendant(
        of: find.byType(WalletCardSkeleton),
        matching: find.byType(Container),
      ).first,
    );
    expect(card.borderRadius, BorderRadius.circular(10));
    expect((skeleton.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(10));
  });
}

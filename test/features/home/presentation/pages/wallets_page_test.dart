import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('refreshes cards when the wallet model changes', (tester) async {
    final wallets = ValueNotifier<List<WalletSummary>>([_wallet('cash', 'Cash')]);
    addTearDown(wallets.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: WalletsPage(
          wallets: wallets.value,
          walletsListenable: wallets,
          walletReader: () => wallets.value,
          onAddWallet: (_) async {},
          onUpdateWallet: (_, __) async {},
          onDeleteWallet: (_) async {},
        ),
      ),
    );

    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Bank'), findsNothing);

    wallets.value = [_wallet('cash', 'Cash'), _wallet('bank', 'Bank')];
    await tester.pump();

    expect(find.text('Bank'), findsOneWidget);
  });
}

WalletSummary _wallet(String id, String name) => WalletSummary(
      id: id,
      name: name,
      balance: 250000,
      currencyCode: 'MGA',
      iconKey: id,
      isDefault: id == 'cash',
    );

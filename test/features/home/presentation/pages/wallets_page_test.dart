import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows wallet-shaped skeletons until wallets load',
      (tester) async {
    final wallets = ValueNotifier<List<WalletSummary>>([]);
    addTearDown(wallets.dispose);
    var loading = true;
    await tester.pumpWidget(MaterialApp(
      home: WalletsPage(
        wallets: const [],
        walletsListenable: wallets,
        walletReader: () => wallets.value,
        loadingReader: () => loading,
        onAddWallet: (_) async {},
        onUpdateWallet: (_, __) async {},
        onDeleteWallet: (_) async {},
      ),
    ));
    expect(find.byType(WalletCardSkeleton), findsNWidgets(3));

    loading = false;
    wallets.value = [_wallet('cash', 'Cash')];
    await tester.pump();
    expect(find.byType(WalletCardSkeleton), findsNothing);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('refreshes cards when the wallet model changes', (tester) async {
    final wallets =
        ValueNotifier<List<WalletSummary>>([_wallet('cash', 'Cash')]);
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
    expect(find.text('Default'), findsOneWidget);
    expect(find.byKey(const Key('default-wallet-badge')), findsOneWidget);
    expect(find.text('250 k MGA'), findsOneWidget);
    final amount = tester.widget<Text>(find.text('250 k MGA'));
    final suffix = (amount.textSpan! as TextSpan).children!.last as TextSpan;
    expect(suffix.style,
        AppTextTheme.currencyLabel(tester.element(find.text('250 k MGA'))));
    expect(suffix.style!.fontSize, lessThan(amount.style!.fontSize!));
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

import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../guest/support/guest_finance_fixture.dart';

void main() {
  testWidgets(
      'selects several wallets, protects default and confirms the batch',
      (tester) async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    final wallets = ValueNotifier<List<WalletSummary>>(fixture.wallets);
    addTearDown(wallets.dispose);
    var calls = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WalletsPage(
          wallets: fixture.wallets,
          walletsListenable: wallets,
          walletReader: () => wallets.value,
          onAddWallet: (_) async {},
          onUpdateWallet: (_, __) async {},
          onDeleteWallet: (_) async {},
          onDeleteWallets: (ids) async {
            calls++;
            await fixture.repositories.finance.deleteWallets(ids);
            wallets.value = await fixture.repositories.wallets.wallets();
          }),
    ));
    await tester.pumpAndSettle();
    final select = find.byKey(const Key('select-items'));
    final close = find.byKey(const Key('wallet-page-close'));
    expect(tester.widget(select), isA<IconButton>());
    expect(tester.getCenter(select).dy, tester.getCenter(close).dy);
    expect(tester.getCenter(select).dx, lessThan(tester.getCenter(close).dx));
    await tester.tap(find.byKey(const Key('select-items')));
    await tester.pumpAndSettle();
    final defaultWallet = fixture.wallets.firstWhere((w) => w.isDefault);
    expect(
        tester
            .widget<Checkbox>(
                find.byKey(Key('select-wallet-${defaultWallet.id}')))
            .onChanged,
        isNull);
    for (final wallet in fixture.wallets.where((w) => !w.isDefault)) {
      final checkbox = find.byKey(Key('select-wallet-${wallet.id}'));
      await tester.ensureVisible(checkbox);
      final card = find.ancestor(
          of: checkbox, matching: find.byType(WalletOverviewCard));
      final bounds = tester.getRect(card);
      final checkBounds = tester.getRect(checkbox);
      expect(bounds.contains(checkBounds.topLeft), isTrue);
      expect(bounds.contains(checkBounds.bottomRight), isTrue);
      expect(checkBounds.center.dx, lessThan(bounds.center.dx));
      expect(checkBounds.top, lessThan(bounds.top + 40));
      final icon = find.descendant(of: card, matching: find.byType(Icon));
      expect(checkBounds.overlaps(tester.getRect(icon)), isFalse);
      await tester.tap(checkbox);
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('delete-selected-items')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Delete 2 selected wallets'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cancel-delete')));
    await tester.pumpAndSettle();
    expect(calls, 0);
    await tester.tap(find.byKey(const Key('delete-selected-items')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(wallets.value.single.id, defaultWallet.id);
    expect(find.byKey(const Key('select-items')), findsOneWidget);
  });
}

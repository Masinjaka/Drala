import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'cancel preserves wallet and confirmed in-use deletion explains why',
      (tester) async {
    var deletes = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WalletsPage(
        wallets: const [
          WalletSummary(
              id: 'bank',
              name: 'Bank',
              balance: 100,
              currencyCode: 'MGA',
              iconKey: 'bank',
              isDefault: false)
        ],
        onAddWallet: (_) async {},
        onUpdateWallet: (_, __) async {},
        onDeleteWallet: (_) async {
          deletes++;
          throw const WalletDeletionException.inUse();
        },
      ),
    ));
    await _requestDelete(tester);
    expect(deletes, 0);
    await tester.tap(find.byKey(const Key('cancel-delete')));
    await tester.pumpAndSettle();
    expect(find.text('Bank'), findsOneWidget);
    expect(deletes, 0);
    await _requestDelete(tester);
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(deletes, 1);
    expect(find.textContaining('used by an envelope'), findsOneWidget);
    expect(find.text('Bank'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });
}

Future<void> _requestDelete(WidgetTester tester) async {
  await tester.tap(find.text('Bank'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const Key('delete-wallet')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('delete-wallet')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('confirm-delete')), findsOneWidget);
}

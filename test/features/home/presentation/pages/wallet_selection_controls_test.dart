import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  testWidgets(
      'selection controls select all, show partial state, clear and cancel',
      (tester) async {
    var deletions = 0;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WalletsPage(
        wallets: [
          for (var i = 0; i < 3; i++)
            WalletSummary(
                id: '$i',
                name: 'Wallet $i',
                balance: 100,
                currencyCode: 'MGA',
                iconKey: 'cash',
                isDefault: i == 0),
        ],
        onAddWallet: (_) async {},
        onUpdateWallet: (_, __) async {},
        onDeleteWallet: (_) async {
          deletions++;
        },
        onDeleteWallets: (_) async {
          deletions++;
        },
      ),
    ));
    await tester.pumpAndSettle();
    final addBounds = tester.getRect(find.byKey(const Key('wallet-create')));
    await tester.tap(find.byKey(const Key('select-items')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wallet-create')), findsNothing);
    final cancel = find.byKey(const Key('cancel-selection'));
    expect(cancel, findsOneWidget);
    expect(tester.getRect(cancel), addBounds);
    final all = find.byKey(const Key('select-all-wallets'));
    final delete = find.byKey(const Key('delete-selected-items'));
    final close = find.byKey(const Key('wallet-page-close'));
    expect(tester.widget<Checkbox>(all).value, isFalse);
    IconButton deleteButton() => tester.widget<IconButton>(
        find.descendant(of: delete, matching: find.byType(IconButton)));
    final closeButton = tester.widget<IconButton>(
        find.descendant(of: close, matching: find.byType(IconButton)));
    expect(deleteButton().onPressed, isNull);
    expect(tester.getCenter(delete).dy, tester.getCenter(close).dy);
    expect(tester.getCenter(delete).dx, lessThan(tester.getCenter(close).dx));
    expect(deleteButton().style?.backgroundColor?.resolve({}),
        closeButton.style?.backgroundColor?.resolve({}));
    expect(
        tester
            .widget<FaIcon>(
                find.descendant(of: delete, matching: find.byType(FaIcon)))
            .icon,
        FontAwesomeIcons.trashCan.data);
    expect(tester.getCenter(all).dx,
        lessThan(tester.getCenter(find.text('0 selected')).dx));
    expect(
        tester
            .widget<Checkbox>(find.byKey(const Key('select-wallet-0')))
            .onChanged,
        isNull);

    await tester.tap(find.byKey(const Key('select-wallet-1')));
    await tester.pump();
    expect(tester.widget<Checkbox>(all).value, isNull);
    expect(find.text('1 selected'), findsOneWidget);
    await tester.tap(all);
    await tester.pump();
    expect(tester.widget<Checkbox>(all).value, isTrue);
    expect(find.text('2 selected'), findsOneWidget);
    expect(
        tester.widget<Checkbox>(find.byKey(const Key('select-wallet-0'))).value,
        isFalse);
    expect(deleteButton().onPressed, isNotNull);
    await tester.tap(all);
    await tester.pump();
    expect(tester.widget<Checkbox>(all).value, isFalse);
    expect(find.text('0 selected'), findsOneWidget);
    await tester.tap(cancel);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wallet-create')), findsOneWidget);
    expect(find.byKey(const Key('select-items')), findsOneWidget);
    expect(all, findsNothing);
    expect(deletions, 0);
    expect(tester.takeException(), isNull);
  });
}

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    for (final width in [320.0, 1024.0]) {
      testWidgets(
          'wallet grid keeps actions and balances readable at $width ${theme.brightness}',
          (tester) async {
        tester.view.physicalSize = Size(width, 760);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
            theme: theme,
            locale: const Locale('fr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.6)),
                child: child!),
            home: WalletsPage(
                wallets: [
                  for (var index = 0; index < 8; index++)
                    WalletSummary(
                        id: '$index',
                        name: 'Compte bancaire $index',
                        balance: 150000,
                        currencyCode: 'MGA',
                        iconKey: 'bank',
                        isDefault: index == 0)
                ],
                onAddWallet: (_) async {},
                onUpdateWallet: (_, __) async {},
                onDeleteWallet: (_) async {})));
        await tester.pumpAndSettle();
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(WalletOverviewCard), findsWidgets);
        expect(find.text('Ar 150,000'), findsWidgets);
        final action = find.byKey(const Key('wallet-create'));
        expect(action.hitTestable(), findsOneWidget);
        await tester.drag(find.byType(GridView), const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(action.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

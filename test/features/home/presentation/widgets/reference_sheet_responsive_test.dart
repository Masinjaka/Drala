import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    for (final type in ['expense', 'income', 'transfer']) {
      testWidgets(
          'reference $type sheet keeps action above keyboard ${theme.brightness}',
          (tester) async {
        tester.view.physicalSize = const Size(320, 700);
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
            home: Scaffold(
                body: Builder(
                    builder: (context) => TextButton(
                        onPressed: () => ManualEntrySheet.show(context,
                                categories: Future.value([]),
                                targetDate: DateTime(2026, 11, 2),
                                allowTransfers: true,
                                wallets: const [
                                  WalletSummary(
                                      id: 'cash',
                                      name: 'Espèces',
                                      balance: 50000,
                                      currencyCode: 'MGA',
                                      iconKey: 'cash',
                                      isDefault: true),
                                  WalletSummary(
                                      id: 'bank',
                                      name: 'Banque',
                                      balance: 20000,
                                      currencyCode: 'MGA',
                                      iconKey: 'bank',
                                      isDefault: false)
                                ]),
                        child: const Text('Open'))))));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('transaction-type-$type')));
        await tester.pumpAndSettle();
        final amount = find.byKey(const Key('transaction-amount'));
        await tester.showKeyboard(amount);
        tester.view.viewInsets = const FakeViewPadding(bottom: 240);
        await tester.pumpAndSettle();
        final action = find.byKey(Key(
            type == 'transfer' ? 'save-manual-transfer' : 'save-transaction'));
        expect(action.hitTestable(), findsOneWidget);
        expect(tester.getRect(action).bottom, lessThanOrEqualTo(460));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const Key('close-transaction-sheet')));
        await tester.pumpAndSettle();
        expect(find.byType(ManualEntrySheet), findsNothing);
      });
    }
  }
}

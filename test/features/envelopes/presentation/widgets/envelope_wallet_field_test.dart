import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_wallet_field.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final id in <String?>[null, 'missing']) {
    testWidgets(
        'an unavailable original wallet ($id) never falls back to the default',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: EnvelopeWalletField(
          initialWalletId: id,
          readOnly: true,
          wallets: const [
            WalletSummary(
                id: 'cash',
                name: 'Cash',
                balance: 1000,
                currencyCode: 'MGA',
                iconKey: 'wallet',
                isDefault: true)
          ],
        )),
      ));
      final wallet = tester.widget<DropdownButtonFormField<String>>(
          find.byKey(const Key('envelope-funding-wallet')));
      expect(wallet.initialValue, isNull);
      expect(wallet.onChanged, isNull);
      expect(find.text('Funding wallet unavailable'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

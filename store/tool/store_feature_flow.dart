import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'store_capture_flow.dart';

/// Settings-reachable features: wallets, categories, reminders, currency.
extension StoreFeatureFlow on StoreCaptureFlow {
  Future<void> back() async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await settle();
  }

  Future<void> featureScreens(AmountVisibilityController v) async {
    await pumpApp(await guest(), v);
    await settle();
    await openTab(4);
    await settle();
    for (final (label, name) in [
      ('Portefeuilles', 'wallets'),
      ('Catégories', 'categories'),
    ]) {
      await tap(find.text(label));
      await shot(name);
      if (name == 'categories') {
        await tap(find.byKey(const Key('category-create')));
        await tester.enterText(find.byType(TextField).last, 'Animaux');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await shot('category-editor');
        await back();
      }
      await back();
    }
    await tap(find.text('Notifications').last);
    await shot('reminders');
    await back();
    await tap(find.text('Devise'));
    await shot('currency');
  }

  /// Signed-in home displayed in euros (demo rate), same MGA data.
  Future<void> currencyHome(AmountVisibilityController v) async {
    await pumpApp(await guest(), v,
        signedIn: true,
        currency: const CurrencyState(
            code: 'EUR',
            baseCode: 'MGA',
            rates: {'EUR': 1 / 5150, 'USD': 1 / 4600}));
    await shot('home-eur');
  }
}

import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/renewing_wallet_repository.dart';

void main() {
  test('waits for renewal before reading totals and refreshes on month change',
      () async {
    final repository = RenewingWalletRepository();
    final model = AiEntryViewModel(repository, DateTime(2026, 9, 30));
    addTearDown(model.dispose);

    await model.loadDate(DateTime(2026, 9, 30));
    expect(model.totalWalletBalance, 1000);
    expect(model.wallets.single.balance, 1000);

    await model.loadDate(DateTime(2026, 9, 29));
    expect(repository.walletLoads, 1);

    repository.balance = 800;
    await model.loadDate(DateTime(2026, 10, 1));
    expect(repository.walletLoads, 2);
    expect(model.totalWalletBalance, 800);
    expect(model.wallets.single.balance, 800);
  });
}

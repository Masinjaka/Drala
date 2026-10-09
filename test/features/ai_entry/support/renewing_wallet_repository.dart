import 'package:budgets/features/home/domain/models/wallet_summary.dart';

import 'fake_ai_entry_repository.dart';

class RenewingWalletRepository extends FakeAiEntryRepository {
  int balance = 1000;
  int walletLoads = 0;
  bool renewing = false;

  @override
  Future<List<WalletSummary>> wallets() async {
    walletLoads++;
    renewing = true;
    await Future<void>.delayed(Duration.zero);
    walletItems = [
      WalletSummary(
          id: 'cash',
          name: 'Cash',
          balance: balance,
          currencyCode: 'MGA',
          iconKey: 'wallet',
          isDefault: true),
    ];
    renewing = false;
    return walletItems;
  }

  @override
  Future<int> totalFunds() async {
    if (renewing) throw StateError('Balance read before renewal finished');
    return super.totalFunds();
  }
}

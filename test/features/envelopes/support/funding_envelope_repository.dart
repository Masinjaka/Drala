import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/home/domain/errors/wallet_selection_required_exception.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'editable_envelope_repository.dart';

class FundingEnvelopeRepository extends EditableEnvelopeRepository {
  String? fundedWallet;
  int balance;
  FundingEnvelopeRepository({this.balance = 500});

  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async => [];

  @override
  Future<List<WalletSummary>> wallets() async => [
        WalletSummary(
            id: 'cash',
            name: 'Cash',
            balance: balance,
            currencyCode: 'MGA',
            iconKey: 'wallet',
            isDefault: true),
        WalletSummary(
            id: 'bank',
            name: 'Bank',
            balance: balance,
            currencyCode: 'MGA',
            iconKey: 'bank',
            isDefault: false),
      ];

  @override
  Future<void> addEnvelope(
      {required String name,
      required String categoryId,
      required int amount,
      required DateTime month,
      String? walletId,
      bool repeatsMonthly = false}) async {
    if (amount > balance) {
      throw WalletSelectionRequiredException(requiredAmount: amount);
    }
    fundedWallet = walletId;
  }
}

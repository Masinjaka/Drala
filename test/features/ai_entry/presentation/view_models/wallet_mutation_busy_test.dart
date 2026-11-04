import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/fake_ai_entry_repository.dart';

void main() {
  test('bulk deletion cannot overlap an outstanding wallet mutation', () async {
    final repository = FakeAiEntryRepository();
    final model = AiEntryViewModel(repository, DateTime(2026, 10, 22));
    addTearDown(model.dispose);
    final adding = model
        .addWallet(const AddWalletInput(name: 'Savings', initialBalance: 500));
    expect(model.isAddingWallet, isTrue);
    await expectLater(
        model.deleteWallets(['wallet']),
        throwsA(isA<StateError>().having(
            (error) => error.message, 'message', 'operation_in_progress')));
    await adding;
    expect(model.isAddingWallet, isFalse);
    expect(model.wallets, hasLength(1));
    expect(model.totalWalletBalance, 500);
  });
}

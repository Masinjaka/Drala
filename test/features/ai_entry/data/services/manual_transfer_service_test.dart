import 'package:budgets/features/ai_entry/data/services/manual_transfer_service.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/manual_transfer_backend.dart';

void main() {
  test('uses one atomic RPC with the stable submission ID and UTC date',
      () async {
    final date = DateTime(2026, 10, 20, 12);
    final input = ManualTransferInput(
        id: 'submission',
        fromWalletId: 'cash',
        toWalletId: 'bank',
        amount: 500,
        occurredAt: date,
        description: 'Savings');
    final backend = ManualTransferBackend();
    await backend.start(date);
    addTearDown(backend.dispose);
    final service = ManualTransferService(backend.client);
    for (var attempt = 0; attempt < 2; attempt++) {
      final entry = await service.add(input);
      expect(entry.id, 'submission');
      expect(entry.isTransfer, isTrue);
      expect(entry.amount, 500);
      expect(entry.sourceWalletId, 'cash');
    }
    expect(backend.requests, hasLength(2));
    for (final request in backend.requests) {
      expect(request, {
        'p_transfer_id': 'submission',
        'p_from_wallet_id': 'cash',
        'p_to_wallet_id': 'bank',
        'p_amount': 500,
        'p_occurred_at': date.toUtc().toIso8601String(),
        'p_description': 'Savings',
      });
    }
    expect(backend.paths,
        everyElement('/rest/v1/rpc/create_manual_wallet_transfer'));
    expect(backend.methods, everyElement('POST'));
  });
}

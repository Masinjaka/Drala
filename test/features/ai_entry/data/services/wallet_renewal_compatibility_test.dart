import 'package:budgets/features/ai_entry/data/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../envelopes/support/renewal_backend.dart';

void main() {
  late RenewalBackend backend;
  setUp(() async {
    backend = RenewalBackend();
    await backend.start();
  });
  tearDown(() => backend.dispose());

  test('reads balances when the renewal migration is absent', () async {
    final wallets = await WalletService(backend.client).wallets();
    expect(wallets.single.balance, 800);
    expect(backend.calls, ['renew_monthly_envelopes', 'wallets']);
    final now = DateTime.now();
    expect(backend.rpcParams.single, {
      'p_month': '${now.year}-${now.month.toString().padLeft(2, '0')}-01',
    });
  });

  test('retries renewal after the migration becomes available', () async {
    final service = WalletService(backend.client);
    await service.wallets();
    backend.errorCode = null;
    final wallets = await service.wallets();
    expect(wallets.single.balance, 800);
    expect(backend.calls.where((call) => call == 'renew_monthly_envelopes'),
        hasLength(2));
  });

  test('does not hide permission errors or read misleading balances', () async {
    backend.errorCode = '42501';
    await expectLater(WalletService(backend.client).wallets(),
        throwsA(isA<PostgrestException>()));
    expect(backend.calls, ['renew_monthly_envelopes']);
  });

  test('does not hide a missing dependency inside the RPC', () async {
    backend.missingFunction = 'different_function';
    await expectLater(WalletService(backend.client).wallets(),
        throwsA(isA<PostgrestException>()));
    expect(backend.calls, ['renew_monthly_envelopes']);
  });
}

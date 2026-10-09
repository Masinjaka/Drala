import 'package:budgets/features/envelopes/data/services/envelope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../support/renewal_backend.dart';

void main() {
  late RenewalBackend backend;
  setUp(() async {
    backend = RenewalBackend();
    await backend.start();
  });
  tearDown(() => backend.dispose());

  test('reads existing envelopes when renewal is not deployed', () async {
    final service = EnvelopeService(backend.client);
    expect(await service.envelopes(DateTime.now()), isEmpty);
    expect(backend.calls, ['renew_monthly_envelopes', 'envelopes']);
  });

  test('monthly creation is never silently downgraded to one-off funding',
      () async {
    backend.missingFunction = 'fund_monthly_envelope';
    await expectLater(
      EnvelopeService(backend.client).addEnvelope(
        name: 'Food',
        categoryId: 'food',
        amount: 100,
        month: DateTime.now(),
        repeatsMonthly: true,
      ),
      throwsA(isA<PostgrestException>()),
    );
    expect(backend.calls, ['fund_monthly_envelope']);
  });
}

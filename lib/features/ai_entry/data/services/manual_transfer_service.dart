import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManualTransferService {
  const ManualTransferService(this.client);
  final SupabaseClient client;

  Future<FinanceEntry> add(ManualTransferInput input) async {
    final result = await client.rpc('create_manual_wallet_transfer', params: {
      'p_transfer_id': input.id,
      'p_from_wallet_id': input.fromWalletId,
      'p_to_wallet_id': input.toWalletId,
      'p_amount': input.amount,
      'p_occurred_at': input.occurredAt.toUtc().toIso8601String(),
      'p_description': input.description,
    });
    return FinanceEntry.fromJson(Map<String, dynamic>.from(result as Map));
  }
}

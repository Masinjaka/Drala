part of 'finance_entry_query_service.dart';

extension FinanceRecentTransactionQuery on FinanceEntryQueryService {
  Future<List<FinanceEntry>> recentTransactions(String userId,
      {int limit = 3}) async {
    final rows = await _client
        .from('transaction')
        .select(
          'id,title,description,amount,date,transaction_type,currency_code,'
          'source_wallet_id,envelope_amount_used,'
          'envelope:envelopes(name),categories(id,name,emoji,icon_key,color),'
          'transaction_wallet_debits(wallet_id)',
        )
        .eq('user_id', userId)
        .order('date', ascending: false)
        .order('id', ascending: false)
        .limit(limit);
    return rows.map(FinanceEntry.fromJson).toList(growable: false);
  }
}

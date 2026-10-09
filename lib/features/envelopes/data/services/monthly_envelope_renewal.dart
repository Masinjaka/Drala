import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class MonthlyEnvelopeRenewal {
  static Future<void> run(SupabaseClient client, {DateTime? month}) async {
    final date = month ?? DateTime.now();
    try {
      await client.rpc('renew_monthly_envelopes', params: {
        'p_month': '${date.year}-${date.month.toString().padLeft(2, '0')}-01',
      });
    } on PostgrestException catch (error) {
      // The renewal RPC may not be deployed yet. Do not turn a successful
      // expense into an apparent failure during the subsequent balance read.
      // Retry on the next read so a newly deployed migration takes effect.
      final missingRenewal = error.code == 'PGRST202' &&
          RegExp(r'Could not find the function public\.renew_monthly_envelopes(?:\(|\s)')
              .hasMatch(error.message);
      if (!missingRenewal) rethrow;
    }
  }
}

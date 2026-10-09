import 'package:budgets/core/monitoring/development_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceWarningDispatcher {
  const FinanceWarningDispatcher();

  Future<void> dispatch() async {
    try {
      final client = Supabase.instance.client;
      if (client.auth.currentSession == null) return;
      await client.functions.invoke('notifications-warning', body: {});
    } catch (error, stackTrace) {
      DevelopmentLog.error('send finance warning', error, stackTrace);
    }
  }
}

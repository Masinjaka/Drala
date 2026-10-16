import 'package:budgets/features/guest/data/guest_snapshot.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuestCloudSyncService {
  const GuestCloudSyncService(this.client, this.guest);

  final SupabaseClient client;
  final GuestSession guest;
  static final Map<String, Future<void>> _inFlight = {};

  Future<void> sync() => _inFlight.putIfAbsent(guest.userId, () async {
        try {
          await _sync();
        } finally {
          _inFlight.remove(guest.userId);
        }
      });

  Future<void> _sync() async {
    if (!guest.isActive || !guest.onboardingComplete) return;
    final accountId = client.auth.currentUser?.id;
    if (accountId == null) {
      throw StateError('Sign in before syncing guest data.');
    }
    guest.setSyncing(true);
    try {
      final snapshot =
          await GuestSnapshot(guest.database, guest.userId).export();
      await client.rpc('import_guest_snapshot_v2', params: {
        'p_guest_id': guest.userId,
        'p_snapshot': snapshot,
      });
      await client.auth.refreshSession();
      if (client.auth.currentUser?.id != accountId) {
        throw StateError('The signed-in account changed during guest sync.');
      }
      await guest.stopAfterSync();
    } finally {
      guest.setSyncing(false);
    }
  }
}

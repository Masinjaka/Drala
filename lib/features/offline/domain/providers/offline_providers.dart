import 'dart:async';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_sync_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offlineSyncManagerProvider = Provider<OfflineSyncManager?>((ref) => null);
final offlineSyncEventsProvider = StreamProvider<int>((ref) {
  final manager = ref.watch(offlineSyncManagerProvider);
  if (manager == null) return const Stream.empty();
  final events = StreamController<int>();
  var revision = 0;
  void changed() => events.add(++revision);
  manager.addListener(changed);
  ref.onDispose(() {
    manager.removeListener(changed);
    unawaited(events.close());
  });
  return events.stream;
});
final offlineAccountProvider = Provider<OfflineAccount?>((ref) {
  ref.watch(offlineSyncEventsProvider);
  return ref.watch(offlineSyncManagerProvider)?.account;
});

// Ignore connection-only polls when rebuilding cached account data.
final offlineDataVersionProvider = Provider((ref) {
  ref.watch(offlineSyncEventsProvider);
  final account = ref.watch(offlineSyncManagerProvider)?.account;
  return (account?.id, account?.hydrated, account?.dataVersion);
});

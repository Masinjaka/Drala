import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import '../../offline/support/offline_fixture.dart';

class SettingsSyncTestAccount extends OfflineAccount {
  SettingsSyncTestAccount(OfflineFixture fixture, OfflineConnectivity connectivity)
      : super(fixture.database, fixture.remote, connectivity);

  int retries = 0;

  void present(SyncStatus value, {int pendingChanges = 0}) {
    status = value;
    pending = pendingChanges;
    notifyListeners();
  }

  @override
  Future<void> retry() async {
    retries++;
    present(SyncStatus.online);
  }
}

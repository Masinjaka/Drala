import 'package:budgets/features/guest/data/guest_database.dart';

Future<void> removeOfflineSchema(GuestDatabase database) async {
  await database.customStatement('DROP TABLE offline_state');
  await database.customStatement('DROP TABLE offline_staging');
  await database
      .customStatement('ALTER TABLE guest_profiles DROP COLUMN username');
  await database
      .customStatement('ALTER TABLE guest_profiles DROP COLUMN profile_photo');
}

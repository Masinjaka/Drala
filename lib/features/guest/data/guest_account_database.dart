part of 'guest_database.dart';

// Account files intentionally coexist with the guest file. A distinct runtime
// type keeps Drift's duplicate-instance warning meaningful for each owner.
class _GuestAccountDatabase extends GuestDatabase {
  _GuestAccountDatabase(super.executor, {required String accountId})
      : super._(accountId: accountId);
}

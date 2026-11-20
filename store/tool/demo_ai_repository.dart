import 'package:budgets/features/ai_entry/domain/models/ai_quota.dart';
import 'package:budgets/features/guest/data/guest_ai_entry_repository.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';

/// Seeded local data, shown as a signed-in account with AI entry enabled.
class DemoAiEntryRepository extends GuestAiEntryRepository {
  DemoAiEntryRepository(GuestSession guest)
      : super(guest.repositories.entries, guest.repositories.mutations,
            guest.repositories.wallets);

  @override
  Future<AiQuota> aiQuota() async =>
      const AiQuota(plan: 'free', unlimited: false, remaining: 20);
}

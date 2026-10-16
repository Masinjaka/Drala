import 'package:budgets/features/notifications/data/repositories/empty_finance_notification_repository.dart';
import 'package:budgets/features/notifications/data/repositories/finance_notification_repository_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guest notifications stay local without a Supabase client', () async {
    final repository = FinanceNotificationRepositoryFactory.create(
      isGuest: true,
    );

    expect(repository, isA<EmptyFinanceNotificationRepository>());
    expect(await repository.notifications(), isEmpty);
    await repository.markRead('unused');
  });
}

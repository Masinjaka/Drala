import 'package:budgets/features/notifications/presentation/services/firebase_messaging_bootstrap.dart';
import 'package:budgets/features/notifications/presentation/services/notification_permission_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Debug startup does not initialize Firebase push services', () async {
    await FirebaseMessagingBootstrap.initialize();
    expect(Firebase.apps, isEmpty);
  });

  test('Debug permission checks never require a Firebase app or platform call',
      () async {
    final permissions = NotificationPermissionService();
    expect(await permissions.isGranted(), isFalse);
    expect(await permissions.request(), isFalse);
  });
}

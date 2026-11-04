import 'dart:async';
import 'package:budgets/core/navigation/auth_router_refresh.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
      'offline refresh errors do not redirect and subsequent events still refresh',
      () async {
    final changes = StreamController<Object?>.broadcast();
    final refresh = AuthRouterRefresh(changes.stream);
    var notifications = 0;
    refresh.addListener(() => notifications++);
    changes
        .addError(AuthRetryableFetchException(message: 'Failed host lookup'));
    await Future<void>.delayed(Duration.zero);
    expect(notifications, 0);
    changes.add(AuthChangeEvent.tokenRefreshed);
    await Future<void>.delayed(Duration.zero);
    expect(notifications, 1);
    changes.add(AuthChangeEvent.signedOut);
    await Future<void>.delayed(Duration.zero);
    expect(notifications, 2);
    refresh.dispose();
    await changes.close();
  });
}

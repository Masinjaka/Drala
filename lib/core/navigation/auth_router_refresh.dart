import 'dart:async';

import 'package:budgets/core/auth/auth_state_error_handler.dart';
import 'package:flutter/foundation.dart';

class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(Stream<Object?> authChanges) {
    _subscription = authChanges.listen(
      (_) => notifyListeners(),
      onError: AuthStateErrorHandler.handle,
    );
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

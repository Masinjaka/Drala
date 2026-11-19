import 'dart:async';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';

class RecordingLogoutController extends AuthController {
  int calls = 0;
  Completer<void>? pending;
  @override
  Future<void> signOut() async {
    calls++;
    await pending?.future;
  }
}

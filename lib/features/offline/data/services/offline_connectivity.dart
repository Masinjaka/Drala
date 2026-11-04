import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineConnectivity extends ChangeNotifier {
  bool _offline = false;
  bool get isOffline => _offline;
  static bool isNetworkError(Object error) =>
      error is SocketException ||
      error is TimeoutException ||
      error is http.ClientException ||
      error is AuthRetryableFetchException ||
      error is PostgrestException &&
          {'502', '503', '504', '520', '521', '522', '523', '524'}
              .contains(error.code);
  void failed(Object error) {
    if (isNetworkError(error) && !_offline) {
      _offline = true;
      notifyListeners();
    }
  }

  void recovered() {
    if (!_offline) return;
    _offline = false;
    notifyListeners();
  }
}

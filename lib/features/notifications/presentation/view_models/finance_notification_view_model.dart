import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/domain/repositories/finance_notification_repository.dart';
import 'package:flutter/foundation.dart';

class FinanceNotificationViewModel extends ChangeNotifier {
  FinanceNotificationViewModel(this._repository);

  final FinanceNotificationRepository _repository;
  List<FinanceNotification> _notifications = const [];
  bool _isLoading = false;
  bool _resolved = false;
  bool _loadFailed = false;
  bool _disposed = false;
  int _generation = 0;
  Future<void>? _pending;

  bool get resolved => _resolved;
  bool get awaitingFirstResult => !_resolved && !_loadFailed;

  List<FinanceNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  Future<void> load() {
    final generation = _generation;
    return _pending ??= _load(generation).whenComplete(() {
      if (generation == _generation) _pending = null;
    });
  }

  Future<void> _load(int generation) async {
    _isLoading = true;
    _loadFailed = false;
    notifyListeners();
    try {
      final notifications = await _repository.notifications();
      if (generation != _generation || _disposed) return;
      _notifications = List.unmodifiable(notifications);
      _resolved = true;
    } catch (_) {
      if (generation != _generation || _disposed) return;
      _loadFailed = true;
      rethrow;
    } finally {
      if (generation == _generation && !_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> markRead(FinanceNotification notification) async {
    if (notification.isRead) return;
    final generation = _generation;
    await _repository.markRead(notification.id);
    if (generation != _generation || _disposed) return;
    _notifications = List.unmodifiable(
      _notifications.map(
        (item) =>
            item.id == notification.id ? item.copyWith(isRead: true) : item,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _generation++;
    _pending = null;
    _isLoading = false;
    _resolved = true;
    _loadFailed = false;
    _notifications = const [];
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

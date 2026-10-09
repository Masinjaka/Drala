import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:flutter/foundation.dart';

class MonthlyStatsViewModel extends ChangeNotifier {
  MonthlyStatsViewModel(this._repository, DateTime initialMonth)
      : _month = DateTime(initialMonth.year, initialMonth.month);
  final MonthlyStatsRepository _repository;
  DateTime _month;
  final Map<DateTime, MonthlyStats> _statsByMonth = {};
  final Map<DateTime, Future<void>> _pendingMonths = {};
  bool _disposed = false;
  DateTime get month => _month;
  MonthlyStats? get stats => statsForMonth(_month);
  MonthlyStats? statsForMonth(DateTime month) =>
      _statsByMonth[_normalize(month)];
  bool get isLoading => isMonthLoading(_month);
  bool isMonthLoading(DateTime month) =>
      _pendingMonths.containsKey(_normalize(month)) ||
      statsForMonth(month) == null;
  Future<void> load() => _loadWindow(_month, refreshCurrent: true);
  Future<void> changeMonth(int offset) =>
      selectMonth(DateTime(_month.year, _month.month + offset));
  Future<void> selectMonth(DateTime month) async {
    final candidate = _normalize(month);
    final now = DateTime.now();
    if (candidate.isAfter(DateTime(now.year, now.month))) return;
    _month = candidate;
    notifyListeners();
    await _loadWindow(candidate);
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadWindow(
    DateTime center, {
    bool refreshCurrent = false,
  }) async {
    final months = _monthsAround(center);
    await Future.wait([
      for (final month in months)
        _loadMonth(month, refresh: refreshCurrent && month == center),
    ]);
    final retainedMonths = _monthsAround(_month);
    _statsByMonth.removeWhere(
      (month, _) => !retainedMonths.contains(month),
    );
  }

  List<DateTime> _monthsAround(DateTime center) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    return [
      DateTime(center.year, center.month - 1),
      center,
      if (center.isBefore(currentMonth))
        DateTime(center.year, center.month + 1),
    ];
  }

  Future<void> _loadMonth(DateTime month, {bool refresh = false}) {
    final key = _normalize(month);
    if (!refresh && _statsByMonth.containsKey(key)) {
      return Future.value();
    }
    final pending = _pendingMonths[key];
    if (pending != null) return pending;

    late final Future<void> request;
    request = _repository.statsForMonth(key).then((items) {
      _statsByMonth[key] = items;
    }).whenComplete(() {
      _pendingMonths.remove(key);
      notifyListeners();
    });
    _pendingMonths[key] = request;
    notifyListeners();
    return request;
  }

  DateTime _normalize(DateTime month) => DateTime(month.year, month.month);
}

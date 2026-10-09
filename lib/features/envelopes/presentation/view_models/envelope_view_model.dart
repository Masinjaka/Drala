import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';

class EnvelopeViewModel extends ChangeNotifier {
  EnvelopeViewModel(this._repository, DateTime initialMonth)
      : _month = DateTime(initialMonth.year, initialMonth.month);

  final EnvelopeRepository _repository;
  DateTime _month;
  bool _disposed = false;
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  final Map<DateTime, List<Envelope>> _envelopesByMonth = {};
  final Map<DateTime, Future<void>> _pendingMonths = {};
  List<EnvelopeCategory> _categories = const [];
  bool _isLoadingSharedData = false;
  bool _isSaving = false;
  List<WalletSummary> _wallets = const [];

  DateTime get month => _month;
  List<Envelope> get envelopes => envelopesForMonth(_month);
  List<Envelope> envelopesForMonth(DateTime month) =>
      _envelopesByMonth[_normalize(month)] ?? const [];
  List<EnvelopeCategory> get availableCategories {
    final used = envelopes.map((item) => item.categoryId).toSet();
    return _categories.where((item) => !used.contains(item.id)).toList();
  }

  bool get isLoading => isMonthLoading(_month) || _isLoadingSharedData;
  bool isMonthLoading(DateTime month) {
    final key = _normalize(month);
    return _pendingMonths.containsKey(key) ||
        !_envelopesByMonth.containsKey(key);
  }

  bool get isSaving => _isSaving;
  List<WalletSummary> get wallets => _wallets;
  int get totalBudget =>
      envelopes.fold(0, (total, item) => total + item.amount);
  int get totalSpent => envelopes.fold(0, (total, item) => total + item.spent);

  Future<void> load() async {
    _isLoadingSharedData = true;
    notifyListeners();
    try {
      final values = await Future.wait([
        _repository.expenseCategories(),
        _repository.wallets(),
        _loadWindow(_month, refreshCurrent: true),
      ]);
      _categories = List.unmodifiable(values[0] as List<EnvelopeCategory>);
      _wallets = List.unmodifiable(values[1] as List<WalletSummary>);
    } finally {
      _isLoadingSharedData = false;
      notifyListeners();
    }
  }

  Future<void> changeMonth(int offset) async {
    await selectMonth(DateTime(_month.year, _month.month + offset));
  }

  Future<void> selectMonth(DateTime month) async {
    final candidate = _normalize(month);
    final now = DateTime.now();
    if (candidate.isAfter(DateTime(now.year, now.month))) return;
    _month = candidate;
    notifyListeners();
    await _loadWindow(candidate);
  }

  Future<void> add({
    required String name,
    required String categoryId,
    required int amount,
    String? walletId,
    bool repeatsMonthly = false,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await _repository.addEnvelope(
        name: name,
        categoryId: categoryId,
        amount: amount,
        month: _month,
        walletId: walletId,
        repeatsMonthly: repeatsMonthly,
      );
      await _loadMonth(_month, refresh: true);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  List<EnvelopeCategory> categoriesForEditing(Envelope envelope) => [
        ...availableCategories,
        ..._categories.where((category) => category.id == envelope.categoryId),
      ];

  Future<void> update(
      {required String id,
      required String name,
      required String categoryId,
      required int amount,
      required bool repeatsMonthly}) async {
    await _repository.updateEnvelope(
        id: id,
        name: name,
        categoryId: categoryId,
        amount: amount,
        repeatsMonthly: repeatsMonthly);
    await _loadMonth(_month, refresh: true);
  }

  Future<void> delete(String id) async {
    await _repository.deleteEnvelope(id);
    _envelopesByMonth[_month] = List.unmodifiable(
      envelopes.where((item) => item.id != id),
    );
    notifyListeners();
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
    _envelopesByMonth.removeWhere(
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
    if (!refresh && _envelopesByMonth.containsKey(key)) {
      return Future.value();
    }
    final pending = _pendingMonths[key];
    if (pending != null) return pending;

    late final Future<void> request;
    request = _repository.envelopesForMonth(key).then((items) {
      _envelopesByMonth[key] = List.unmodifiable(items);
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

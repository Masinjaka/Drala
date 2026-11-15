import 'package:budgets/features/ai_entry/domain/repositories/recent_transaction_repository.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:flutter/foundation.dart';

class HomeOverviewViewModel extends ChangeNotifier {
  HomeOverviewViewModel(this._entries, this._envelopes, this.today);
  final AiEntryRepository _entries;
  final EnvelopeRepository? _envelopes;
  final DateTime today;
  List<FinanceEntry> _monthlyEntries = const [];
  List<FinanceEntry> _recentEntries = const [];
  List<Envelope> _envelopePreview = const [];
  bool _isLoading = true;
  bool _entriesResolved = false;
  bool _envelopesResolved = false;
  bool get entriesResolved => _entriesResolved;
  bool get envelopesResolved => _envelopesResolved;
  int _generation = 0;
  Object? _error;
  List<FinanceEntry> get monthlyEntries => _monthlyEntries;
  List<FinanceEntry> get recentEntries => _recentEntries;
  List<Envelope> get envelopes => _envelopePreview;
  bool get isLoading => _isLoading;
  Object? get error => _error;
  bool _disposed = false;
  Future<void>? _pending;

  Future<void> load() {
    final generation = _generation;
    return _pending ??= _load(generation).whenComplete(() {
      if (generation == _generation) _pending = null;
    });
  }

  void clear() {
    _generation++;
    _pending = null;
    _monthlyEntries = const [];
    _recentEntries = const [];
    _envelopePreview = const [];
    _entriesResolved = false;
    _envelopesResolved = false;
    _isLoading = true;
    _error = null;
    _notify();
  }

  Future<void> _load(int generation) async {
    _isLoading = true;
    _error = null;
    _notify();
    try {
      await Future.wait([_loadEntries(generation), _loadEnvelopes(generation)]);
    } catch (failure) {
      if (generation == _generation) _error = failure;
    } finally {
      if (generation == _generation) {
        _isLoading = false;
        _notify();
      }
    }
  }

  Future<void> _loadEntries(int generation) async {
    final month = DateTime(today.year, today.month);
    final repository = _entries;
    final supportsRecent = repository is RecentTransactionRepository;
    final results = await Future.wait([
      repository.entriesForMonth(month),
      if (supportsRecent)
        (repository as RecentTransactionRepository)
            .recentTransactions(limit: 4),
    ]);
    final current = results.first;
    final recent = supportsRecent
        ? [...results[1]]
        : current.where((entry) => !entry.isTransfer).toList();
    if (!supportsRecent && recent.length < 4) {
      recent.addAll((await repository.entriesForMonth(
        DateTime(today.year, today.month - 1),
      ))
          .where((entry) => !entry.isTransfer));
    }
    final unique =
        {for (final entry in recent) entry.id: entry}.values.toList();
    unique.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (generation != _generation || _disposed) return;
    _monthlyEntries = List.unmodifiable(current);
    _recentEntries = List.unmodifiable(unique.take(4));
    _entriesResolved = true;
    _notify();
  }

  Future<void> _loadEnvelopes(int generation) async {
    final values = await _envelopes?.envelopesForMonth(today) ?? <Envelope>[];
    if (generation != _generation || _disposed) return;
    _envelopePreview = List.unmodifiable(values.take(2));
    _envelopesResolved = true;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

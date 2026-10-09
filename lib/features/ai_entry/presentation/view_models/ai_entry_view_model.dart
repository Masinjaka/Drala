import 'package:budgets/features/ai_entry/domain/errors/ai_entry_exception.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_edit_changes.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_quota.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/ai_entry/domain/repositories/paged_ai_entry_repository.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/receipt_input_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/receipts/domain/repositories/receipt_repository.dart';
import 'package:flutter/material.dart';

part 'ai_entry_data_reset.dart';
part 'ai_entry_loading.dart';
part 'ai_entry_edit.dart';
part 'ai_entry_monthly_totals.dart';
part 'ai_entry_receipt.dart';
part 'ai_entry_result_application.dart';
part 'ai_entry_wallets.dart';

class AiEntryViewModel extends ChangeNotifier {
  AiEntryViewModel(
    this._repository,
    DateTime initialDate, {
    ReceiptRepository? receiptRepository,
    Duration submissionTimeout = const Duration(seconds: 45),
  })  : _submissionTimeout = submissionTimeout,
        _receiptRepository = receiptRepository,
        _selectedDate = DateUtils.dateOnly(initialDate);

  final AiEntryRepository _repository;
  final ReceiptRepository? _receiptRepository;
  final Duration _submissionTimeout;
  DateTime _selectedDate;
  List<FinanceEntry> _entries = const [];
  List<FinanceEntry> _monthlyEntries = const [];
  DateTime? _monthlyEntriesMonth;
  bool _isLoading = false;
  bool _isSummaryLoading = false;
  bool _isSubmitting = false;
  bool _isEditing = false;
  Map<String, FinanceEntryEditChanges> _pendingEdits = const {};
  AiQuota? _quota;
  List<WalletSummary> _wallets = const [];
  bool _walletsLoaded = false;
  bool _isAddingWallet = false;
  int _totalFunds = 0;
  bool? _hasAnyEntries;
  bool _hasMoreEntries = false;
  bool _isLoadingMoreEntries = false;
  int _transactionOffset = 0;
  int _transferOffset = 0;
  int _loadGeneration = 0;

  DateTime get selectedDate => _selectedDate;
  List<FinanceEntry> get entries => _entries;
  num get monthlyIncome => _monthlyTotal((entry) => entry.isIncome);
  num get monthlyExpenses => _monthlyTotal((entry) => entry.isExpense);
  bool get isLoading => _isLoading;
  bool get hasMoreEntries => _hasMoreEntries;
  bool get isLoadingMoreEntries => _isLoadingMoreEntries;
  bool get isSummaryLoading => _isSummaryLoading;
  bool get isSubmitting => _isSubmitting || _isEditing;
  bool get isAddingEntry => _isSubmitting;
  Map<String, FinanceEntryEditChanges> get pendingEdits => _pendingEdits;
  int? get remainingRequests => _quota?.remaining;
  bool get hasUnlimitedAiRequests => _quota?.unlimited ?? false;
  List<WalletSummary> get wallets => _wallets;
  bool get isAddingWallet => _isAddingWallet;
  int get totalWalletBalance => _totalFunds;
  bool get isFirstEntryExperience => _hasAnyEntries == false;
  String get walletCurrencyCode =>
      _wallets.isEmpty ? 'MGA' : _wallets.first.currencyCode;

  Future<AiEntryResult> submit(
    String message, {
    String outputLanguage = 'en',
  }) async {
    final targetDate = _selectedDate;
    _isSubmitting = true;
    notifyListeners();
    try {
      final result = await _waitForSubmission(
        _repository.processMessage(
          message.trim(),
          targetDate: targetDate,
          outputLanguage: outputLanguage,
        ),
      );
      await _applyResult(result, targetDate);
      notifyListeners();
      return result;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<AiEntryResult> resumeMessage({
    required String requestId,
    required Map<String, dynamic> extraction,
    String? walletId,
    required bool useAllWallets,
  }) async {
    final targetDate = _selectedDate;
    _isSubmitting = true;
    notifyListeners();
    try {
      final result = await _waitForSubmission(
        _repository.resumeMessage(
          requestId: requestId,
          extraction: extraction,
          walletId: walletId,
          useAllWallets: useAllWallets,
          targetDate: targetDate,
        ),
      );
      await _applyResult(result, targetDate);
      return result;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> cancelPendingRequest(String requestId) =>
      _repository.cancelPendingRequest(requestId);

  Future<List<ManualEntryCategory>> manualEntryCategories() =>
      _repository.manualEntryCategories();

  Future<FinanceEntry> addManualEntry(ManualEntryInput input) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      final entry = await _repository.addManualEntry(input);
      _hasAnyEntries = true;
      if (DateUtils.isSameDay(_selectedDate, input.occurredAt)) {
        _entries = _mergeNewEntries([entry], _entries);
      }
      _mergeMonthlyEntries([entry]);
      await refreshBalances();
      notifyListeners();
      return entry;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  int get _walletBalance =>
      _wallets.fold(0, (total, wallet) => total + wallet.balance);

  void _notify() => notifyListeners();

  void _notifyDataReset() => _notify();

  void _notifyReceiptChanged() => _notify();

  Future<T> _waitForSubmission<T>(Future<T> operation) => operation.timeout(
        _submissionTimeout,
        onTimeout: () => throw AiEntryException(
          code: 'request_timeout',
          message: 'The AI request took too long. Please try again.',
          status: 504,
        ),
      );
}

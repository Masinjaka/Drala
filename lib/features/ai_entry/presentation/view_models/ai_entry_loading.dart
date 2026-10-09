part of 'ai_entry_view_model.dart';

extension AiEntryLoading on AiEntryViewModel {
  static const _pageSize = 20;

  Future<void> loadDate(DateTime date) async {
    final generation = ++_loadGeneration;
    _selectedDate = DateUtils.dateOnly(date);
    final selectedDate = _selectedDate;
    final targetMonth = DateTime(selectedDate.year, selectedDate.month);
    final shouldLoadMonth = _monthlyEntriesMonth == null ||
        _monthlyEntriesMonth!.year != targetMonth.year ||
        _monthlyEntriesMonth!.month != targetMonth.month;
    _entries = const [];
    _isLoading = true;
    _isLoadingMoreEntries = false;
    _hasMoreEntries = false;
    _transactionOffset = 0;
    _transferOffset = 0;
    _isSummaryLoading = shouldLoadMonth;
    _notify();
    final quotaFuture = _quota == null
        ? _repository.aiQuota().then<AiQuota?>((quota) => quota).catchError(
              (_) => null,
            )
        : Future<AiQuota?>.value(_quota);
    final walletsFuture = _walletsLoaded && !shouldLoadMonth
        ? Future<List<WalletSummary>?>.value(_wallets)
        : _repository
            .wallets()
            .then<List<WalletSummary>?>((wallets) => wallets)
            .catchError((_) => null);
    final totalFuture = walletsFuture
        .then((_) => _repository.totalFunds())
        .then<int?>((value) => value)
        .catchError((_) => null);
    final historyFuture = _hasAnyEntries == null
        ? _repository
            .hasAnyEntries()
            .then<bool?>((value) => value)
            .catchError((_) => null)
        : Future<bool?>.value(_hasAnyEntries);
    final monthlyEntriesFuture = !shouldLoadMonth
        ? Future<List<FinanceEntry>?>.value(null)
        : _repository
            .entriesForMonth(targetMonth)
            .then<List<FinanceEntry>?>((entries) => entries)
            .catchError((_) => null);
    try {
      final repository = _repository;
      if (repository is PagedAiEntryRepository) {
        final page =
            await (repository as PagedAiEntryRepository).entriesForDatePage(
          selectedDate,
          limit: _pageSize,
          transactionOffset: 0,
          transferOffset: 0,
        );
        if (generation != _loadGeneration) return;
        _applyPage(page);
      } else {
        _entries = await repository.entriesForDate(selectedDate);
        if (generation != _loadGeneration) return;
      }
      _isLoading = false;
      _notify();
      final monthlyEntries = await monthlyEntriesFuture;
      if (generation != _loadGeneration) return;
      if (monthlyEntries != null) {
        _monthlyEntries = List.unmodifiable(monthlyEntries);
        _monthlyEntriesMonth = targetMonth;
      }
      final hasHistory = await historyFuture;
      _hasAnyEntries = _entries.isNotEmpty || (hasHistory ?? true);
      _quota = await quotaFuture;
      final wallets = await walletsFuture;
      if (wallets != null) {
        _wallets = List.unmodifiable(wallets);
        _walletsLoaded = true;
      }
      _totalFunds = await totalFuture ?? _walletBalance;
    } finally {
      if (generation == _loadGeneration) {
        _isLoading = false;
        _isSummaryLoading = false;
        _notify();
      }
    }
  }

  Future<void> loadMoreEntries() async {
    final repository = _repository;
    if (repository is! PagedAiEntryRepository ||
        _isLoading ||
        _isLoadingMoreEntries ||
        !_hasMoreEntries) {
      return;
    }
    final generation = _loadGeneration;
    _isLoadingMoreEntries = true;
    _notify();
    try {
      final page =
          await (repository as PagedAiEntryRepository).entriesForDatePage(
        _selectedDate,
        limit: _pageSize,
        transactionOffset: _transactionOffset,
        transferOffset: _transferOffset,
      );
      if (generation != _loadGeneration) return;
      final existingIds = _entries.map((entry) => entry.id).toSet();
      _entries = List.unmodifiable([
        ..._entries,
        ...page.entries.where((entry) => existingIds.add(entry.id)),
      ]);
      _applyPage(page, replaceEntries: false);
    } catch (error) {
      debugPrint('Error loading more entries: $error');
    } finally {
      if (generation == _loadGeneration) {
        _isLoadingMoreEntries = false;
        _notify();
      }
    }
  }

  void _applyPage(FinanceEntryPage page, {bool replaceEntries = true}) {
    if (replaceEntries) _entries = page.entries;
    _transactionOffset = page.transactionOffset;
    _transferOffset = page.transferOffset;
    _hasMoreEntries = page.hasMore;
  }
}

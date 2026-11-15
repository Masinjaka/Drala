part of 'ai_entry_view_model.dart';

extension AiEntryLoading on AiEntryViewModel {
  Future<void> reloadCachedData() {
    _monthlyEntriesMonth = null;
    _quota = null;
    return loadDate(_selectedDate);
  }

  static const _pageSize = 20;

  Future<void> loadDate(DateTime date) async {
    final generation = ++_loadGeneration;
    final balanceGeneration = ++_balanceGeneration;
    final sameDate = DateUtils.isSameDay(_selectedDate, date);
    _selectedDate = DateUtils.dateOnly(date);
    final selectedDate = _selectedDate;
    final targetMonth = DateTime(selectedDate.year, selectedDate.month);
    final shouldLoadMonth = _monthlyEntriesMonth == null ||
        _monthlyEntriesMonth!.year != targetMonth.year ||
        _monthlyEntriesMonth!.month != targetMonth.month;
    if (!sameDate) {
      _entries = const [];
      _entriesResolved = false;
      _hasMoreEntries = false;
      _transactionOffset = 0;
      _transferOffset = 0;
    }
    _entriesLoadFailed = false;
    _isLoading = true;
    _isLoadingMoreEntries = false;
    _isSummaryLoading = shouldLoadMonth;
    _notify();
    final quotaFuture =
        _quota == null ? refreshAiQuota() : Future<void>.value();
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
    final balances = walletsFuture.then((wallets) async {
      final total = await totalFuture;
      if (_disposed || balanceGeneration != _balanceGeneration) return;
      if (wallets != null) {
        _wallets = List.unmodifiable(wallets);
        _walletsLoaded = true;
      }
      _totalFunds = total ?? _walletBalance;
      _notify();
    });
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
        if (_disposed || generation != _loadGeneration) return;
        _applyPage(page);
      } else {
        final entries = await repository.entriesForDate(selectedDate);
        if (_disposed || generation != _loadGeneration) return;
        _entries = entries;
      }
      _entriesResolved = true;
      _isLoading = false;
      _notify();
      final monthlyEntries = await monthlyEntriesFuture;
      if (_disposed || generation != _loadGeneration) return;
      if (monthlyEntries != null) {
        _monthlyEntries = List.unmodifiable(monthlyEntries);
        _monthlyEntriesMonth = targetMonth;
      }
      final hasHistory = await historyFuture;
      if (_disposed || generation != _loadGeneration) return;
      _hasAnyEntries = _entries.isNotEmpty || (hasHistory ?? true);
      await quotaFuture;
      if (_disposed || generation != _loadGeneration) return;
      await balances;
    } catch (_) {
      if (_disposed || generation != _loadGeneration) return;
      _entriesLoadFailed = true;
      rethrow;
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
      if (_disposed || generation != _loadGeneration) return;
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

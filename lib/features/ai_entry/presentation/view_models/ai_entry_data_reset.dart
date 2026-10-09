part of 'ai_entry_view_model.dart';

extension AiEntryDataReset on AiEntryViewModel {
  Future<void> resetAfterDataDeletion() async {
    _loadGeneration++;
    _entries = const [];
    _hasMoreEntries = false;
    _isLoadingMoreEntries = false;
    _transactionOffset = 0;
    _transferOffset = 0;
    _monthlyEntries = const [];
    _monthlyEntriesMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _isSummaryLoading = false;
    _wallets = List.unmodifiable(
      _wallets.where((wallet) => wallet.isDefault).map(_emptyWallet),
    );
    _walletsLoaded = false;
    _totalFunds = 0;
    _quota = null;
    _hasAnyEntries = false;
    _notifyDataReset();

    final results = await Future.wait<Object>([
      _repository.wallets(),
      _repository.totalFunds(),
      _repository.aiQuota(),
    ]);
    _wallets = List.unmodifiable(results[0] as List<WalletSummary>);
    _totalFunds = results[1] as int;
    _quota = results[2] as AiQuota;
    _walletsLoaded = true;
    _notifyDataReset();
  }

  WalletSummary _emptyWallet(WalletSummary wallet) => WalletSummary(
        id: wallet.id,
        name: wallet.name,
        balance: 0,
        currencyCode: wallet.currencyCode,
        iconKey: wallet.iconKey,
        isDefault: true,
      );
}

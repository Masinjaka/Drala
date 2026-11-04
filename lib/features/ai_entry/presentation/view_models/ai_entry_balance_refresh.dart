part of 'ai_entry_view_model.dart';

extension AiEntryBalanceRefresh on AiEntryViewModel {
  Future<void> _refreshCommittedBalances(int generation) async {
    final timing = AiRequestTiming('post_commit_wallet_refresh');
    var succeeded = false;
    try {
      final wallets =
          await _repository.wallets().timeout(_balanceRefreshTimeout);
      succeeded = true;
      if (_disposed || generation != _balanceGeneration) return;
      _wallets = List.unmodifiable(wallets);
      _walletsLoaded = true;
      _totalFunds = _walletBalance;
      _notify();
    } catch (error) {
      // The entry is already committed. Do not report failure or invite a retry.
      DevelopmentLog.error('refresh balances after AI save', error);
    } finally {
      timing.finish(succeeded: succeeded);
    }
  }
}

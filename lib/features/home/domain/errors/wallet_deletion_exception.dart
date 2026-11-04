class WalletDeletionException implements Exception {
  const WalletDeletionException.inUse() : reason = WalletDeletionReason.inUse;
  const WalletDeletionException.defaultWallet()
      : reason = WalletDeletionReason.defaultWallet;

  final WalletDeletionReason reason;
}

enum WalletDeletionReason { inUse, defaultWallet }

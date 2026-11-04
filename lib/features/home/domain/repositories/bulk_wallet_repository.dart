abstract interface class BulkWalletRepository {
  Future<void> deleteWallets(List<String> ids);
}

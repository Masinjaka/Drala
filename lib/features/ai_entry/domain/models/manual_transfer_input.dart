class ManualTransferInput {
  const ManualTransferInput(
      {required this.id,
      required this.fromWalletId,
      required this.toWalletId,
      required this.amount,
      required this.occurredAt,
      this.description = ''});
  final String id;
  final String fromWalletId;
  final String toWalletId;
  final int amount;
  final DateTime occurredAt;
  final String description;
}

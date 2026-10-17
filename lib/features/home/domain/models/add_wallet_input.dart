class AddWalletInput {
  const AddWalletInput({
    required this.name,
    required this.initialBalance,
    this.setAsDefault = false,
  });

  final String name;
  final int initialBalance;
  final bool setAsDefault;
}

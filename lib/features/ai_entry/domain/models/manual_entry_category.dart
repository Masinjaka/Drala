class ManualEntryCategory {
  const ManualEntryCategory({
    required this.id,
    required this.name,
    required this.emoji,
    this.iconKey = '',
    required this.transactionType,
    this.colorHex,
  });

  factory ManualEntryCategory.fromJson(Map<String, dynamic> json) {
    return ManualEntryCategory(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? 'Other',
      emoji: (json['emoji'] as String?) ?? '',
      iconKey: (json['icon_key'] as String?) ?? '',
      transactionType: (json['transaction_type'] as String?) ?? 'expense',
      colorHex: json['color'] as String?,
    );
  }

  final String id;
  final String name;
  final String emoji;
  final String iconKey;
  final String transactionType;
  final String? colorHex;
}

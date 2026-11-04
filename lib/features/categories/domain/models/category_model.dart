import 'package:budgets/core/enums/transaction_type.dart';

class Category {
  final String? id;
  final String? name;
  final String? emoji;
  final String? iconKey;
  final String? color; // Added nullable color attribute
  final TransactionType? transactionType;

  Category({
    this.id,
    this.name,
    this.emoji,
    this.iconKey,
    this.color,
    this.transactionType,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String?,
      name: map['name'] as String?,
      emoji: map['emoji'] as String?,
      iconKey: map['icon_key'] as String?,
      color: map['color'] as String?, // Added color mapping
      transactionType:
          TransactionType.fromValue(map['transaction_type'] as String?),
    );
  }

  Category copyWith({
    String? id,
    String? name,
    String? emoji,
    String? iconKey,
    String? color, // Added color to copyWith
    TransactionType? transactionType,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color, // Added color to copyWith
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      if (iconKey != null) 'icon_key': iconKey,
      'color': color, // Added color to toMap
      'transaction_type': transactionType?.value,
    };
  }
}

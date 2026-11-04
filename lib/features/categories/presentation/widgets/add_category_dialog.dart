import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({required this.transactionType, super.key});
  final TransactionType transactionType;

  static Future<Category?> show(BuildContext context,
          {required TransactionType transactionType}) =>
      CategoryEditorSheet.show(context, type: transactionType);

  @override
  Widget build(BuildContext context) =>
      CategoryEditorSheet(type: transactionType);
}

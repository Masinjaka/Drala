import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/category_model.dart';
import '../../domain/providers/category_provider.dart';

class CategoryModule {
  // Add properties and methods as needed
  CategoryModule();

  // Example method
  void initialize() {
    // Initialization logic here
  }

  Future<void> addCategory(
    WidgetRef ref, {
    required String name,
    required String? emoji,
    required String color,
    TransactionType? transactionType,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      if (emoji == null || emoji.isEmpty) {
        showInfoToast(context, "L'emoticon est requis");
        return;
      }
      try {
        await ref.read(categoriesProvider.notifier).addSomeCategory(
              Category(
                name: name,
                emoji: emoji,
                color: color,
                transactionType: transactionType,
              ),
            );

        if (!context.mounted) return;
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        showErrorToast(context, e);
      }
    }
  }

  Future<void> editCategory(
    WidgetRef ref, {
    required String id,
    required String name,
    required String? emoji,
    required String color,
    TransactionType? transactionType,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      if (emoji == null || emoji.isEmpty) {
        showInfoToast(context, "L'emoticon est requis");
        return;
      }
      try {
        await ref.read(categoriesProvider.notifier).editSomeCategory(
              Category(
                id: id,
                name: name,
                emoji: emoji,
                color: color,
                // transactionType: transactionType,
              ),
            );

        if (!context.mounted) return;
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        showErrorToast(context, e);
      }
    }
  }

  Future<void> deleteCategory(
      WidgetRef ref, Category category, BuildContext context) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteCategoryQuestion,
      message: context.l10n.deleteCategoryDescription,
    );

    if (confirmed) {
      try {
        await ref
            .read(categoriesProvider.notifier)
            .deleteSomeCategory(category);
        if (!context.mounted) return;
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        showErrorToast(context, e);
      }
    }
  }
}

import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showCategoryDeleteErrorToast(BuildContext context, Object error) {
  final inUse = error is StateError &&
          error.message.toLowerCase().contains('category is in use') ||
      error is PostgrestException && error.code == '23503';
  if (inUse) {
    showAppToast(
      context,
      context.l10n.categoryInUse,
      type: AppToastType.info,
    );
    return;
  }
  showErrorToast(context, error);
}

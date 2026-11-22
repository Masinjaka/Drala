import 'package:budgets/features/ai_entry/presentation/ai_entry_error_message.dart';
import 'package:budgets/features/offline/domain/models/offline_unavailable_exception.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/monitoring/development_log.dart';

import '../utils/error_messages.dart';
import '../utils/finance_error_message.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'app_toast_overlay.dart';
import 'app_toast_type.dart';

export 'app_toast_type.dart';

OverlayEntry? _activeToast;

void showAppToast(
  BuildContext context,
  String message, {
  AppToastType type = AppToastType.info,
}) {
  final overlay = Navigator.of(context, rootNavigator: true).overlay;
  if (overlay == null) return;
  _activeToast?.remove();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => AppToastOverlay(
      message: message,
      type: type,
      sourceContext: context,
      onDisposed: () {
        if (_activeToast == entry) _activeToast = null;
      },
      onDismissed: () {
        if (_activeToast != entry) return;
        entry.remove();
        _activeToast = null;
      },
    ),
  );
  _activeToast = entry;
  overlay.insert(entry);
}

void showSuccessToast(BuildContext context, String message) {
  showAppToast(context, message, type: AppToastType.success);
}

void showInfoToast(BuildContext context, String message) {
  showAppToast(context, message, type: AppToastType.info);
}

void showErrorToast(BuildContext context, Object error) {
  DevelopmentLog.error('toast error', error);
  showAppToast(
    context,
    (error is OfflineUnavailableException
            ? error.needsDownload
                ? context.l10n.offlineInitial
                : context.l10n.onlineRequired
            : null) ??
        financeErrorMessage(error, context.l10n) ??
        aiEntryErrorMessage(error, context.l10n) ??
        friendlyErrorMessage(error, context.l10n),
    type: AppToastType.error,
  );
}

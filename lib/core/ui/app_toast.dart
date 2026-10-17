import 'package:flutter/material.dart';
import 'package:budgets/core/monitoring/development_log.dart';

import '../utils/error_messages.dart';
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
  final aboveNavigationBar = _hasBottomNavigationBar(context);
  _activeToast?.remove();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => AppToastOverlay(
      message: message,
      type: type,
      aboveNavigationBar: aboveNavigationBar,
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
    friendlyErrorMessage(error),
    type: AppToastType.error,
  );
}

bool _hasBottomNavigationBar(BuildContext context) {
  var found = false;
  context.visitAncestorElements((element) {
    final widget = element.widget;
    if (widget is Scaffold && widget.bottomNavigationBar != null) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

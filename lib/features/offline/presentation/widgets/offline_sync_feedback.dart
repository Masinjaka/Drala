import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/offline/data/services/offline_sync_manager.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class OfflineSyncFeedback extends StatefulWidget {
  const OfflineSyncFeedback(
      {required this.manager,
      required this.navigatorKey,
      required this.child,
      super.key});
  final OfflineSyncManager? manager;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
  @override
  State<OfflineSyncFeedback> createState() => _OfflineSyncFeedbackState();
}

class _OfflineSyncFeedbackState extends State<OfflineSyncFeedback> {
  bool? _offline;
  @override
  void initState() {
    super.initState();
    widget.manager?.addListener(_changed);
    _changed();
  }

  void _changed() {
    final offline = widget.manager?.connectivity.isOffline;
    if (offline == null || offline == _offline) return;
    final previous = _offline;
    _offline = offline;
    if (!offline && previous == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final context = widget.navigatorKey.currentState?.overlay?.context;
      if (context == null) return;
      showInfoToast(
          context,
          offline
              ? context.l10n.offlineModeToast
              : widget.manager?.account?.status == SyncStatus.online
                  ? context.l10n.onlineModeToast
                  : context.l10n.onlinePendingToast);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    widget.manager?.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

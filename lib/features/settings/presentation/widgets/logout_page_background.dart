import 'package:flutter/material.dart';

/// Retains the painted page while logout replaces account-backed content.
class LogoutPageBackground extends StatefulWidget {
  const LogoutPageBackground({required this.child, super.key});

  final Widget child;

  static Future<void> hold(
      BuildContext context, Future<void> Function() operation) async {
    final background =
        context.findAncestorStateOfType<_LogoutPageBackgroundState>();
    if (background == null) return operation();
    background._snapshot.allowSnapshotting = true;
    try {
      // Capture the current Settings page before sign-out changes providers.
      await WidgetsBinding.instance.endOfFrame;
      await operation();
      await WidgetsBinding.instance.endOfFrame;
    } finally {
      if (background.mounted) background._snapshot.allowSnapshotting = false;
    }
  }

  @override
  State<LogoutPageBackground> createState() => _LogoutPageBackgroundState();
}

class _LogoutPageBackgroundState extends State<LogoutPageBackground> {
  final _snapshot = SnapshotController();

  @override
  void dispose() {
    _snapshot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
      child: SnapshotWidget(controller: _snapshot, child: widget.child));
}

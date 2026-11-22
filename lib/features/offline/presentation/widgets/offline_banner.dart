import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_banner_bar.dart';
import 'package:flutter/material.dart';

/// Shows a dismissible banner above every page while the app is offline.
///
/// A dismissal lasts until the connection comes back, so the banner returns
/// the next time the connection drops.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner(
      {required this.connectivity, required this.child, super.key});

  final OfflineConnectivity? connectivity;
  final Widget child;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    widget.connectivity?.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant OfflineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connectivity == widget.connectivity) return;
    oldWidget.connectivity?.removeListener(_changed);
    widget.connectivity?.addListener(_changed);
  }

  void _changed() => setState(() {
        if (widget.connectivity?.isOffline != true) _dismissed = false;
      });

  @override
  void dispose() {
    widget.connectivity?.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.connectivity?.isOffline == true && !_dismissed;
    // The banner slot always exists so the app below never changes position
    // in the tree, which would rebuild the navigator and lose page state.
    return Column(children: [
      visible
          ? OfflineBannerBar(
              onDismiss: () => setState(() => _dismissed = true))
          : const SizedBox.shrink(),
      Expanded(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: visible,
          child: widget.child,
        ),
      ),
    ]);
  }
}

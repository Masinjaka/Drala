import 'dart:async';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter/material.dart';

class AiQuotaRefreshScope extends StatefulWidget {
  const AiQuotaRefreshScope(
      {required this.viewModel,
      required this.enabled,
      required this.child,
      super.key});
  final AiEntryViewModel viewModel;
  final bool enabled;
  final Widget child;
  @override
  State<AiQuotaRefreshScope> createState() => _AiQuotaRefreshScopeState();
}

class _AiQuotaRefreshScopeState extends State<AiQuotaRefreshScope>
    with WidgetsBindingObserver {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    if (!widget.enabled) return;
    final now = DateTime.now().toUtc();
    final next = DateTime.utc(now.year, now.month, now.day + 1);
    _timer = Timer(next.difference(now) + const Duration(seconds: 1), () {
      widget.viewModel.refreshAiQuota();
      _schedule();
    });
  }

  @override
  void didUpdateWidget(AiQuotaRefreshScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.viewModel != widget.viewModel) {
      if (widget.enabled) widget.viewModel.refreshAiQuota();
      _schedule();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && widget.enabled) {
      widget.viewModel.refreshAiQuota();
      _schedule();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

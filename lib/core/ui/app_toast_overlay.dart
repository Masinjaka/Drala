import 'dart:async';

import 'package:budgets/core/ui/app_toast_theme.dart';
import 'package:budgets/core/ui/app_toast_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppToastOverlay extends StatefulWidget {
  const AppToastOverlay({
    required this.message,
    required this.type,
    required this.onDismissed,
    required this.onDisposed,
    this.aboveNavigationBar = false,
    this.displayDuration = const Duration(milliseconds: 3000),
    this.animationDuration = const Duration(milliseconds: 220),
    super.key,
  });

  final String message;
  final AppToastType type;
  final bool aboveNavigationBar;
  final VoidCallback onDismissed;
  final VoidCallback onDisposed;
  final Duration displayDuration;
  final Duration animationDuration;

  @override
  State<AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<AppToastOverlay> {
  Timer? _dismissTimer;
  bool _isExiting = false;

  void _startDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(widget.displayDuration, _dismiss);
  }

  void _dismiss() {
    if (!mounted || _isExiting) return;
    _dismissTimer?.cancel();
    setState(() => _isExiting = true);
  }

  void _finishDismissal(AnimationController _) {
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    widget.onDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final navigation = widget.aboveNavigationBar && keyboard == 0
        ? 57 + (safeBottom > 16 ? safeBottom : 16)
        : safeBottom;
    return Positioned(
      left: 30,
      right: 30,
      bottom: keyboard + navigation + 12,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _buildToast(context),
      ),
    );
  }

  Widget _buildToast(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppToastTheme>() ??
        (theme.brightness == Brightness.dark
            ? AppToastTheme.dark
            : AppToastTheme.light);
    final accent = switch (widget.type) {
      AppToastType.success => colors.success,
      AppToastType.error => colors.error,
      AppToastType.info => colors.info,
    };
    final icon = switch (widget.type) {
      AppToastType.success => Icons.check_rounded,
      AppToastType.error => Icons.priority_high_rounded,
      AppToastType.info => Icons.info_rounded,
    };
    final toast = Material(
      type: MaterialType.transparency,
      child: Semantics(
        liveRegion: true,
        child: Container(
          key: const Key('app-toast'),
          constraints: const BoxConstraints(maxWidth: 520, minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: accent,
                child: Icon(icon, color: colors.iconForeground, size: 16),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  widget.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                key: const Key('app-toast-close'),
                onPressed: _dismiss,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: Icon(Icons.cancel_outlined, color: colors.foreground),
              ),
            ],
          ),
        ),
      ),
    );

    if (_isExiting) {
      return toast
          .animate(
              key: const Key('app-toast-exit'), onComplete: _finishDismissal)
          .fadeOut(duration: widget.animationDuration, curve: Curves.easeIn)
          .slideY(
            begin: 0,
            end: 1,
            duration: widget.animationDuration,
            curve: Curves.easeIn,
          );
    }

    return toast
        .animate(
            key: const Key('app-toast-enter'),
            onComplete: (_) => _startDismissTimer())
        .fadeIn(duration: widget.animationDuration, curve: Curves.easeOut)
        .slideY(
          begin: 1,
          end: 0,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
        );
  }
}

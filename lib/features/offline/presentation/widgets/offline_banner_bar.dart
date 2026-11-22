import 'package:budgets/core/ui/app_offline_banner_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The yellow strip itself; it also fills the status bar area above it.
class OfflineBannerBar extends StatelessWidget {
  const OfflineBannerBar({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final foreground = AppOfflineBannerTheme.foreground(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        key: const Key('offline-banner'),
        color: AppOfflineBannerTheme.background(context),
        child: SafeArea(
          bottom: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minHeight: AppOfflineBannerTheme.minHeight),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Row(children: [
                Icon(Icons.wifi_off_rounded,
                    size: AppOfflineBannerTheme.iconSize, color: foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(context.l10n.offlineBannerMessage,
                        style: AppOfflineBannerTheme.message(context)),
                  ),
                ),
                // No tooltip: the banner sits above the navigator's overlay.
                Semantics(
                  button: true,
                  label: context.l10n.dismissOfflineBanner,
                  excludeSemantics: true,
                  child: IconButton(
                    key: const Key('offline-banner-dismiss'),
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close_rounded),
                    iconSize: AppOfflineBannerTheme.iconSize,
                    color: foreground,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_finance_surface_theme.dart';
import 'finance_sheet_scope.dart';

class AppSheetSurface extends StatelessWidget {
  const AppSheetSurface(
      {required this.child,
      this.height,
      this.heightFactor,
      this.keyboardAware = false,
      this.surfaceKey = const ValueKey('app-sheet-surface'),
      super.key})
      : assert(height != null || heightFactor != null);
  final Widget child;
  final double? height;
  final double? heightFactor;
  final bool keyboardAware;
  final Key surfaceKey;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, bounds) {
        final media = MediaQuery.of(context);
        final keyboard = keyboardAware ? media.viewInsets.bottom : 0.0;
        final available =
            math.max(0.0, bounds.maxHeight - keyboard - media.padding.top - 8);
        final resolved =
            math.min(height ?? media.size.height * heightFactor!, available);
        return Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SizedBox(
                height: resolved,
                width: double.infinity,
                child: Material(
                  key: surfaceKey,
                  color: AppFinanceSurfaceTheme.background(context),
                  borderRadius: AppFinanceSurfaceTheme.sheetRadius,
                  clipBehavior: Clip.antiAlias,
                  child: FinanceSheetScope(
                      child: SafeArea(top: false, child: child)),
                ),
              ),
            ),
          ),
        );
      });
}

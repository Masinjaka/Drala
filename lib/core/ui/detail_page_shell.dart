import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/detail_enter_transition.dart';

class DetailPageShell extends StatelessWidget {
  const DetailPageShell(
      {required this.title,
      required this.child,
      this.bottomNavigationBar,
      this.maxWidth = 520,
      this.onAdd,
      this.showBackButton = true,
      this.showGrid = true,
      this.backgroundColor,
      super.key});
  final Color? backgroundColor;
  final bool showGrid;
  final String title;
  final bool showBackButton;
  final Widget child;
  final Widget? bottomNavigationBar;
  final double maxWidth;
  final VoidCallback? onAdd;
  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
        bottom: false,
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(children: [
                  Padding(
                      padding: AppPageSpacing.insets(context,
                          top: AppHeaderMetrics.topPadding, bottom: 16),
                      child: DetailPageHeader(
                          title: title,
                          onAdd: onAdd,
                          showBackButton: showBackButton)),
                  Expanded(child: DetailEnterTransition(child: child)),
                ]))));
    return Scaffold(
        backgroundColor: backgroundColor,
        body: showGrid ? AppGridBackground(child: content) : content,
        bottomNavigationBar: bottomNavigationBar);
  }
}

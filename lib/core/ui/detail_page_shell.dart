import 'app_header_scope.dart';
import 'app_scroll_under_header.dart';
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
      this.headerBottom,
      this.showBackButton = true,
      this.showGrid = true,
      this.scrollUnderHeader = true,
      this.backgroundColor,
      super.key});
  final Color? backgroundColor;
  final bool showGrid;
  final bool scrollUnderHeader;
  final String title;
  final bool showBackButton;
  final Widget child;
  final Widget? bottomNavigationBar;
  final double maxWidth;
  final VoidCallback? onAdd;
  final Widget? headerBottom;
  @override
  Widget build(BuildContext context) {
    final header = Center(
        child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: AppPageSpacing.insets(context,
                top: AppHeaderMetrics.topPadding, bottom: 16),
            child: DetailPageHeader(
                title: title, onAdd: onAdd, showBackButton: showBackButton)),
        if (headerBottom != null) headerBottom!,
      ]),
    ));
    final body = Center(
        child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DetailEnterTransition(child: child),
    ));
    final content = scrollUnderHeader
        ? AppScrollUnderHeader(header: header, child: body)
        : SafeArea(
            bottom: false,
            child: Column(children: [
              AppHeaderScope(child: header),
              Expanded(child: body),
            ]),
          );
    return Scaffold(
        extendBody: true,
        backgroundColor: backgroundColor,
        body: showGrid ? AppGridBackground(child: content) : content,
        bottomNavigationBar: bottomNavigationBar);
  }
}

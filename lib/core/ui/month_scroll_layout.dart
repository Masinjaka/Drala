import 'app_header_scope.dart';
import 'app_scroll_under_header.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:flutter/material.dart';

/// Keeps the header fixed while the month carousel and paged lists scroll together.
class MonthScrollLayout extends StatefulWidget {
  const MonthScrollLayout({
    required this.headerBuilder,
    required this.carousel,
    required this.child,
    this.carouselBottomPadding = 28,
    this.scrollKey,
    this.canScroll = true,
    super.key,
  });

  final Widget Function(bool showMonth) headerBuilder;
  final Widget carousel;
  final Widget child;
  final double carouselBottomPadding;
  final Key? scrollKey;
  final bool canScroll;

  @override
  State<MonthScrollLayout> createState() => _MonthScrollLayoutState();
}

class _MonthScrollLayoutState extends State<MonthScrollLayout> {
  static const _headerGap = 16.0;
  static const _topPadding = 34.0 - _headerGap;
  static const _carouselHeight = 50.0;
  final _bodyKey = GlobalKey();
  bool _showMonth = false;

  void _updateHeader(double offset) {
    final hidden = offset >= _topPadding + _carouselHeight;
    if (hidden != _showMonth) setState(() => _showMonth = hidden);
  }

  @override
  void didUpdateWidget(covariant MonthScrollLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.canScroll) _showMonth = false;
  }

  @override
  Widget build(BuildContext context) {
    final header = Column(children: [
      widget.headerBuilder(_showMonth),
      const SizedBox(height: _headerGap),
    ]);
    final carouselInsets = AppPageSpacing.insets(context,
        top: _topPadding, bottom: widget.carouselBottomPadding);
    final body = KeyedSubtree(key: _bodyKey, child: widget.child);
    if (!widget.canScroll) {
      return Column(children: [
        AppHeaderScope(child: header),
        Padding(padding: carouselInsets, child: widget.carousel),
        Expanded(
            child: MediaQuery.removePadding(
                context: context, removeTop: true, child: body)),
      ]);
    }
    return AppScrollUnderHeader(
      safeTop: false,
      scrollKey: widget.scrollKey,
      onScrollOffset: _updateHeader,
      header: header,
      slivers: [
        SliverPadding(
          padding: carouselInsets,
          sliver: SliverToBoxAdapter(child: widget.carousel),
        ),
      ],
      child: body,
    );
  }
}

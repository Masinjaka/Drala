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
    super.key,
  });

  final Widget Function(bool showMonth) headerBuilder;
  final Widget carousel;
  final Widget child;
  final double carouselBottomPadding;
  final Key? scrollKey;

  @override
  State<MonthScrollLayout> createState() => _MonthScrollLayoutState();
}

class _MonthScrollLayoutState extends State<MonthScrollLayout> {
  static const _headerGap = 16.0;
  static const _topPadding = 34.0 - _headerGap;
  static const _carouselHeight = 50.0;
  final _scroll = ScrollController();
  bool _showMonth = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_updateHeader);
  }

  void _updateHeader() {
    final hidden = _scroll.offset >= _topPadding + _carouselHeight;
    if (hidden != _showMonth) setState(() => _showMonth = hidden);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        widget.headerBuilder(_showMonth),
        const SizedBox(height: _headerGap),
        Expanded(
            child: NestedScrollView(
                key: widget.scrollKey,
                controller: _scroll,
                headerSliverBuilder: (context, _) => [
                      SliverPadding(
                          padding: AppPageSpacing.insets(context,
                              top: _topPadding,
                              bottom: widget.carouselBottomPadding),
                          sliver: SliverToBoxAdapter(child: widget.carousel)),
                    ],
                body: widget.child)),
      ]);
}

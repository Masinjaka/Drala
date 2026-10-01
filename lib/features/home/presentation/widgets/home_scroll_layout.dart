import 'package:budgets/features/home/presentation/widgets/home_calendar_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'home_scroll_physics.dart';

class HomeScrollLayout extends StatefulWidget {
  const HomeScrollLayout({
    required this.header,
    required this.banner,
    required this.calendarBuilder,
    required this.transactions,
    required this.composer,
    super.key,
  });

  final Widget header;
  final Widget banner;
  final Widget Function(bool compact, ValueChanged<double> onVisibilityChanged)
      calendarBuilder;

  /// A sliver sharing the banner and calendar's scroll position.
  final Widget transactions;
  final Widget composer;

  @override
  State<HomeScrollLayout> createState() => _HomeScrollLayoutState();
}

class _HomeScrollLayoutState extends State<HomeScrollLayout> {
  double _calendarVisibility = 1;
  bool _holdBanner = false;
  bool _compact = false;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth == 0 && notification is ScrollStartNotification) {
      _holdBanner = !_compact &&
          notification.dragDetails != null &&
          notification.metrics.pixels >= 138 &&
          _calendarVisibility < 0.99;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final compact = MediaQuery.viewInsetsOf(context).bottom > 0 ||
              View.of(context).viewInsets.bottom > 0 ||
              height < 600;
          _compact = compact;
          return Column(children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.2),
              child:
                  SingleChildScrollView(primary: false, child: widget.header),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: CustomScrollView(
                  key: const Key('transaction-scroll-view'),
                  physics: HomeScrollPhysics(
                      bannerFloor: () => _holdBanner && !_compact ? 138 : null),
                  slivers: [
                    SliverToBoxAdapter(
                      child: compact
                          ? const SizedBox.shrink()
                          : Padding(
                              key: const Key('home-scrolling-banner'),
                              padding:
                                  const EdgeInsets.only(top: 13, bottom: 16),
                              child: widget.banner,
                            ),
                    ),
                    widget.calendarBuilder(compact,
                        (visibility) => _calendarVisibility = visibility),
                    const SliverToBoxAdapter(child: SizedBox(height: 14)),
                    widget.transactions,
                    SliverLayoutBuilder(builder: (context, constraints) {
                      // Short/empty lists still have enough travel to scroll the
                      // banner away and fully collapse the pinned calendar controls.
                      final collapseTravel = compact
                          ? 0.0
                          : 138 + HomeCalendarSliverDelegate.controlsHeight;
                      final remaining = (constraints.viewportMainAxisExtent +
                              collapseTravel -
                              constraints.precedingScrollExtent)
                          .clamp(0.0, double.infinity);
                      return SliverToBoxAdapter(
                          child: SizedBox(height: remaining));
                    }),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.4),
              child: SingleChildScrollView(
                  primary: false, reverse: true, child: widget.composer),
            ),
            SizedBox(height: (height * 0.05).clamp(0.0, compact ? 8.0 : 35.0)),
          ]);
        },
      );
}

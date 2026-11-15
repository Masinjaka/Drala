import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_glass_surface.dart';
import 'app_header_scope.dart';

/// The header stays fixed while its initial space scrolls away beneath it.
class AppScrollUnderHeader extends StatefulWidget {
  const AppScrollUnderHeader(
      {required this.header,
      required this.child,
      this.slivers = const [],
      this.scrollKey,
      this.onScrollOffset,
      this.safeTop = true,
      super.key});
  final Widget header;
  final Widget child;
  final List<Widget> slivers;
  final Key? scrollKey;
  final ValueChanged<double>? onScrollOffset;
  final bool safeTop;
  @override
  State<AppScrollUnderHeader> createState() => _AppScrollUnderHeaderState();
}

class _AppScrollUnderHeaderState extends State<AppScrollUnderHeader> {
  final _header = GlobalKey();
  final _scroll = ScrollController();
  double _height = 0;
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    _setScrolled(_scroll.offset > (_scrolled ? .5 : 3));
    widget.onScrollOffset?.call(math.max(0, _scroll.offset - _height));
  }

  void _setScrolled(bool value) {
    if (_scrolled != value && mounted) setState(() => _scrolled = value);
  }

  void _measure(Duration _) {
    if (!mounted) return;
    final height = _header.currentContext?.size?.height ?? 0;
    if ((height - _height).abs() > .5) setState(() => _height = height);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_measure);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          _setScrolled(
              (_scroll.hasClients && _scroll.offset > (_scrolled ? .5 : 3)) ||
                  notification.metrics.extentBefore > (_scrolled ? .5 : 3));
        }
        return false;
      },
      child: Stack(fit: StackFit.expand, children: [
        NestedScrollView(
          key: widget.scrollKey,
          controller: _scroll,
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(child: SizedBox(height: _height)),
            ...widget.slivers,
          ],
          body: MediaQuery.removePadding(
              context: context, removeTop: true, child: widget.child),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppGlassSurface(
            active: _scrolled,
            edge: AppGlassEdge.bottom,
            child: SafeArea(
                key: _header,
                top: widget.safeTop,
                bottom: false,
                child: AppHeaderScope(child: widget.header)),
          ),
        ),
      ]),
    );
  }
}

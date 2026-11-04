import 'package:budgets/core/ui/horizontal_page_motion.dart';
import 'package:flutter/material.dart';

class ManualEntryTypePages extends StatefulWidget {
  const ManualEntryTypePages({
    required this.index,
    required this.children,
    super.key,
  });

  final int index;
  final List<Widget> children;

  @override
  State<ManualEntryTypePages> createState() => _ManualEntryTypePagesState();
}

class _ManualEntryTypePagesState extends State<ManualEntryTypePages> {
  late final _controller = PageController(initialPage: widget.index);

  @override
  void didUpdateWidget(covariant ManualEntryTypePages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller.animateToPage(widget.index,
          duration: horizontalPageDuration, curve: horizontalPageCurve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.children,
      );
}

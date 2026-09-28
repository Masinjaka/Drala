import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthCarousel extends StatefulWidget {
  const MonthCarousel({
    required this.month,
    required this.onChanged,
    required this.canGoNext,
    super.key,
  });

  final DateTime month;
  final ValueChanged<int> onChanged;
  final bool canGoNext;

  @override
  State<MonthCarousel> createState() => _MonthCarouselState();
}

class _MonthCarouselState extends State<MonthCarousel> {
  static const _centerPage = 1200;
  late final PageController _controller;
  late DateTime _origin;
  var _selectedPage = _centerPage;

  @override
  void initState() {
    super.initState();
    _origin = DateTime(widget.month.year, widget.month.month);
    _controller = PageController(
      initialPage: _centerPage,
      viewportFraction: 1 / 3,
    );
  }

  @override
  void didUpdateWidget(MonthCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final expected = _monthAt(_selectedPage);
    if (_sameMonth(expected, widget.month)) return;
    _selectedPage += _monthDifference(expected, widget.month);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.hasClients) {
        _controller.animateToPage(
          _selectedPage,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Center(
      child: Container(
        key: const Key('month-carousel'),
        width: 294,
        height: 50,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: PageView.builder(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          onPageChanged: _selectPage,
          itemBuilder: (context, index) {
            final selected = index == _selectedPage;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF343434)
                        : const Color(0xFFA0A0A0),
                    fontSize: selected ? 16 : 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  child: Text(
                    DateFormat.MMMM(locale).format(_monthAt(index)),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPage(int index) {
    final offset = index - _selectedPage;
    if (offset == 0) return;
    if (offset > 0 && !widget.canGoNext) {
      _controller.animateToPage(
        _selectedPage,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
      return;
    }
    setState(() => _selectedPage = index);
    widget.onChanged(offset);
  }

  DateTime _monthAt(int page) =>
      DateTime(_origin.year, _origin.month + page - _centerPage);

  bool _sameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;

  int _monthDifference(DateTime from, DateTime to) =>
      (to.year - from.year) * 12 + to.month - from.month;
}

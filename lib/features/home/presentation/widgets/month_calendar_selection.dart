import 'package:budgets/features/home/presentation/widgets/calendar_selection_indicator.dart';
import 'package:flutter/material.dart';

// Keeps TableCalendar's paging and gestures intact. Only the selection overlay
// listens to page offsets; rebuilding the entire month on every frame is avoided.
class MonthCalendarSelection extends StatefulWidget {
  const MonthCalendarSelection(
      {required this.selectedDay,
      required this.focusedDay,
      required this.firstDay,
      required this.rowHeight,
      required this.weekdaysHeight,
      required this.builder,
      super.key});
  final DateTime selectedDay;
  final DateTime focusedDay;
  final DateTime firstDay;
  final double rowHeight;
  final double weekdaysHeight;
  final Widget Function(ValueChanged<PageController>) builder;

  @override
  State<MonthCalendarSelection> createState() => _MonthCalendarSelectionState();
}

class _MonthCalendarSelectionState extends State<MonthCalendarSelection> {
  PageController? _controller;
  late final ValueNotifier<double> _page =
      ValueNotifier(_monthIndex(widget.focusedDay).toDouble());
  int _monthIndex(DateTime day) =>
      (day.year - widget.firstDay.year) * 12 +
      day.month -
      widget.firstDay.month;

  void _attach(PageController controller) {
    _controller?.removeListener(_pageChanged);
    _controller = controller;
    controller.addListener(_pageChanged);
  }

  void _pageChanged() {
    final controller = _controller;
    if (controller != null &&
        controller.hasClients &&
        controller.position.hasContentDimensions) {
      _page.value = controller.page ?? controller.initialPage.toDouble();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_pageChanged);
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final selected = widget.selectedDay;
        final index = DateTime(selected.year, selected.month).weekday % 7 +
            selected.day -
            1;
        final width = constraints.maxWidth / 7;
        final bounds = Rect.fromLTWH(
            index % 7 * width + 4,
            widget.weekdaysHeight + index ~/ 7 * widget.rowHeight + 1,
            (width - 8).clamp(0, double.infinity),
            widget.rowHeight - 2);
        final selectedPage = _monthIndex(selected);
        final direction =
            Directionality.of(context) == TextDirection.rtl ? -1 : 1;
        return Stack(children: [
          Positioned.fill(
              child: ClipRect(
                  child: ValueListenableBuilder<double>(
            valueListenable: _page,
            builder: (context, page, _) => Transform.translate(
              offset: Offset(
                  (selectedPage - page) * constraints.maxWidth * direction, 0),
              child: Stack(children: [
                CalendarSelectionIndicator(
                    key: ValueKey('${selected.year}-${selected.month}'),
                    bounds: bounds)
              ]),
            ),
          ))),
          widget.builder(_attach),
        ]);
      });
}

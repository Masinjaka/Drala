import 'package:budgets/core/ui/app_navigation_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_navigation_item.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeNavigationRow extends StatefulWidget {
  const HomeNavigationRow(
      {required this.selectedIndex,
      required this.onSelected,
      required this.duration,
      super.key});
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Duration duration;

  @override
  State<HomeNavigationRow> createState() => _HomeNavigationRowState();
}

class _HomeNavigationRowState extends State<HomeNavigationRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration, value: 1);
  late List<double> _fromWidths = _widths(widget.selectedIndex);
  late List<double> _toWidths = _fromWidths;
  late double _fromPosition = widget.selectedIndex.toDouble();
  late double _toPosition = _fromPosition;
  double get _progress => Curves.easeInOutCubic.transform(_controller.value);
  List<double> _widths(int selected) =>
      List.generate(5, (i) => i == selected ? 2.0 : 1.0);
  List<double> get _currentWidths => List.generate(
      5, (i) => _fromWidths[i] + (_toWidths[i] - _fromWidths[i]) * _progress);
  double get _position =>
      _fromPosition + (_toPosition - _fromPosition) * _progress;

  @override
  void didUpdateWidget(covariant HomeNavigationRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      // Rebase on the visible position so quick taps never restart at an old tab.
      _fromWidths = _currentWidths;
      _fromPosition = _position;
      _toWidths = _widths(widget.selectedIndex);
      _toPosition = widget.selectedIndex.toDouble();
      if (widget.duration == Duration.zero) {
        _controller.value = 1;
      } else {
        _controller.forward(from: 0);
      }
    } else if (widget.duration == Duration.zero && _controller.isAnimating) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.home,
      context.l10n.activities,
      context.l10n.envelope,
      context.l10n.stats,
      context.l10n.profile
    ];
    const icons = [
      Icons.home,
      Icons.swap_horiz_rounded,
      Icons.mail_rounded,
      Icons.pie_chart_rounded,
      Icons.person_rounded
    ];
    return LayoutBuilder(
        builder: (context, constraints) => AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // Fractions keep the indicator aligned while the outer chat card reshapes.
                final unit = constraints.maxWidth / 6;
                final widths = _currentWidths;
                return Stack(children: [
                  PositionedDirectional(
                      start: _position * unit,
                      top: 0,
                      bottom: 0,
                      width: unit * 2,
                      child: IgnorePointer(
                          child: ExcludeSemantics(
                              child: DecoratedBox(
                        key: const Key('home-navigation-selection-highlight'),
                        decoration: ShapeDecoration(
                            color:
                                AppNavigationTheme.selectedBackground(context),
                            shape: const StadiumBorder()),
                      )))),
                  Row(
                      children: List.generate(
                          5,
                          (index) => SizedBox(
                                width: widths[index] * unit,
                                child: HomeNavigationItem(
                                    index: index,
                                    label: labels[index],
                                    icon: icons[index],
                                    selected: widget.selectedIndex == index,
                                    onPressed: () => widget.onSelected(index),
                                    duration: widget.duration),
                              ))),
                ]);
              },
            ));
  }
}

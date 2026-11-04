import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class StatsTabSwitcher extends StatefulWidget {
  const StatsTabSwitcher(
      {required this.categories, required this.onChanged, super.key});
  final bool categories;
  final ValueChanged<bool> onChanged;
  @override
  State<StatsTabSwitcher> createState() => _StatsTabSwitcherState();
}

class _StatsTabSwitcherState extends State<StatsTabSwitcher>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(
      length: 2, vsync: this, initialIndex: widget.categories ? 1 : 0);
  @override
  void didUpdateWidget(StatsTabSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_tabs.index != (widget.categories ? 1 : 0)) {
      _tabs.animateTo(widget.categories ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 37,
      child: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          onTap: (index) => widget.onChanged(index == 1),
          dividerHeight: 0,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsetsDirectional.only(end: 18),
          labelStyle: AppStatsTheme.label(context),
          unselectedLabelStyle: AppStatsTheme.label(context),
          labelColor: AppStatsTheme.foreground(context),
          unselectedLabelColor: AppStatsTheme.foreground(context),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                  width: 3, color: AppStatsTheme.foreground(context)),
              borderRadius: BorderRadius.circular(2)),
          tabs: [
            Tab(
                key: const Key('stats-numbers-tab'),
                text: context.l10n.statsNumbers),
            Tab(
                key: const Key('stats-categories-tab'),
                text: context.l10n.statsCategories)
          ]));
}

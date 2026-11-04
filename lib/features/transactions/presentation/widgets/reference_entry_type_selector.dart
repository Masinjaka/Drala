import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:budgets/core/ui/sliding_tab_indicator.dart';
import 'package:flutter/material.dart';

class ReferenceEntryTypeSelector extends StatefulWidget {
  const ReferenceEntryTypeSelector(
      {required this.value,
      required this.labels,
      required this.onChanged,
      super.key});
  final String value;
  final Map<String, String> labels;
  final ValueChanged<String> onChanged;
  @override
  State<ReferenceEntryTypeSelector> createState() =>
      _ReferenceEntryTypeSelectorState();
}

class _ReferenceEntryTypeSelectorState extends State<ReferenceEntryTypeSelector>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
      length: widget.labels.length,
      initialIndex: widget.labels.keys
          .toList()
          .indexOf(widget.value)
          .clamp(0, widget.labels.length - 1),
      vsync: this);
  @override
  void didUpdateWidget(ReferenceEntryTypeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = widget.labels.keys.toList().indexOf(widget.value);
    if (index >= 0 && index != _tabs.index)
      _tabs.animateTo(index,
          duration: SlidingTabIndicator.duration,
          curve: SlidingTabIndicator.curve);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: AppFinanceSurfaceTheme.field(context),
              borderRadius: AppFinanceSurfaceTheme.fieldRadius,
              boxShadow: AppCardTheme.shadows(context)),
          child: Stack(children: [
            Positioned.fill(
                child: SlidingTabIndicator(
                    key: const Key('entry-selected-pill'),
                    animation: _tabs.animation!,
                    count: widget.labels.length,
                    color: AppFinanceSurfaceTheme.background(context),
                    radius: AppFinanceSurfaceTheme.fieldRadius)),
            Row(children: [
              for (final item in widget.labels.entries)
                Expanded(
                    child: Semantics(
                        selected: widget.value == item.key,
                        button: true,
                        child: InkWell(
                            key: ValueKey('transaction-type-${item.key}'),
                            borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                            onTap: () => widget.onChanged(item.key),
                            child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minHeight: 44),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    child: Text(item.value,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: AppFinanceSurfaceTheme.label(
                                            context))))))),
            ]),
          ])));
}

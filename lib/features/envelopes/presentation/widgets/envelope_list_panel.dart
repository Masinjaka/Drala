import 'package:budgets/core/ui/selectable_item.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EnvelopeListPanel extends StatefulWidget {
  const EnvelopeListPanel({
    required this.envelopes,
    required this.onDelete,
    this.displayCurrency,
    this.selectedIds,
    this.onToggleSelection,
    this.selectionEnabled = true,
    this.onEdit,
    this.loading = false,
    this.targetEnvelopeId,
    super.key,
  });

  final List<Envelope> envelopes;
  final bool loading;
  final ValueChanged<String> onDelete;
  final CurrencyState? displayCurrency;
  final Set<String>? selectedIds;
  final ValueChanged<String>? onToggleSelection;
  final bool selectionEnabled;
  final ValueChanged<Envelope>? onEdit;
  final String? targetEnvelopeId;

  @override
  State<EnvelopeListPanel> createState() => _EnvelopeListPanelState();
}

class _EnvelopeListPanelState extends State<EnvelopeListPanel> {
  final _targetKey = GlobalKey();
  bool _didReveal = false;

  @override
  void didUpdateWidget(covariant EnvelopeListPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetEnvelopeId != widget.targetEnvelopeId) {
      _didReveal = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _scheduleReveal();
    if (widget.envelopes.isEmpty) {
      return const EnvelopeEmptyState();
    }
    return Column(
      children: [
        for (var index = 0; index < widget.envelopes.length; index++) ...[
          KeyedSubtree(
            key: Key('envelope-${widget.envelopes[index].id}'),
            child: SelectableItem(
                selecting: widget.selectedIds != null,
                selected:
                    widget.selectedIds?.contains(widget.envelopes[index].id) ??
                        false,
                enabled: !widget.loading && widget.selectionEnabled,
                selectionKey:
                    Key('select-envelope-${widget.envelopes[index].id}'),
                onToggle: () =>
                    widget.onToggleSelection?.call(widget.envelopes[index].id),
                child: EnvelopeCard(
                  key: widget.envelopes[index].id == widget.targetEnvelopeId
                      ? _targetKey
                      : null,
                  envelope: widget.envelopes[index],
                  isFirst: index == 0,
                  isLast: index == widget.envelopes.length - 1,
                  loading: widget.loading,
                  onTap: () => widget.selectedIds == null
                      ? widget.onEdit?.call(widget.envelopes[index])
                      : widget.onToggleSelection
                          ?.call(widget.envelopes[index].id),
                  onDelete: () => widget.onDelete(widget.envelopes[index].id),
                  displayCurrency: widget.displayCurrency,
                )),
          )
              .animate(delay: (50 * index).ms)
              .fadeIn(duration: 200.ms)
              .slideY(begin: .5, duration: 200.ms, curve: Curves.easeOut),
          if (index < widget.envelopes.length - 1) const SizedBox(height: 5),
        ],
      ],
    );
  }

  void _scheduleReveal() {
    final targetId = widget.targetEnvelopeId;
    if (_didReveal ||
        targetId == null ||
        !widget.envelopes.any((envelope) => envelope.id == targetId)) {
      return;
    }
    _didReveal = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _targetKey.currentContext;
      if (!mounted || target == null) return;
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: .35,
      );
    });
  }
}

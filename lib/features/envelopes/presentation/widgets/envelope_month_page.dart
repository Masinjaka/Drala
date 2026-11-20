import 'package:budgets/core/ui/app_refresh_indicator.dart';
import 'package:budgets/core/widgets/delayed_skeleton.dart';
import 'envelope_empty_state.dart';
import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_panel.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_skeleton.dart';
import 'package:flutter/material.dart';

class EnvelopeMonthPage extends StatelessWidget {
  const EnvelopeMonthPage({
    required this.envelopes,
    required this.isLoading,
    this.resolved = true,
    required this.onRefresh,
    required this.onDelete,
    this.displayCurrency,
    this.selectedIds,
    this.onToggleSelection,
    this.selectionEnabled = true,
    this.onEdit,
    this.targetEnvelopeId,
    super.key,
  });

  final List<Envelope> envelopes;
  final bool isLoading;
  final bool resolved;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onDelete;
  final CurrencyState? displayCurrency;
  final Set<String>? selectedIds;
  final ValueChanged<String>? onToggleSelection;
  final bool selectionEnabled;
  final ValueChanged<Envelope>? onEdit;
  final String? targetEnvelopeId;

  @override
  Widget build(BuildContext context) => DelayedSkeleton(
        pending: isLoading && envelopes.isEmpty,
        builder: _buildMonth,
      );

  Widget _buildMonth(BuildContext context, bool showSkeleton) {
    if (resolved && !isLoading && envelopes.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.paddingOf(context).bottom;
          return SingleChildScrollView(
            key: const Key('envelope-month-list'),
            primary: false,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - bottomInset)
                    .clamp(0.0, double.infinity),
              ),
              child: const Center(child: EnvelopeEmptyState()),
            ),
          );
        },
      );
    }
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        key: const Key('envelope-month-list'),
        primary: true,
        padding: AppScrollPadding.insets(context, top: 0, bottom: 32),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (showSkeleton)
            const EnvelopeListSkeleton()
          else if (envelopes.isNotEmpty)
            EnvelopeListPanel(
              envelopes: envelopes,
              selectedIds: selectedIds,
              onToggleSelection: onToggleSelection,
              selectionEnabled: selectionEnabled,
              onDelete: onDelete,
              onEdit: onEdit,
              loading: isLoading,
              displayCurrency: displayCurrency,
              targetEnvelopeId: targetEnvelopeId,
            ),
        ],
      ),
    );
  }
}

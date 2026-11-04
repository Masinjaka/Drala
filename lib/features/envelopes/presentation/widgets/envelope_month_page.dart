import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_panel.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_skeleton.dart';
import 'package:flutter/material.dart';

class EnvelopeMonthPage extends StatelessWidget {
  const EnvelopeMonthPage({
    required this.envelopes,
    required this.isLoading,
    required this.onRefresh,
    required this.onDelete,
    this.displayCurrency,
    this.selectedIds,
    this.onToggleSelection,
    this.selectionEnabled = true,
    this.onAdd,
    this.onEdit,
    this.targetEnvelopeId,
    super.key,
  });

  final VoidCallback? onAdd;
  final List<Envelope> envelopes;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onDelete;
  final CurrencyState? displayCurrency;
  final Set<String>? selectedIds;
  final ValueChanged<String>? onToggleSelection;
  final bool selectionEnabled;
  final ValueChanged<Envelope>? onEdit;
  final String? targetEnvelopeId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          key: const Key('envelope-month-list'),
          primary: true,
          padding: AppPageSpacing.insets(context, top: 0, bottom: 32),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (isLoading && envelopes.isEmpty)
              const EnvelopeListSkeleton()
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: envelopes.isEmpty
                        ? (constraints.maxHeight > 32
                            ? constraints.maxHeight - 32
                            : 0)
                        : 0),
                child: EnvelopeListPanel(
                  onAdd: onAdd,
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
              ),
          ],
        ),
      ),
    );
  }
}

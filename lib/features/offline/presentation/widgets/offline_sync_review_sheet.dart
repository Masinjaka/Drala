import 'package:budgets/core/ui/app_button_skeleton.dart';
import 'package:budgets/core/ui/app_loader.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'dart:convert';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class OfflineSyncReviewSheet extends StatefulWidget {
  const OfflineSyncReviewSheet({required this.account, super.key});
  final OfflineAccount account;
  @override
  State<OfflineSyncReviewSheet> createState() => _OfflineSyncReviewSheetState();
}

class _OfflineSyncReviewSheetState extends State<OfflineSyncReviewSheet> {
  bool _busy = false;
  late final _rows = widget.account.database
      .customSelect(
          'SELECT table_name,operation,payload FROM guest_sync_records ORDER BY rowid')
      .get();
  Future<void> _apply(bool cloud) async {
    if (cloud &&
        await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                        title: Text(context.l10n.offlineDiscardTitle),
                        content: Text(context.l10n.offlineDiscardBody),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(context.l10n.cancel)),
                          FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(context.l10n.offlineKeepCloud)),
                        ])) !=
            true) {
      return;
    }
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      if (cloud) {
        await widget.account.useCloudAfterReview();
      } else {
        await widget.account.retryReviewedChanges();
      }
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AppSheetHeader(
              title: context.l10n.syncConflictTitle,
              onClose: () => Navigator.pop(context)),
          const SizedBox(height: 12),
          Text(context.l10n.syncConflictMessage),
          const SizedBox(height: 12),
          Flexible(
              child: FutureBuilder(
                  future: _rows,
                  builder: (context, snapshot) {
                    final rows = snapshot.data;
                    if (rows == null) {
                      return const Center(child: AppLoader());
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final row = rows[index];
                          final data = jsonDecode(row.read<String>('payload'))
                              as Map<String, dynamic>;
                          final label =
                              switch (row.read<String>('table_name')) {
                            'wallets' => context.l10n.wallets,
                            'envelopes' => context.l10n.envelopes,
                            'categories' => context.l10n.expenseCategory,
                            'user' => context.l10n.profile,
                            _ => context.l10n.transactions,
                          };
                          final amount = data['amount'] ?? data['balance'];
                          return ListTile(
                              leading: Icon(
                                  row.read<String>('operation') == 'delete'
                                      ? Icons.delete_rounded
                                      : Icons.edit),
                              title: Text(
                                  '${data['title'] ?? data['name'] ?? label}'),
                              subtitle: amount is num
                                  ? Text(
                                      formatAmountWithCurrency(amount, 'MGA'))
                                  : Text(label));
                        });
                  })),
          const SizedBox(height: 12),
          if (_busy) ...[
            const AppButtonSkeleton(),
            const SizedBox(height: 8),
            const AppButtonSkeleton(width: 160, height: 40),
          ] else ...[
            FilledButton(
                onPressed: () => _apply(false),
                child: Text(context.l10n.offlineRetryChanges)),
            TextButton(
                onPressed: () => _apply(true),
                child: Text(context.l10n.offlineKeepCloud)),
          ],
        ]),
      ));
}

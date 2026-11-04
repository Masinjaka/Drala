import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/features/home/presentation/widgets/receipt_input_option.dart';
import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';

enum ReceiptInputAction { manualEntry, importFile, scanReceipt }

class ReceiptInputBottomSheet extends StatelessWidget {
  const ReceiptInputBottomSheet({super.key});
  static Future<ReceiptInputAction?> show(BuildContext context) =>
      showAppSheet<ReceiptInputAction>(context,
          builder: (_) => const ReceiptInputBottomSheet());
  @override
  Widget build(BuildContext context) => AppSheetSurface(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppSheetHeader(
              title: context.l10n.chooseSource,
              onClose: () => Navigator.pop(context)),
          const SizedBox(height: 24),
          ReceiptInputOption(
              icon: Icons.edit_note_rounded,
              label: context.l10n.enterManually,
              onTap: () =>
                  Navigator.pop(context, ReceiptInputAction.manualEntry)),
          const SizedBox(height: 20),
          ReceiptInputOption(
              icon: Icons.note_add_outlined,
              label: context.l10n.importFile,
              onTap: () =>
                  Navigator.pop(context, ReceiptInputAction.importFile)),
          const SizedBox(height: 20),
          ReceiptInputOption(
              icon: Icons.document_scanner_outlined,
              label: context.l10n.scanReceipt,
              onTap: () =>
                  Navigator.pop(context, ReceiptInputAction.scanReceipt)),
        ]),
      ));
}

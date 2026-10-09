import 'package:budgets/core/ui/detail_list_skeleton.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:budgets/features/receipts/data/repositories/supabase_receipt_repository.dart';
import 'package:budgets/features/receipts/data/services/receipt_query_service.dart';
import 'package:budgets/features/receipts/data/services/receipt_ai_service.dart';
import 'package:budgets/features/receipts/data/services/receipt_storage_service.dart';
import 'package:budgets/features/receipts/domain/models/receipt_scan.dart';
import 'package:budgets/features/receipts/domain/repositories/receipt_repository.dart';
import 'package:budgets/features/receipts/presentation/pages/receipt_preview_page.dart';
import 'package:budgets/features/receipts/presentation/view_models/receipt_gallery_view_model.dart';
import 'package:budgets/features/receipts/presentation/widgets/receipt_gallery_card.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budgets/l10n/app_localizations_context.dart';

class ReceiptGalleryPage extends StatefulWidget {
  const ReceiptGalleryPage({this.repository, super.key});

  final ReceiptRepository? repository;

  @override
  State<ReceiptGalleryPage> createState() => _ReceiptGalleryPageState();
}

class _ReceiptGalleryPageState extends State<ReceiptGalleryPage> {
  late final ReceiptGalleryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ReceiptGalleryViewModel(
      widget.repository ?? _defaultRepository(),
    );
    _load();
  }

  ReceiptRepository _defaultRepository() {
    final client = Supabase.instance.client;
    return SupabaseReceiptRepository(
      ReceiptStorageService(client),
      ReceiptQueryService(client),
      ReceiptAiService(client),
    );
  }

  Future<void> _load() async {
    try {
      await _viewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageShell(
      title: context.l10n.scannedReceipts,
      maxWidth: 900,
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _body(),
      ),
    );
  }

  Widget _body() {
    if (_viewModel.isLoading) {
      return const DetailListSkeleton();
    }
    if (_viewModel.scans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            context.l10n.receiptGalleryEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            (constraints.maxWidth / 190).floor().clamp(2, 4).toInt();
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemCount: _viewModel.scans.length,
          itemBuilder: (_, index) => _card(_viewModel.scans[index])
              .animate(delay: (50 * index.clamp(0, 6)).ms)
              .fadeIn(duration: 200.ms)
              .slideY(begin: .15, duration: 200.ms),
        );
      },
    );
  }

  Widget _card(ReceiptScan scan) => ReceiptGalleryCard(
        scan: scan,
        isDeleting: _viewModel.deletingId == scan.id,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ReceiptPreviewPage(scan: scan),
          ),
        ),
        onDelete: () => _confirmDelete(scan),
      );

  Future<void> _confirmDelete(ReceiptScan scan) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteReceiptQuestion,
      message: context.l10n.deleteReceiptDescription,
      confirmText: context.l10n.delete,
      cancelText: context.l10n.cancel,
    );
    if (!confirmed) return;
    try {
      await _viewModel.delete(scan);
      if (mounted) showSuccessToast(context, context.l10n.receiptDeleted);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }
}

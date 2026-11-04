import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/ui/app_bottom_action.dart';
import 'package:budgets/core/ui/horizontal_page_motion.dart';
import 'package:budgets/core/ui/bulk_selection_bar.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_save_cancelled.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/features/envelopes/data/repositories/supabase_envelope_repository.dart';
import 'package:budgets/features/envelopes/data/services/envelope_service.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/view_models/envelope_view_model.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_page_content.dart';
import 'package:budgets/features/home/domain/errors/wallet_selection_required_exception.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_source_sheet.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_wallet_field.dart';

part 'envelope_page_actions.dart';
part 'envelope_page_selection.dart';

class EnvelopePage extends StatefulWidget {
  const EnvelopePage({
    this.repository,
    this.onManageWallets,
    this.showBackButton = true,
    this.initialMonth,
    this.initialEnvelopeId,
    this.displayCurrency,
    super.key,
  });
  final EnvelopeRepository? repository;
  final Future<void> Function()? onManageWallets;
  final DateTime? initialMonth;
  final bool showBackButton;
  final String? initialEnvelopeId;
  final CurrencyState? displayCurrency;
  @override
  State<EnvelopePage> createState() => EnvelopePageState();
}

class EnvelopePageState extends State<EnvelopePage> {
  static const _initialPage = 1200;
  bool _selecting = false;
  final Set<String> _selected = {};
  void _update(VoidCallback change) => setState(change);
  late final EnvelopeViewModel _viewModel;
  late final PageController _pageController;
  late final DateTime _pageOrigin;
  @override
  void initState() {
    super.initState();
    _viewModel = EnvelopeViewModel(
      widget.repository ??
          SupabaseEnvelopeRepository(
            EnvelopeService(Supabase.instance.client),
          ),
      widget.initialMonth ?? DateTime.now(),
    );
    _pageOrigin = _viewModel.month;
    _pageController = PageController(initialPage: _initialPage);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> createEnvelope() => _showAddSheet();

  Future<void> _load() async {
    try {
      await _viewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _changeMonth(int offset) async {
    _cancelSelection();
    final target = DateTime(
      _viewModel.month.year,
      _viewModel.month.month + offset,
    );
    try {
      await Future.wait([
        _viewModel.changeMonth(offset),
        _pageController.animateToPage(
          _pageForMonth(target),
          duration: horizontalPageDuration,
          curve: horizontalPageCurve,
        ),
      ]);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _pickMonth() async {
    final selected = await AppWheelPicker.monthYear(
      context,
      initialDate: _viewModel.month,
      firstDate: _monthForPage(0),
      lastDate: DateTime.now(),
      title: context.l10n.selectDate,
    );
    if (selected == null || !mounted) return;
    // Jump directly so distant selections do not load every intervening month.
    _pageController.jumpToPage(_pageForMonth(selected));
  }

  Future<void> _selectPage(int page) async {
    _cancelSelection();
    try {
      await _viewModel.selectMonth(_monthForPage(page));
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomAction(
          buttonKey: const Key('envelope-create'),
          label: context.l10n.addEnvelope,
          onPressed: _showAddSheet),
      backgroundColor: AppEnvelopeTheme.background(context),
      body: AppGridBackground(
          backgroundColor: AppEnvelopeTheme.background(context),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => EnvelopePageContent(
              showBackButton: widget.showBackButton,
              viewModel: _viewModel,
              pageController: _pageController,
              pageOrigin: _pageOrigin,
              initialPage: _initialPage,
              initialEnvelopeId: widget.initialEnvelopeId,
              displayCurrency: widget.displayCurrency,
              onAdd: _showAddSheet,
              selectionBar: _selectionBar,
              onSelect: _viewModel.supportsBulkDeletion && !_selecting
                  ? () => _update(() => _selecting = true)
                  : null,
              selectedIds: _selecting ? _selected : null,
              onToggleSelection: _toggleSelection,
              onEdit: _editEnvelope,
              onMonthChanged: _changeMonth,
              onPickMonth: _pickMonth,
              onPageChanged: _selectPage,
              onRefresh: _load,
            ),
          )),
    );
  }

  DateTime _monthForPage(int page) =>
      DateTime(_pageOrigin.year, _pageOrigin.month + page - _initialPage);
  int _pageForMonth(DateTime month) =>
      _initialPage +
      (month.year - _pageOrigin.year) * 12 +
      month.month -
      _pageOrigin.month;
}

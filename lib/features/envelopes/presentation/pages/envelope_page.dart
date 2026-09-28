import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

class EnvelopePage extends StatefulWidget {
  const EnvelopePage({
    this.repository,
    this.initialMonth,
    this.initialEnvelopeId,
    this.displayCurrency,
    super.key,
  });

  final EnvelopeRepository? repository;
  final DateTime? initialMonth;
  final String? initialEnvelopeId;
  final CurrencyState? displayCurrency;

  @override
  State<EnvelopePage> createState() => _EnvelopePageState();
}

class _EnvelopePageState extends State<EnvelopePage> {
  static const _initialPage = 1200;
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

  Future<void> _load() async {
    try {
      await _viewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _changeMonth(int offset) async {
    final target = DateTime(
      _viewModel.month.year,
      _viewModel.month.month + offset,
    );
    try {
      await Future.wait([
        _viewModel.changeMonth(offset),
        _pageController.animateToPage(
          _pageForMonth(target),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        ),
      ]);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _selectPage(int page) async {
    try {
      await _viewModel.selectMonth(_monthForPage(page));
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _showAddSheet() async {
    if (_viewModel.availableCategories.isEmpty) {
      showInfoToast(context, context.l10n.createExpenseCategoryFirst);
      return;
    }
    await AddEnvelopeSheet.show(
      context,
      categories: _viewModel.availableCategories,
      month: _viewModel.month,
      onSave: _addEnvelope,
      currencyState: widget.displayCurrency,
    );
  }

  Future<void> _addEnvelope(
    String name,
    String categoryId,
    int amount,
  ) async {
    try {
      try {
        await _viewModel.add(
          name: name,
          categoryId: categoryId,
          amount: amount,
        );
      } on WalletSelectionRequiredException catch (error) {
        if (!mounted) rethrow;
        final walletId = await WalletSourceSheet.show(
          context,
          wallets: _viewModel.wallets,
          requiredAmount: error.requiredAmount,
        );
        if (walletId == null) rethrow;
        await _viewModel.add(
          name: name,
          categoryId: categoryId,
          amount: amount,
          walletId: walletId,
        );
      }
    } catch (error) {
      if (mounted) showErrorToast(context, error);
      rethrow;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => EnvelopePageContent(
          viewModel: _viewModel,
          pageController: _pageController,
          pageOrigin: _pageOrigin,
          initialPage: _initialPage,
          initialEnvelopeId: widget.initialEnvelopeId,
          displayCurrency: widget.displayCurrency,
          onAdd: _showAddSheet,
          onMonthChanged: _changeMonth,
          onPageChanged: _selectPage,
          onRefresh: _load,
        ),
      ),
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

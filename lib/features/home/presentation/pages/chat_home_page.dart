import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/home/presentation/view_models/home_overview_view_model.dart';
import 'dart:async';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/guest/presentation/pages/guest_settings_page.dart';
import 'package:budgets/features/home/presentation/widgets/chat_home_layout.dart';
import 'package:budgets/features/home/data/services/home_repository_factory.dart';
import 'package:budgets/features/home/presentation/widgets/drawer_destination_navigator.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_permission_prompt.dart';
import 'package:budgets/features/notifications/data/repositories/finance_notification_repository_factory.dart';
import 'package:budgets/features/notifications/domain/repositories/finance_notification_repository.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/features/settings/presentation/pages/setting_page.dart';
import 'package:budgets/features/receipts/domain/repositories/receipt_repository.dart';
import 'package:flutter/material.dart';

part 'chat_home_page_actions.dart';
part 'chat_home_page_build.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({
    this.today,
    this.displayName,
    this.aiEntryRepository,
    this.envelopeRepository,
    this.statsRepository,
    this.receiptRepository,
    this.isSignedIn,
    this.currencyState,
    this.isCurrencyLoading = false,
    this.notificationRepository,
    this.isGuest = false,
    this.manualOnly = false,
    this.offlineAccount,
    super.key,
  });
  final DateTime? today;
  final String? displayName;
  final AiEntryRepository? aiEntryRepository;
  final EnvelopeRepository? envelopeRepository;
  final MonthlyStatsRepository? statsRepository;
  final ReceiptRepository? receiptRepository;
  final bool Function()? isSignedIn;
  final CurrencyState? currencyState;
  final bool isCurrencyLoading;
  final FinanceNotificationRepository? notificationRepository;
  final bool isGuest;
  final bool manualOnly;
  final OfflineAccount? offlineAccount;
  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final _envelopePageKey = GlobalKey<EnvelopePageState>();
  late final DateTime _today;
  late final AiEntryViewModel _aiEntryViewModel;
  late final HomeOverviewViewModel _overviewViewModel;
  late final ActivityCalendarViewModel _activityCalendarViewModel;
  late final FinanceNotificationViewModel _notificationViewModel;
  late DateTime _selectedDate;
  DateTime? _loadedDate;
  int _offlineDataVersion = -1;
  bool _offlineWasOnline = false;
  @override
  void initState() {
    super.initState();
    _today = DateUtils.dateOnly(widget.today ?? DateTime.now());
    _selectedDate = _today;
    final defaults = HomeRepositoryFactory.create(_today);
    final repository = widget.aiEntryRepository ?? defaults.ai;
    _aiEntryViewModel = AiEntryViewModel(
      repository,
      _today,
      receiptRepository: widget.receiptRepository ?? defaults.receipts,
    );
    _overviewViewModel = HomeOverviewViewModel(repository,
        widget.envelopeRepository ?? HomeRepositoryFactory.envelopes(), _today);
    _activityCalendarViewModel = ActivityCalendarViewModel(repository);
    _notificationViewModel = FinanceNotificationViewModel(
      widget.notificationRepository ??
          FinanceNotificationRepositoryFactory.create(isGuest: widget.isGuest),
    );
    _aiEntryViewModel.addListener(_syncSelectedActivity);
    _offlineDataVersion = widget.offlineAccount?.dataVersion ?? -1;
    widget.offlineAccount?.addListener(_offlineDataChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_overviewViewModel.load());
      unawaited(_loadSelectedDate());
      unawaited(_activityCalendarViewModel.loadMonth(_today));
      unawaited(_refreshNotifications());
    });
  }

  Future<void> _loadSelectedDate() async {
    final targetDate = _selectedDate;
    try {
      await _aiEntryViewModel.loadDate(targetDate);
      if (_selectedDate != targetDate) return;
      _loadedDate = targetDate;
      _syncSelectedActivity();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = DateUtils.dateOnly(date));
    unawaited(_loadSelectedDate());
  }

  void _syncSelectedActivity() {
    if (_loadedDate != _selectedDate || _aiEntryViewModel.isLoading) return;
    _activityCalendarViewModel.setActivity(
      _selectedDate,
      _aiEntryViewModel.entries.isNotEmpty,
    );
  }

  @override
  void dispose() {
    widget.offlineAccount?.removeListener(_offlineDataChanged);
    _aiEntryViewModel.removeListener(_syncSelectedActivity);
    _activityCalendarViewModel.dispose();
    _notificationViewModel.dispose();
    _aiEntryViewModel.dispose();
    _overviewViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildHome(context);
}

import 'package:budgets/core/navigation/app_modal_page_route.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/notifications/data/repositories/finance_notification_repository_factory.dart';
import 'package:budgets/features/notifications/presentation/pages/finance_notifications_page.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/offline/domain/providers/offline_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsInboxPage extends ConsumerStatefulWidget {
  const SettingsInboxPage({super.key});
  @override
  ConsumerState<SettingsInboxPage> createState() => _SettingsInboxPageState();
}

class _SettingsInboxPageState extends ConsumerState<SettingsInboxPage> {
  late final FinanceNotificationViewModel _model;
  EnvelopeRepository? _envelopes;
  @override
  void initState() {
    super.initState();
    final account = ref.read(offlineAccountProvider);
    final guest = ref.read(guestSessionProvider);
    final database = account?.database ?? guest?.database;
    final userId = account?.id ?? guest?.userId;
    _model = FinanceNotificationViewModel(database != null && userId != null
        ? GuestNotificationRepository(database, userId)
        : FinanceNotificationRepositoryFactory.create());
    if (database != null && userId != null) {
      _envelopes = GuestRepositories(database, userId).envelopeRepository;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FinanceNotificationsPage(
      viewModel: _model,
      onSelected: (context, notification) => Navigator.of(context).push(
          AppModalPageRoute<void>(
              builder: (_) => EnvelopePage(
                  repository: _envelopes,
                  initialMonth: notification.periodMonth,
                  initialEnvelopeId: notification.envelopeId))));
}

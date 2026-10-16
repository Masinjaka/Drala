import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/notifications/data/repositories/empty_finance_notification_repository.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyHomePage extends ConsumerWidget {
  const CurrencyHomePage({required this.isSignedIn, super.key});

  final bool Function() isSignedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyControllerProvider);
    final guest = ref.watch(guestSessionProvider);
    if (guest?.isActive == true) {
      final finance = guest!.repositories.finance;
      return ChatHomePage(
        isGuest: true,
        isSignedIn: isSignedIn,
        aiEntryRepository: finance,
        envelopeRepository: guest.repositories.envelopeRepository,
        statsRepository: guest.repositories.stats,
        notificationRepository: const EmptyFinanceNotificationRepository(),
        currencyState: currency.value,
        isCurrencyLoading: currency.isLoading,
      );
    }
    return ChatHomePage(
      isSignedIn: isSignedIn,
      currencyState: currency.value,
      isCurrencyLoading: currency.isLoading,
    );
  }
}

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
    Widget home() {
      if (guest?.isActive == true) {
        return ChatHomePage(
          key: ValueKey(guest!.userId),
          isGuest: true,
          isSignedIn: isSignedIn,
          aiEntryRepository: guest.repositories.finance,
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

    if (guest == null) return home();
    return ListenableBuilder(
      listenable: guest,
      builder: (context, _) => home(),
    );
  }
}

import 'package:budgets/features/home/data/services/home_repository_factory.dart';
import 'package:budgets/features/offline/domain/providers/offline_providers.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_account_home.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
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
    final displayName = guest?.isActive == true
        ? null
        : ref.watch(userModelProvider).value?.name;
    Widget home() {
      if (guest?.isActive == true) {
        return ChatHomePage(
          key: ValueKey(guest!.userId),
          isGuest: true,
          isSignedIn: isSignedIn,
          aiEntryRepository: guest.repositories.finance,
          envelopeRepository: guest.repositories.envelopeRepository,
          statsRepository: guest.repositories.stats,
          notificationRepository:
              GuestNotificationRepository(guest.database, guest.userId),
          currencyState: currency.value,
          isCurrencyLoading: currency.isLoading,
        );
      }
      final manager = ref.watch(offlineSyncManagerProvider);
      ref.watch(offlineSyncEventsProvider);
      final account = manager?.account;
      if (account != null) {
        return OfflineAccountHome(
            key: ValueKey(account.id),
            account: account,
            isSignedIn: isSignedIn,
            displayName: displayName,
            currency: currency.value,
            currencyLoading: currency.isLoading);
      }
      if (manager != null) {
        return Scaffold(
            body: Center(
                child: manager.opening
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: manager.retryOpen,
                        child: Text(context.l10n.offlineInitial))));
      }
      return ChatHomePage(
        key: ValueKey(('remote', HomeRepositoryFactory.signedInAccountId)),
        displayName: displayName,
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

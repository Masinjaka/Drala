part of 'chat_home_page.dart';

extension _ChatHomePageBuild on _ChatHomePageState {
  Widget _buildHome(BuildContext context) {
    late final DrawerDestinationNavigator destinations;
    GuestSettingsPage guestSettings() => GuestSettingsPage(
          onCategoriesPressed: () => destinations.openCategories(),
          onWalletsPressed: () => destinations.openWallets(),
          walletsListenable: _aiEntryViewModel,
          walletCountReader: () => _aiEntryViewModel.wallets.length,
        );
    destinations = DrawerDestinationNavigator(
      context: context,
      closeDrawer: () {},
      onReturn: _aiEntryViewModel.refreshBalances,
      shouldRunOnReturn: () =>
          widget.isGuest || (widget.isSignedIn?.call() ?? true),
      settingsPage: widget.isGuest ? guestSettings() : null,
      envelopeRepository: widget.envelopeRepository,
      statsRepository: widget.statsRepository,
      onDataDeleted: _resetAfterDataDeletion,
      currencyState: widget.currencyState,
      wallets: _aiEntryViewModel.wallets,
      onAddWallet: _aiEntryViewModel.addWallet,
      onUpdateWallet: _aiEntryViewModel.updateWallet,
      onDeleteWallet: _aiEntryViewModel.deleteWallet,
      onDeleteWallets: _aiEntryViewModel.deleteWallets,
      walletsListenable: _aiEntryViewModel,
      walletReader: () => _aiEntryViewModel.wallets,
      walletLoadingReader: () => !_aiEntryViewModel.walletsLoaded,
    );
    final layout = ChatHomeLayout(
      today: _today,
      displayName: widget.displayName,
      overviewViewModel: _overviewViewModel,
      viewModel: _aiEntryViewModel,
      activityCalendarViewModel: _activityCalendarViewModel,
      currencyState: widget.currencyState,
      isCurrencyLoading: widget.isCurrencyLoading,
      onDateSelected: _selectDate,
      destinations: [
        EnvelopePage(
            key: _envelopePageKey,
            repository: widget.envelopeRepository,
            onManageWallets: destinations.openWallets,
            displayCurrency: widget.currencyState,
            showBackButton: false),
        FinanceStatsPage(
            repository: widget.statsRepository,
            displayCurrency: widget.currencyState,
            showBackButton: false),
        if (widget.isGuest)
          guestSettings()
        else
          SettingPage(
            onDataDeleted: _resetAfterDataDeletion,
            showBackButton: false,
            notificationViewModel: _notificationViewModel,
            onNotificationsPressed: () =>
                destinations.openNotifications(_notificationViewModel),
            walletsListenable: _aiEntryViewModel,
            walletCountReader: () => _aiEntryViewModel.wallets.length,
            onCategoriesPressed: destinations.openCategories,
            onWalletsPressed: destinations.openWallets,
          ),
      ],
      onCreateEnvelope: () =>
          unawaited(_envelopePageKey.currentState?.createEnvelope()),
      onActivitiesSelected: () {
        unawaited(_loadSelectedDate());
        unawaited(_refreshNotifications());
      },
      notificationViewModel: _notificationViewModel,
      onNotificationsPressed: () => destinations.openNotifications(
        _notificationViewModel,
      ),
      onFinanceChanged: _refreshNotifications,
      manualOnly: widget.isGuest || widget.manualOnly,
    );
    return widget.isGuest
        ? layout
        : NotificationPermissionPrompt(child: layout);
  }
}

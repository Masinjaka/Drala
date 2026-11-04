part of 'chat_home_page.dart';

extension _ChatHomePageActions on _ChatHomePageState {
  void _offlineDataChanged() {
    final version = widget.offlineAccount?.dataVersion;
    final online = widget.offlineAccount?.status.name == 'online';
    final restored = online && !_offlineWasOnline;
    _offlineWasOnline = online;
    if (version == null ||
        !mounted ||
        version == _offlineDataVersion && !restored) {
      return;
    }
    _offlineDataVersion = version;
    _activityCalendarViewModel.clear();
    unawaited(_activityCalendarViewModel.loadMonth(_today));
    unawaited(_aiEntryViewModel.reloadCachedData().catchError((Object error) {
      if (mounted) showErrorToast(context, error);
    }));
    unawaited(_overviewViewModel.load());
    unawaited(_refreshNotifications());
  }

  void _resetAfterDataDeletion() {
    _activityCalendarViewModel.clear();
    _notificationViewModel.clear();
    unawaited(
      _aiEntryViewModel
          .resetAfterDataDeletion()
          .then((_) => _overviewViewModel.load())
          .catchError((Object error) {
        if (mounted) showErrorToast(context, error);
      }),
    );
  }

  Future<void> _refreshNotifications() async {
    try {
      await _notificationViewModel.load();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }
}

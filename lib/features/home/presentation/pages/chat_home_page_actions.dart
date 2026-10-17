part of 'chat_home_page.dart';

extension _ChatHomePageActions on _ChatHomePageState {
  void _resetAfterDataDeletion() {
    _activityCalendarViewModel.clear();
    _notificationViewModel.clear();
    unawaited(
      _aiEntryViewModel.resetAfterDataDeletion().catchError((Object error) {
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

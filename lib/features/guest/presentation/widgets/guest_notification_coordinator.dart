import 'dart:async';

import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_delivery.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_gateway.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class GuestNotificationCoordinator extends ConsumerStatefulWidget {
  const GuestNotificationCoordinator(
      {required this.guest, required this.child, super.key});
  final GuestSession guest;
  final Widget child;

  @override
  ConsumerState<GuestNotificationCoordinator> createState() =>
      _GuestNotificationCoordinatorState();
}

class _GuestNotificationCoordinatorState
    extends ConsumerState<GuestNotificationCoordinator>
    with WidgetsBindingObserver {
  late GuestNotificationDelivery _delivery;
  StreamSubscription<void>? _changes;
  bool _running = false;
  bool _pending = false;
  AppLocalizations? _l10n;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _delivery = GuestNotificationDelivery(
        widget.guest, ref.read(guestNotificationGatewayProvider));
    widget.guest.addListener(_request);
    _changes =
        widget.guest.database.notificationChanges.listen((_) => _request());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context);
    _request();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _request();
  }

  void _request() {
    _pending = true;
    if (!_running && _l10n != null) unawaited(_drain());
  }

  Future<void> _drain() async {
    _running = true;
    while (mounted && _pending) {
      _pending = false;
      try {
        await _delivery.sync(_l10n!);
      } catch (error, stackTrace) {
        // Keep the outbox intact; a later resume or preference change retries it.
        unawaited(Sentry.captureException(error, stackTrace: stackTrace));
      }
    }
    _running = false;
    if (!mounted) await _delivery.cancel();
  }

  @override
  void dispose() {
    widget.guest.removeListener(_request);
    unawaited(_changes?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    if (!_running) unawaited(_delivery.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

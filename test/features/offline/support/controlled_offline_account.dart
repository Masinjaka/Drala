import 'dart:async';

import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';

import 'offline_fixture.dart';

class ControlledOfflineAccount extends OfflineAccount {
  ControlledOfflineAccount(OfflineFixture fixture, OfflineConnectivity network,
      {this.initializeGate, this.closeGate, this.failInitialization = false})
      : super(fixture.database, fixture.remote, network);

  final Completer<void>? initializeGate;
  final Completer<void>? closeGate;
  final bool failInitialization;
  final initializing = Completer<void>();
  final closing = Completer<void>();
  bool closed = false;

  @override
  Future<void> initialize() async {
    initializing.complete();
    await initializeGate?.future;
    if (failInitialization) throw StateError('Cannot open database');
    await super.initialize();
  }

  @override
  void setActive(bool active) {} // Keep tests independent of network timers.

  @override
  Future<void> close() async {
    closing.complete();
    await closeGate?.future;
    await super.close();
    closed = true;
  }
}

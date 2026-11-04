import 'dart:async';
import 'dart:convert';

import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/data/services/offline_sync_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../support/controlled_offline_account.dart';
import '../../support/offline_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SupabaseClient client;
  late OfflineConnectivity network;
  late OfflineSyncManager manager;
  late List<ControlledOfflineAccount> accounts;
  Completer<void>? initializeGate;
  Completer<void>? closeGate;
  var failInitialization = false;

  setUp(() async {
    initializeGate = null;
    closeGate = null;
    failInitialization = false;
    accounts = [];
    network = OfflineConnectivity();
    client = SupabaseClient('https://example.supabase.co', 'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false));
    await client.auth.setInitialSession(jsonEncode({
      'access_token': 'e30.eyJleHAiOjQxMDI0NDQ4MDB9.signature',
      'refresh_token': 'test-refresh',
      'token_type': 'bearer',
      'user': {'id': 'test-user', 'aud': 'authenticated'},
    }));
    manager = OfflineSyncManager(client, network, createAccount: (id) {
      expect(accounts.every((account) => account.closed), isTrue);
      final account = ControlledOfflineAccount(OfflineFixture(id: id), network,
          initializeGate: initializeGate,
          closeGate: closeGate,
          failInitialization: failInitialization);
      accounts.add(account);
      return account;
    });
  });

  tearDown(() async {
    if (initializeGate != null && !initializeGate!.isCompleted) {
      initializeGate!.complete();
    }
    if (closeGate != null && !closeGate!.isCompleted) closeGate!.complete();
    await manager.close();
    await client.dispose();
    network.dispose();
  });

  test('start subscribes and opens only once', () async {
    await Future.wait([manager.start(), manager.start()]);
    expect(accounts, hasLength(1));
    expect(manager.account, accounts.single);
  });

  test('retry waits for initialization and closes stale owners first',
      () async {
    initializeGate = Completer<void>();
    final starting = manager.start();
    // Allow startup and the initial auth event to reach initialization.
    await Future<void>.delayed(Duration.zero);
    final first = accounts.single;
    await first.initializing.future;
    final retry = manager.retryOpen();
    initializeGate!.complete();
    initializeGate = null;
    await Future.wait([starting, retry]);
    expect(first.closed, isTrue);
    expect(accounts, hasLength(2));
    expect(manager.account, accounts.last);
  });

  test('overlapping retries wait for close and skip obsolete requests',
      () async {
    closeGate = Completer<void>();
    await manager.start();
    final first = accounts.single;
    final retry = manager.retryOpen();
    await first.closing.future;
    final latest = manager.retryOpen();
    expect(accounts, hasLength(1));
    closeGate!.complete();
    closeGate = null;
    await Future.wait([retry, latest]);
    expect(first.closed, isTrue);
    expect(accounts, hasLength(2));
    expect(manager.account, accounts.last);
  });

  test('close waits for pending initialization and prevents reopening',
      () async {
    initializeGate = Completer<void>();
    final starting = manager.start();
    await Future<void>.delayed(Duration.zero);
    final first = accounts.single;
    final closing = manager.close();
    var finished = false;
    closing.then((_) => finished = true);
    await Future<void>.delayed(Duration.zero);
    expect(finished, isFalse);
    initializeGate!.complete();
    await Future.wait([starting, closing, manager.close()]);
    expect(first.closed, isTrue);
    expect(manager.account, isNull);
    expect(manager.opening, isFalse);
    await manager.retryOpen();
    await manager.start();
    expect(accounts, hasLength(1));
  });

  test('auth change during initialization only publishes the latest user',
      () async {
    initializeGate = Completer<void>();
    final starting = manager.start();
    await Future<void>.delayed(Duration.zero);
    final first = accounts.single;
    final published = <String>[];
    manager.addListener(() {
      if (manager.account != null) published.add(manager.account!.id);
    });
    await client.auth.setInitialSession(jsonEncode({
      'access_token': 'e30.eyJleHAiOjQxMDI0NDQ4MDB9.signature',
      'refresh_token': 'test-refresh',
      'token_type': 'bearer',
      'user': {'id': 'other-user', 'aud': 'authenticated'},
    }));
    await Future<void>.delayed(Duration.zero);
    initializeGate!.complete();
    initializeGate = null;
    await starting;
    await Future<void>.delayed(Duration.zero);
    expect(first.closed, isTrue);
    expect(manager.account?.id, 'other-user');
    expect(published, ['other-user']);
    expect(accounts, hasLength(2));
  });

  test('a failed initialization is closed and can be retried', () async {
    failInitialization = true;
    await manager.start();
    expect(accounts.single.closed, isTrue);
    expect(manager.account, isNull);
    expect(manager.opening, isFalse);
    failInitialization = false;
    await manager.retryOpen();
    expect(accounts, hasLength(2));
    expect(manager.account, accounts.last);
  });
}

import 'package:budgets/app.dart';
import 'package:budgets/core/monitoring/sentry_bootstrap.dart';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/notifications/presentation/services/firebase_messaging_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

export 'package:budgets/app.dart' show MyApp;

SupabaseClient get supabase => Supabase.instance.client;

Future<void> main() async {
  await SentryBootstrap.run(_startApplication);
}

Future<void> _startApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('mg');
  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (url.isEmpty || anonKey.isEmpty) {
    throw StateError(
      'SUPABASE_URL and SUPABASE_ANON_KEY dart defines are required.',
    );
  }
  await FirebaseMessagingBootstrap.initialize();
  await Supabase.initialize(url: url, anonKey: anonKey);
  final guestDatabase = GuestDatabase();
  final guestSession = await GuestSession.load(guestDatabase);
  final navigation = AppNavigation.supabase(
    Supabase.instance.client,
    guestSession: guestSession,
  );
  runApp(
    SentryWidget(
      child: ProviderScope(
        overrides: [guestSessionProvider.overrideWithValue(guestSession)],
        child: MyApp(
          navigation: navigation,
          guestSession: guestSession,
          authClient: supabase,
        ),
      ),
    ),
  );
}

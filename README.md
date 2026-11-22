# Drala

Drala is a Flutter mobile app for personal finance tracking. Users log expenses and income by typing a sentence to an AI assistant, scanning a receipt, or filling a form. Money is organized into wallets and monthly envelopes, and the app works offline, with or without an account.

Current version: `2.1.0` (see [`pubspec.yaml`](pubspec.yaml)).

## Features

- **AI entry**: a chat-style home screen where a sentence such as "lunch 15000 and taxi 5000" becomes one or more transactions. The text is processed server-side by the `process-finance-message` edge function. Free accounts get 5 AI requests per day.
- **Receipt scanning**: scan a receipt with the camera or import an image/PDF. The AI extracts the entries, and receipts are kept privately in a receipt gallery.
- **Manual entry**: add, edit and delete income and expenses from a bottom sheet. You can create a category directly from the picker, and bulk-delete several entries at once.
- **Wallets**: multiple wallets, a default wallet, manual transfers between wallets, and expenses that can take a wallet negative when there is no income yet.
- **Envelopes**: per-category budgets, optionally renewed every month. Expenses in an envelope's category are taken from the envelope's funds. You get alerts when an envelope is almost used up, fully used, or overspent.
- **Activity calendar**: a home dashboard with the balance (which can be hidden), a month/week calendar of activity and a daily transaction list.
- **Stats**: monthly reports with animated charts, a month carousel and a month/year picker.
- **Categories**: expense and income categories with emoji and colour. Localized preset categories are created during onboarding.
- **Notifications**: an in-app notification inbox, push alerts for envelope thresholds, and daily reminders in the user's language.
- **Guest mode**: use the full app without an account. Data is stored locally and imported into the cloud when the user signs up or logs in.
- **Offline sync**: signed-in users read and write a local mirror. Changes queue in an outbox and sync automatically, and conflicts can be reviewed.
- **Onboarding**: a welcome flow, then setup (currency, wallets, categories), then the choice to sign up, log in or continue as a guest.
- **Settings**: profile, password, currency (with synced exchange rates), default wallet, theme (light/dark/system), language, notification preferences, legal documents, data deletion and account deletion.
- **Plans**: a Free vs Drala Plus comparison page.
- **Feedback & ads**: in-app feedback through Sentry user feedback, and an AdMob Advanced Native ad at the end of the home list (consent-aware).
- **Languages**: English, French, Malagasy, German, Spanish and Italian.

## Stack

- Flutter 3.38.7 (pinned with FVM), Dart `^3.5.0`
- State management: Riverpod 3 with code generation (`riverpod_generator`)
- Navigation: GoRouter
- Backend: Supabase (Auth, Postgres RPCs, Storage, Edge Functions)
- Local database: Drift (SQLite) for guest data and the offline account mirror
- Preferences: SharedPreferences (theme, locale, guest session flags)
- Push notifications: Firebase Cloud Messaging and `flutter_local_notifications`
- AI: Gemini or Qwen, called only from Supabase Edge Functions
- Ads: `google_mobile_ads`
- Monitoring and feedback: Sentry (`sentry_flutter`, `feedback_sentry`)
- Charts: `fl_chart`. Receipts: `camera`, `cunning_document_scanner`, `file_picker`
- Fonts: Alexandria and Inter (bundled in `assets/fonts`)

## Supported platforms

Android and iOS. The `web/` folder exists, but Firebase is not configured for web in [`lib/firebase_options.dart`](lib/firebase_options.dart), so treat web as unsupported.

## Project structure

```text
lib/
  main.dart          Entrypoint: service bootstrap and ProviderScope
  app.dart           MyApp: theme, localization, router
  core/              Shared infrastructure (navigation, theme/UI tokens, currency,
                     forms, monitoring, localization, layout)
  features/
    ads/             AdMob native ad
    ai_entry/        AI and manual transaction entry, transfers, wallets
    auth/            Login, sign up, password reset
    categories/      Category management
    envelopes/       Monthly envelope budgets
    feedback/        Sentry feedback launcher
    guest/           Guest mode (Drift storage + cloud import)
    home/            Chat home, activity calendar, drawer, wallets page
    notifications/   FCM, inbox, notification settings
    offline/         Offline mirror, outbox and sync engine
    onboarding/      Getting started + account setup
    plans/           Free / Drala Plus comparison
    profile/, user/  Profile and user data
    receipts/        Receipt scan, AI extraction, gallery
    settings/        Settings pages and preferences
    stats/           Monthly stats and charts
  l10n/              ARB files and generated localizations
  widgets/           Shared widgets (charts, skeletons)
supabase/
  functions/         Edge functions
  migrations/        Database schema and RPCs
```

Features follow a clean architecture split:

- `domain/`: models, providers, repository interfaces
- `data/`: Supabase, Drift and service implementations
- `presentation/`: pages, widgets, view models, controllers

## Architecture

### Startup ([`lib/main.dart`](lib/main.dart))

1. Sentry bootstrap (skipped when `SENTRY_DSN` is empty)
2. Date formatting initialization
3. Firebase and FCM background handler
4. Supabase, with an offline-aware HTTP client
5. Offline sync manager start
6. Guest database and guest session load
7. `runApp` inside `SentryWidget` and `ProviderScope`

### Navigation ([`lib/core/navigation/app_navigation.dart`](lib/core/navigation/app_navigation.dart))

GoRouter handles the entry flows: `/getting-started`, `/onboarding`, `/account-choice`, `/login`, `/signup`, `/sign-in-choice`, `/reset-password` and `/verify-reset-code`. The app itself lives under `/home`. The other screens (stats, envelopes, wallets, categories, notifications, plans, settings) are opened from the home drawer as modal routes. A redirect sends users to the right place based on their auth and guest-session state.

### Data flow

- **Signed in**: screens read and write an account-specific Drift mirror. Mutations go into an outbox and upload in batches through Supabase RPCs, which are idempotent so retries are safe. Downloads use keyset pagination and a revision change feed. See [`docs/offline-sync-design.md`](docs/offline-sync-design.md).
- **Guest**: a separate Drift database with the same shape as the Supabase data. On sign-in, the guest snapshot is imported through the `import_guest_snapshot` RPC.
- **Financial logic** (wallet debits and credits, envelope funding and renewal, alerts) runs in Postgres functions defined in [`supabase/migrations`](supabase/migrations). Clients do not write tables directly.

## Backend

### Supabase Edge Functions

| Function | Purpose |
| --- | --- |
| [`process-finance-message`](supabase/functions/process-finance-message) | AI parsing of text and receipts into entries; enforces the daily quota |
| [`notifications-warning`](supabase/functions/notifications-warning) | Pushes pending envelope threshold alerts |
| [`notifications-reminder`](supabase/functions/notifications-reminder) | Daily reminder in each user's language |
| [`delete-user-data`](supabase/functions/delete-user-data) | Deletes user data and the account |

Edge function secrets:

- Supabase: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
- Firebase HTTP v1: `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
- Cron protection: `CRON_SECRET`
- AI provider: `AI_PROVIDER` (`gemini` or `qwen`) and the matching `GEMINI_*` / `QWEN_*` keys. See [`docs/ai-entry-setup.md`](docs/ai-entry-setup.md).

The app never receives an AI provider key.

### Database

Apply all migrations in [`supabase/migrations`](supabase/migrations) in order (for example with `supabase db push`) before deploying the functions or a new app build.

## Environment configuration

The app uses compile-time `--dart-define` values. Copy [`.env.example`](.env.example) to `.env` and fill it in:

```env
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
SENTRY_DSN=...
SENTRY_ENVIRONMENT=development
SENTRY_STARTUP_TEST=false

# Optional: AdMob (the ad slot is hidden when missing)
ADMOB_ANDROID_APP_ID=...
ADMOB_ANDROID_NATIVE_AD_UNIT_ID=...
ADMOB_IOS_APP_ID=...
ADMOB_IOS_NATIVE_AD_UNIT_ID=...
```

`SUPABASE_URL` and `SUPABASE_ANON_KEY` are required: the app fails at startup without them. `SENTRY_STARTUP_TEST=true` sends a test event on each launch, so turn it off after checking. AdMob details are in [`docs/admob.md`](docs/admob.md).

## How to run

### Prerequisites

- [FVM](https://fvm.app) with Flutter 3.38.7 (`.fvmrc`)
- Android Studio and/or Xcode set up for Flutter
- A Supabase project with the migrations applied and the edge functions deployed
- A Firebase project for push notifications

### Install and generate code

```bash
fvm flutter pub get
```

The generated `*.g.dart` files are not committed, so run code generation before the first build:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### Run

```bash
fvm flutter run --dart-define-from-file=.env
```

### Test and analyze

```bash
fvm flutter test
```

```bash
fvm flutter analyze
```

Integration tests (AdMob, store screenshots) live in [`integration_test/`](integration_test).

## CI/CD

[`.github/workflows/firebase-distribution.yml`](.github/workflows/firebase-distribution.yml) builds a signed Android release APK on pushes to `main` and distributes it through Firebase App Distribution. Signing is described in [`docs/android_release_signing.md`](docs/android_release_signing.md).

## Contributing

Read [`AGENTS.md`](AGENTS.md) before making changes. In short:

- Keep feature code in `lib/features/<feature>`, shared infrastructure in `lib/core`, and shared widgets in `lib/widgets`.
- Keep files under 200 lines, with one helper class or widget per file.
- Take colors and typography from the app theme; never hardcode them in widgets.
- Use `fvm flutter`, and rerun `build_runner` after changing annotated providers.

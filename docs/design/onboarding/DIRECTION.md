# Drala onboarding
## Brief
User direction: clear, calm, practical. Implement signup → language → currency → preset categories → starter wallets in the existing Flutter app. Keep Alexandria, regular body text, theme colors and current architecture. No generated imagery needed.
## Current app
Existing auth: heavy labels, 64px dead gap, avatar step. Keep: account creation, validation, consent, recovery, login, default wallet, all existing finance features. Lose: avatar onboarding (explicit request). No change to brand, icon, tabs or home metrics.
## Exploration
Drala is a pocket organizer (object/light/grotesque/green/shape): selected, because it extends the app’s rounded fields and calm tone.
Drala is a reading room (place/dark/serif/orange/colour-material): rejected, introduces an unrelated display face.
Drala is a departure sign (printed/colour-field/rounded/pink/illustration): rejected, too loud for repeated form entry.
User theme requirements override exploratory typography and history differentiation. No prior local history file exists.
## Tokens
Existing AppTheme: light #FEFEFE / #333333 / #606060 / #F3F3F3; dark #202123 / #F5F5F5 / #D0D0D0 / #2E3033. Accessible existing green tokens #006D4E / #54DEAC indicate progress and selection. Alexandria body regular, existing displaySmall 36, headlineMedium 29, title and body tokens. Margins 28; spacing 8, 16, 24, 32; radii 16 and capsule.
## Refused defaults
No dark-lime fintech hero, invented balance, generic stock illustration or dashboard card stack. Existing green is retained because matching the app is the explicit brief. No claim of a market-wide competitor audit.
## Content
Auth: Créer un compte; Nom d’utilisateur; Email; Mot de passe; confirmation when valid; legal terms; Suivant. Login: Se connecter; Email; Mot de passe; password recovery.
Language: Votre langue; Français, English, Malagasy, Deutsch, Español, Italiano.
Currency: Votre devise; searchable ISO currency codes using existing currency support.
Categories: Vos catégories; server category_presets; selectable income and expense presets.
Wallets: Vos portefeuilles; required main wallet plus cash, bank account and mobile money.
Use localized ARB copy in implementation.
## Signature
The five-part progress track fills as the user assembles their account. Selection checks respond immediately with selection haptic; progress updates immediately, including with reduced motion enabled. No entrance animation for every row.
## Scope
Auth and onboarding only. Existing icon retained. Mockups are layout studies; actual Flutter tests are authoritative for layout and persistence.

## Implementation and validation
- [x] Signup, password validation and progressive confirmation retained.
- [x] Legal consent and document links retained.
- [x] Login, password recovery and auth switching retained.
- [x] Avatar step removed from routing; old URL redirects to setup.
- [x] Language → currency → categories → wallets implemented.
- [x] Draft saved between steps; existing users bypass onboarding.
- [x] Default wallet and existing balances preserved.
- [x] Light/dark themes and normal Alexandria body weight used.
- [x] 24 Flutter tests passed, including small-screen keyboard reachability.
- [x] Analyzer clean for modified implementation and tests.
- [x] Disposable PostgreSQL tests passed for completion, retry, invalid input, account isolation, empty selections and anonymous rejection.

Applied `supabase/migrations/20261005192534_complete_onboarding.sql` to the linked Drala Supabase project on 2026-10-05. It adds a caller-scoped transactional RPC. Verified migration version 20261005192534, function signature, fixed search path, authenticated EXECUTE permission and denied anonymous EXECUTE permission on live Supabase. Only new registrations carry `onboarding_required`; existing accounts are not forced through setup. Wallet ledger currency remains MGA; the selected currency is the app display currency, matching existing behavior. Preset category names remain the existing server-provided names; starter wallet names are stored consistently in English.

Studies: `shots/r2/sheet.png`; comparison: `shots/before-after/sheet.png`. Actual Flutter renders: `test/features/onboarding/presentation/goldens`. Studies do not reproduce every control/state exactly. R2 mechanical scan: no FAILs; three-size hierarchy is deliberate, and signup safe-area warning refers to scroll-hidden content.

Independent rubric: round 1 three of twelve dimensions >=4; round 2 six of twelve >=4. The skill's award-level threshold was not met; preserving the user's current-app direction takes precedence over introducing ornamental identity changes. All concrete implementation defects from review were addressed. Real-device motion, haptics and live auth/email delivery are unverified. No outstanding design decision is required.

## Settings consistency follow-up — 2026-10-07

The onboarding currency step and Settings currency page now render the same
`CurrencyChoiceList`, including the compact search field, ISO code and symbol
rows, selection check, pending state, scroll fade and filtering behavior. The
selected currency is revealed on entry and re-anchored when remote rates
replace the fallback list. Every onboarding action now renders the existing
`SettingsTransactionButton`, which keeps the current 40-point button height,
six-point radius and theme-defined typography in light and dark modes.

Actual light and dark Flutter renders confirm that the selected currency is
visible and the action remains clear at 375 by 667. The focused onboarding and
shared Settings widget suite passes 21 tests; static analysis and the diff
whitespace check pass.

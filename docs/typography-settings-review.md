# Typography and settings review

The shared scale follows the redesigned home, activity, and settings screens.
Equivalent roles use Alexandria at regular weight. Color comes from the active
light/dark theme. Financial amounts retain Inter where it was already meaningful.

| Role | Logical size | Shared source |
| --- | ---: | --- |
| Page heading | 20 | `AppTextRole.pageTitle` / `textTheme.titleLarge` |
| Sheet or dialog heading | 18 | `AppTextRole.sheetTitle` / `textTheme.titleMedium` |
| Section heading, row title, body | 12 | `sectionTitle`, `body` |
| Supporting text | 11 | `supporting` / `textTheme.bodySmall` |
| Caption and chart axis | 10 | `caption` / `textTheme.labelSmall` |
| Input and button | 14 | `input`, `button` |
| Profile name | 16 | `profile` |
| Display amount input | 24 | `AppTypography.display` |

The larger balance (36), net amount (28), and onboarding display (24/32) retain
intentional hierarchy. Compact badges/donut annotations use 8; dense legacy chart
helpers retain their 9–10 tick labels. Emoji artwork and currency suffixes are
sized for their containers rather than treated as ordinary body text.

## Shared implementation

- `lib/core/ui/app_typography.dart` defines the scale.
- `app_text_role.dart` names semantic roles; `app_text_style.dart` provides
  const-friendly styles with the common family and regular weight.
- `app_text_theme.dart` maps Material roles and preserves numeric typography.
- Feature theme adapters use the shared tokens; older forms, dropdowns, dialogs,
  planning, categories, transactions, authentication, and navigation use the roles.
- Long rendering implementations were separated into focused files to meet the
  repository's 200-line limit. Data and navigation behavior remain in their
  existing owners.

## Settings changes

- Plain tinted background, grouped rounded cards, and localized Profile,
  Preferences, and Legal headings.
- Language and receipts precede Legal in Preferences.
- The default-wallet entry is removed from signed-in and guest settings.
  Wallet data, default-wallet behavior, and the wallet editor remain intact.
- Larger avatar and a moderate 16-point profile name.
- Choice rows have consistent icon/label alignment and card padding.
- Currency settings use grouped choice cards and an accessible selected state;
  the onboarding selector keeps its existing presentation.
- Notification captions use muted supporting text. Notification/settings
  switches use the envelope renewal control's adaptive treatment and sizing.
- Profile account actions use grouped cards. Confirmation dialogs have visible
  inset inputs and scroll when their content or keyboard requires it.

## Simulator coverage

| Destination | Observed coverage |
| --- | --- |
| Main settings | Avatar/name, sections, order, default-wallet removal |
| Profile editor | Avatar, name field, save layout, account-action rows |
| Photo source sheet | Gallery/camera choices; no permission or upload |
| Password editor | Labels, inputs, spacing; no credentials entered |
| Notifications | Active/inactive switches, muted caption, reminder-time picker |
| Currency | Search, row padding, selection; no currency change |
| Theme | Selected state and grouped cards; no theme change |
| Language | Selected state, flags, grouped cards; no language change |
| Receipts | Empty gallery; populated cards covered by widget tests |
| Terms and privacy | Both hosted documents opened in the simulator browser |
| Categories and wallets | Lists and add forms; no save or financial action |
| Notification inbox | Empty state and manage-notifications shortcut |
| Account confirmations | Both dialogs viewed and cancelled; no deletion |
| Sign out | Entry inspected; sign out not executed to preserve the session |

Representative home, populated activities, statistics, envelopes, and form screens
were inspected. Light/dark semantic parity and narrow large-text layouts are
covered by tests. Conditional advertising privacy UI was not available in the
live session; its visibility/callback path is covered by a widget test.

## Verification

58 focused tests passed. The suite includes semantic-role parity, numeric fonts and input,
authentication typography, navigation, settings actions/localization, native
switch rendering parity (active/inactive/disabled), currency accessibility,
receipt cards, onboarding currency behavior, and responsive main screens.
Existing golden baselines were not regenerated. Analysis retains pre-existing
warning (an unused catch variable in `authentication_utils.dart`) and existing
deprecation/lint notices outside this task; application sources and the new tests
have no analyzer errors. No commit or push was made.

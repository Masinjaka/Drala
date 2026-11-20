# Google Play screenshots — Drala (`budgets`)

French sets: phone, 7-inch tablet and 10-inch tablet, 8 screenshots each,
9:16, 24-bit PNG, no alpha channel. Checked with `validate-exports` against the Google Play rules
(verified 2026-11-20): 0 errors, 0 warnings.

Upload them to Play Console › Store listing › Phone screenshots in this order (the euro amounts on 7 use a demo rate of 1 € = 5,150 Ar):

| # | File | Tag · Headline · Subline | Feature shown | Alt text |
|---|------|--------------------------|---------------|----------|
| 1 | `phone/01_ai.png` | SAISIE PAR IA · Une phrase, c’est noté · L’IA enregistre vos revenus et vos dépenses | AI entry: a typed sentence over today's income and expenses (needs an account) | Saisie d’un revenu et d’une dépense en une phrase |
| 2 | `phone/02_overview.png` | BILAN DU MOIS · Votre mois en un coup d’œil · Revenus, dépenses et catégories, mois par mois | Monthly stats: net, income/expenses, daily chart, category donut | Bilan mensuel des revenus, dépenses et catégories |
| 3 | `phone/03_receipt.png` | SCAN DE REÇUS · Scannez vos reçus · Photo ou fichier : la dépense est ajoutée | Receipt scan or file import (needs an account) | Option pour numériser un reçu |
| 4 | `phone/04_envelopes.png` | ENVELOPPES · Un budget par enveloppe · Un plafond par catégorie, chaque mois | Monthly envelopes, with the over-budget card enlarged | Enveloppes budgétaires mensuelles |
| 5 | `phone/05_wallets.png` | PORTEFEUILLES · Tous vos comptes, un seul solde · Espèces, banque, mobile money… | In-app wallets; their total is the home balance | Portefeuilles espèces, banque et mobile money |
| 6 | `phone/06_categories.png` | CATÉGORIES · Vos catégories, à votre façon · Créez les vôtres avec icône et couleur | The create-category sheet (icon, colour, name), with the name field “Animaux” enlarged | Création d’une catégorie personnalisée |
| 7 | `phone/07_currency.png` | MULTIDEVISE · Ariary, euro… vous choisissez · Montants convertis dans la devise choisie | Home displayed in euros, plus the currency picker (Ariary ✓, USD, AUD, CAD) | Accueil affiché en euros et choix de la devise |
| 8 | `phone/08_reminders.png` | NOTIFICATIONS · Rappels et alertes · Un rappel chaque jour, une alerte avant de dépasser | Budget alerts plus daily-reminder settings | Alertes de budget et rappels quotidiens |

## Tablet screenshots

Same 8 panels, same order, copy and alt text as the phone set, but every
screen is captured from the app running on a tablet (Pixel Tablet emulator,
portrait 1600 × 2560).

| Folder | Play Console slot | Size |
|--------|-------------------|------|
| `tablet-7/` | 7-inch tablet screenshots | 1080 × 1920 |
| `tablet-10/` | 10-inch tablet screenshots | 1440 × 2560 |

On the tablet, panel 6 shows the category list with the create form
(icon, colours, name) enlarged, and panel 7 enlarges Ariary ✓, USD, AUD, CAD.

## Feature graphic (« Image de présentation »)

`feature-graphic/feature-graphic.png`: 1024 × 500, 24-bit PNG, no alpha.
Upload it to Play Console › Store listing › Feature graphic.

- **Tag:** SUIVI DE BUDGET AVEC IA
- **Headline:** Votre argent, enfin clair
- **Subline:** Revenus, dépenses, enveloppes et portefeuilles au même endroit
- **Alt text:** Drala, suivi de budget avec IA : solde, saisie par phrase, statistiques et enveloppes

It follows Google's feature-graphic rules: no device frames, key text centred
away from the cut-off zones, a vivid background (not white or dark grey), and
no ranking or price words. The four cards are real crops from the Android
captures. The source is `store-assets/design/feature-graphic/feature-graphic.html`;
to regenerate it, render the page at 1024×500 with headless Chrome and flatten
the result to RGB.

## Provenance
- **Screens**: captured from the app running on an Android emulator
  (`Drala_Store_Phone`, API 35, 1080×2400 @ 420 dpi), by
  `integration_test/store_screenshots_test.dart`. The data is fictional demo
  data (`store/tool/demo_seed.dart`), kept in memory and never written to a
  real account or to production. Tablet screens come from the same test on
  the `Pixel_Tablet` AVD switched to portrait (`adb shell wm size 1600x2560`),
  decoded into `store-assets/captures/android-tablet/fr/`; the compositions
  carry a `formats.tablet` override (tablet frame and crop regions).
- **Design**: editable sources in `store-assets/design/` (config, copy,
  compositions), rendered with the store-screenshot-designer skill. Analysis,
  previews and reports are in `store-assets/`.

## Regenerate
```bash
fvm flutter test integration_test/store_screenshots_test.dart -d emulator-5554 -r expanded > /tmp/store.log
# decode the STOREPNG lines from the log into store-assets/captures/android/fr/ (see store-assets/reports/execution-report.md)
~/.claude/skills/store-screenshot-designer/scripts/render-screenshots .
~/.claude/skills/store-screenshot-designer/scripts/validate-exports .
```

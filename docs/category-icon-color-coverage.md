# Category icon color coverage

All saved category icons use `CategoryIcon` and the shared
`AppCategoryIconTheme` resolver. The resolver keeps readable colors exactly,
otherwise changes only lightness until the icon reaches 3:1 contrast against
its actual surface. It preserves hue and adds no icon backplate.

| Surface | Saved color source |
| --- | --- |
| Home recent transactions and Activities | `FinanceEntry.categoryColor` |
| Home envelope cards and envelope headings | `Envelope.color` |
| Transaction lists/details/category fields/chips | `Category.color` |
| Manual entry and envelope category selectors | `ManualEntryCategory.colorHex` |
| Stats category rows | `CategoryStat.colorHex` |
| Budgets, goals, history and their category selectors | Linked `Category.color` |
| Category grid, editor preview and icon picker | Saved/current category color |
| Legacy dropdowns and savings category preview | Linked category color |

Signed-in recent and dated transaction queries now select category `color`;
previously their UI models supported it but the read queries omitted it.
Initial edit-form category models also retain the entry's saved color. Older
planning queries now retain `icon_key` alongside emoji and color.

Icon slot sizes and layouts are retained. Removed category-specific circular
backdrops in lists/details; the colored outline sits directly on its surface.
Selected chips pass their own background to the resolver. Explicit button
icon color overrides are respected so category previews and color swatches
remain accurate in dark mode.

Transfer/wallet/action icons and decorative onboarding illustrations do not
represent saved categories and retain their existing meaning. Icon picker
catalogs use the current category color when opened from the category editor.
No saved category colors, financial data or preferences were changed.

## Verification

- 85 focused tests pass, including query projection and mapping for both
  income and expense, color propagation through 11 widget surfaces in both
  themes, icon contrast/hue, responsive layouts, category dismissal, envelope
  editing, stats, Home and Activities.
- Full static analysis: no errors; one existing unused catch-variable warning
  in `authentication_utils.dart`, plus existing informational notices.
- `git diff --check` passes. Every changed source file remains below 200 lines.
- Simulator checked in the existing light theme: Home, Activities, transaction
  edit form, envelope cards and edit form, and Stats category rows. No form
  was saved. Categories is open for review.
- No commit or push.

## Envelope sizing and stats percentage refinement

- Shared category icon size is 24 logical pixels, matching the category grid.
  Home envelope icons changed from 30 to 24; Envelopes-page icons from 32 to 24.
  Existing icon slots and card layout dimensions remain unchanged.
- Statistics category percentage badges use `AppStatsTheme.background`, the
  exact token used by `FinanceStatsPage` for its page background. Percentage
  foregrounds retain contrast in both themes; category icon/chart colors remain.
- 20 focused tests pass for sizes, colors, badges and responsive layouts across
  both themes. Focused analysis is clean, as is `git diff --check`.
- Restarted the simulator and visually verified Home, Envelopes and Statistics
  category cards. Left Statistics > Categories open for review. No data changes.

# Danger colors and category grid review

- Danger colors now come from `AppDangerTheme` through the light/dark
  `ColorScheme`. Dark mode uses muted rose with a deep red foreground;
  light mode uses deep red with a white foreground.
- Error text, delete swipes, negative balances, budget warnings, feedback
  annotations, and error toasts use centralized semantic colors. Inverse
  toast surfaces use the corresponding contrast-safe danger pair.
- Financial expense chart series have one muted theme-owned red. Existing
  category palettes retain their distinct categorical colors.
- Danger icons retain their semantic color in dark mode, including icons
  displayed on filled danger buttons.
- The dark navigation selected pill uses the exact scaffold background.
  The light selected pill remains `0xFF353333`. Category tabs call the same
  selection token.
- Category icons render consistently as plain outlines without backplates.
  Saved hues are retained; low-contrast swatches receive only the minimum
  lightness adjustment needed for 3:1 contrast. Saved data stays unchanged.
  Already readable colors render exactly; missing/invalid legacy colors use
  the theme accent.
- Fixed sheet dismissal: the lock refresh now uses a synchronous block in
  `setState`, avoiding the Future-returning assignment expression.
- Categories remain a lazy grid: two columns on phones, up to four on wider
  layouts. Cards share the settings/home surface, radius 24 and padding 16.
  Height grows with text scaling.
- The two-choice category control shares the envelope month carousel's
  surface, radius, shadow, width, base height and animation timing. It
  supports taps and horizontal swipes and follows body-page swipes.
- Savings category edit protection remains in place; lock queries are
  cached for rendering and refreshed when an editor closes.
- Chart helpers were split into library parts to keep each source file
  below 200 lines while preserving their public API and aggregation logic.

## Validation

- 60 focused Flutter tests pass. Coverage includes danger and toast
  contrast, shared navigation selection in both modes, chart totals,
  saved category icon colors, add/edit close/back/barrier dismissal and
  reopening, category add/edit flows, 320/1024 layouts at 2x French text, carousel and
  body swipes, destructive dialogs, transaction editing, stats and notices.
- Full Flutter analysis: zero errors; the existing unused catch variable
  warning in `authentication_utils.dart` remains, along with existing infos.
- `git diff --check` passes.
- Simulator: inspected dark navigation, category expense/income grids,
  an existing category editor, and its delete confirmation. Cancelled the
  confirmation. No category was saved or deleted and no preferences changed.
- After restarting with the fix, opened and closed both Add and Edit sheets
  in the simulator without errors. Debugger remained running. Left Categories
  open for review.
- No commit or push was made.

## Icon background correction

The previous automatic contrast backing caused dark circles on paler icons.
Removed the wrapper and background treatment for every category. All icons
share the same outline rendering, including legacy emoji mappings. Verified
both expense and income grids in the light-mode simulator and left Categories
open. 19 focused tests pass, covering light/dark icon contrast and hue, plain
icon presentation, sheet dismissal, tabs and responsive layouts.

# Onboarding design critique

Independent critic, 2026-10-05. The user prioritizes Drala's current theme and
"clear, calm, practical" over creating a new identity. Scores are honest
app-designer rubric scores, not a claim of award readiness.

## Round 1

Reviewed each of seven individual PNGs in `shots/r1`.

| Rubric | Score | Visible evidence |
|---|---:|---|
| Concept on the pixel | 2 | Heading-and-rows layout could serve almost any setup wizard. |
| Not the category average | 3 | Avoids invented balances and fintech illustrations; forms remain conventional. |
| Not this skill's average | 3 | Alexandria softens the grey fields and ruled lists. |
| Hierarchy | 4 | Large titles lead consistently. |
| Typography | 4 | Distinctive face and clear size contrast. |
| Colour | 3 | Selection barely uses green; dark dividers are too bright. |
| Richness | 2 | Little material or shape beyond rounded fields. |
| Rhythm and space | 4 | Comfortable margins, groups and lower action placement. |
| Craft details | 3 | Selected rows shift label indentation; text checkmarks are inconsistent. |
| Native fluency | 3 | Comfortable touch rows, but missing back controls. |
| Signature | 1 | No interaction or storyboard visible. |
| Feature test | 2 | Useful, restrained, without a memorable visual moment. |
| Fidelity | 2 | Studies omit confirmation/rules, consent control and auth switching. |

Five requested changes:

1. Complete auth controls and switching in a scrollable form.
2. Remove login progress, add back affordances and explicit final action copy.
3. Stabilize label indentation and distinguish single/multiple selection.
4. Use green for selected controls, quiet dark dividers and show selection counts.
5. Show a modest selection-feedback storyboard without unrelated imagery.

No before PNGs were supplied. Fidelity here judges the explicit keep list
against incomplete studies, not actual implementation.

**Not done by the stop rule in critique.md.**

## Round 2

Reviewed all eight small-phone studies in `shots/r2` and all twelve actual
Flutter light/dark frames in
`test/features/onboarding/presentation/goldens`. Actual Flutter UI takes
precedence over the studies. Frame indexes: 0 login, 1 signup, 2 language,
3 currency, 4 categories, 5 wallets.

| Rubric | Score | Visible evidence |
|---|---:|---|
| Concept on the pixel | 2 | The practical setup sequence remains a conventional wizard. |
| Not the category average | 3 | Restrained forms keep Drala's existing identity without fintech decoration. |
| Not this skill's average | 3 | Rounded Alexandria and open native rows avoid austere ruled-paper styling. |
| Hierarchy | 4 | Clear 36-point headings lead each actual screen above 15-point body content. |
| Typography | 4 | Consistent app typography; signup title wraps cleanly at small width. |
| Colour | 4 | Green selected controls and progress work in both themes; dividers are subdued. |
| Richness | 2 | Surfaces and selected states remain intentionally minimal. |
| Rhythm and space | 4 | Stable margins and anchored actions survive 375-by-667 frames. |
| Craft details | 4 | Actual vector controls align consistently; no unintended visible collisions. |
| Native fluency | 4 | Search, password visibility, back controls and checkbox/radio semantics read clearly. |
| Signature | 2 | Selection-feedback study is clearer, but remains familiar feedback rather than a signature. |
| Feature test | 2 | Coherent and usable; no distinctive editorial visual moment. |
| Fidelity | 3 | Actual auth switching/recovery and main wallet are visible; offscreen signup controls need interaction verification. |

Six of twelve rubric lines score at least four. Fidelity is provisional:
the author reports confirmation, consent and progressive password validation
in the scrollable implementation, but these frames cannot verify them.

### What landed

1. Auth switching is visible in actual Flutter frames; confirmation and consent
   are reported below the fold. Their behavior is not judged from pixels.
2. Actual login has no progress; back controls appear where applicable and
   the final action reads "Start using Drala".
3. Actual selection controls have stable indentation and distinguish multiple
   selections using square checkboxes.
4. Accessible theme greens replace the original green; dark separators are
   quieter. A count exists in the feedback study, not the shown actual frames.
5. The selection study shows two selected rows and count feedback. Static
   images do not verify timing or haptics.

### Concrete follow-ups, in priority order

1. Currency's initial viewport shows AUD through EUR with no visible current
   selection. Pin the selected currency or show a compact selected-code
   caption so Continue never accepts a visually undisclosed default.
2. Verify signup scrolling with the keyboard open: confirmation, consent,
   validation errors and their focus targets must remain reachable above
   the anchored action. The current partial password field is a legitimate
   scroll boundary, not by itself an overflow defect.
3. Show selected counts on actual categories/wallets if those lists become
   long enough that checked items scroll out of view. This is optional polish.
4. Verify a selected category frame with a long translated title and a full
   real category list; current goldens use two fixture items.
5. Keep studies labeled as studies: their French currency names and oversized
   check glyphs do not exactly match actual code-only currency rows and native
   controls. Actual rendered Flutter frames are the implementation evidence.

No unintended text collision or overflow was visible in the actual frames.
Device safe areas, keyboard behavior, motion and real-device feel remain
outside what these static widget renders can prove.

### Deliberate constraints and scanner warnings

- Broader richness or identity changes are declined because the user explicitly
  asks to match the current app. Do not replace its font or palette to inflate
  novelty scores.
- Three type sizes are deliberate: the 36-versus-15 hierarchy is visible and
  adequate for this focused flow.
- HTML scroll-hidden text warnings refer to content outside the visible scroll
  viewport; fixed actions are marked separately. This rationale does not
  substitute for testing scroll reachability in Flutter.
- The skill's done threshold is not reached; do not claim otherwise. There is
  no consecutive-round plateau because several scores improved. Prioritize
  the functional disclosure and verification items over ornamental iteration.

**Not done by the stop rule in critique.md; theme-constrained practical design
with improved controls and remaining verification items.**

## Post-review verification
Selected currency is now pinned above the filtered list. The small-phone keyboard test passes with password confirmation and consent reachable. Final behavior suite: 24 passing tests. Database fixture tests also pass. These targeted fixes are verified but not assigned new aesthetic scores.

## Follow-up: Settings consistency, 2026-10-07

Reviewed all eight actual Flutter frames, `light-2.png` through `light-5.png`
and `dark-2.png` through `dark-5.png`, at 375 by 667.

The compact bottom action is visually consistent across all four steps:
same width, small corner radius, 40-point height and lower inset. Labels
remain readable without clipping. Currency search and symbol rows align
cleanly; the bottom scroll fade clears the action in both themes. No text
collisions or obscured actions are visible. Settings parity is supported by
the reported shared components; no separate Settings render was supplied.

One concrete issue remains in these new currency frames: the initial list
shows AUD through EUR without any visible selected currency. The earlier
post-review note about a pinned selection is not reflected in these renders.
If a default is already selected below the viewport, reveal it by initially
scrolling to that row or show its code in a small selection summary. This
preserves the shared Settings row design while making Continue's effect clear.

The 40-point action height is the user's requested existing app style; it is
not treated as a visual defect. Static renders establish visible placement,
not hit-area size, keyboard reachability or scroll behavior. No new aesthetic
scores were assigned for this narrowly scoped consistency follow-up.

## Resolution re-check, 2026-10-07

Independently reopened the current actual Flutter `light-3.png` and
`dark-3.png`. The selected-currency disclosure issue is fixed in both:
the visible list now includes MGA / Ar with a clear green check, between
KES and USD. The selection is fully inside the viewport and outside the
scroll fade. The shared compact Continue action, search field, symbol rows
and spacing remain consistent with the preceding review. No collisions,
clipped labels or obscured action are visible. No additional concrete visual
defects were found in these two frames. This resolves the narrow follow-up;
it does not change the earlier broader aesthetic scores or verify gestures.

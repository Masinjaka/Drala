# Bug Reports

Extracted from the handwritten notes.

## BUG-001: Unable to edit income transactions

**Status:** Fixed.

Income edits now adjust the credited wallet by the amount difference. Legacy transaction category lookup also uses the transaction type.

**Issue:** Income transactions cannot be edited.

**Expected behavior:** Users should be able to edit an existing income transaction.

## BUG-002: Wallet selection does not update the default currency

**Status:** Fixed.

Wallet selection displays balances and the required amount in the selected currency.

**Issue:** The bottom sheet that displays the wallets to choose where the expense should be taken from still displays the amounts in the default currency even though i have chosen another currency

**Expected behavior:** The currency should update to match the selected one.

## BUG-003: Calendar returns to the wrong focused date

**Status:** Fixed.

The week pager starts at the currently focused date when the month view collapses.

**Issue:** After expanding the calendar from week view to month view and then collapsing it back to week view, the calendar sticks to the default week view and changes the focused date.

**Expected behavior:** Switching between month and week views should preserve the previously focused date.

## BUG-004: Sign in from the settings page go straight to the actual login page instead of giving the option to signup as well.

**Status:** Fixed in code. Guest settings opens a login or sign up choice without the guest option.

**Issue:** When tapping on the "Sign in" button in the setting page in Guest mode, we are taken to a login page instead of the login or sign up initial page.

**Expected behavior:** Tapping on that button should bring us to the page where users can login or sign up without the guest mode option.

## BUG-005: The amount stays in MGA even though I changed the currency to something else, and it mentions that exchange rates are unavailable.

**Status:** Fixed. Anonymous exchange-rate access is enabled on Supabase, and updated rates are cached locally for offline guests. The anonymous API returned the latest MGA snapshot with 166 currency rates after the migration.

**Issue:** In guest mode, When I change the currency, it doesn't take effect and stays in MGA (default).

**Expected behavior:** Currency exchange rates should remain available in guest mode. The updated exchange rates should be cached locally everytime it updates, that way, even if the user is offline, the app can use the cached exchange rate.

## BUG-006: The title of the setting page has a different typography than the other pages.

**Status:** Fixed in code. The settings title uses the app's page title theme.

**Issue:** The typography of the title of the setting page is different fron the other pages.

**Expected behavior:** It should be the same as the other pages, and the app should always have a consistent style accross every pages.

## BUG-007: The design of the notification button in the settings page is different from the one in the activities page

**Status:** Fixed in code. Both headers use the shared notification button style.

**Issue:** The design of the notification button in the setting page has changed, it is not like the one in the activities page.

**Expected behavior:** It should be consistent and thus, have the exact same design as the one in the activities page.

## BUG-008: The design of the notification button in the settings page is different from the one in the activities page

**Status:** Duplicate of BUG-007; fixed in code.

**Issue:** The design of the notification button in the setting page has changed, it is not like the one in the activities page.

**Expected behavior:** It should be consistent and thus, have the exact same design as the one in the activities page.

## BUG-009: The error is shown on plain text to the user

**Status:** Fixed in code. Failed category deletion keeps the category list visible and shows a localized toast.

**Issue:** WHen I tried to delete a category that is in use, the error "error: Bad state: Category is in use." is being displaid in plain text to the user in the category page.

**Expected behavior:** That error should be shown in a user-friendly way in the error Toast.

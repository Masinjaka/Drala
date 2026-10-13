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

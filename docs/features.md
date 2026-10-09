## Manually add transaction
- [x] Use the same bottom sheet as the "Edit transaction" for manually adding transactions.
- [x] The bottom sheet containing the menu for manually adding transactions should be dismissable when tapping outside of that bottom sheet
- [x] The font of the menu in the manual transaction bottom sheet should not be bold but regular font weight

## Envelope
- [x] The bottom sheet for adding a new envelope should be exactly the same as the bottom sheet for editing transactions
- [x] When adding an envelope, there should be an option to spread the envelope monthly and so, it resets every month.
- [x] Redesign the envelope card to match the desing in the screenshot `envelope-card-design.png`
- [x] Next to the month caroussel, add a calendar button that follows the design language and pattern of the app, that when tapped, allows the user to pick a month and year from the date picker roulette bottom sheet (The one used in the home page for picking dates).
- [x] Reduce the sizes of the add and return buttons in the header to match the sizes of the burger menu buttons in the home page
- [x] Envelope should be editable by tapping on the envelope card and bringing up the same bottom sheet as for adding it, and add a delete button as well just like for editing transaction entry.
- [x] Display the Year above the month caroussel on the top right of it.
- [x] The horizontal paddingof the back and add button in the header of the envelope page should be the same as the horizontal padding of the content of the page.
- [x] For the loading skeletons, instead of the whole cards being replaced by the skeleton, the real cards should already be there, only the values are replaced by skeleton while loading
- [x] The default month displayed in the month caroussel should be the current month.

## Stats
- [x] Next to the month caroussel, add a calendar button that follows the design language and pattern of the app, that when tapped, allows the user to pick a month and year from the date picker roulette bottom sheet (The one used in the home page for picking dates).
- [x] The stats page should have the same behaviour as the envelope page. The animations of the content of the page view, the fact that the datas adjacent to the active month are pre-loaded (for the month previous and next to the active month)
- [x] Animate the numbers the same way it is in the banner in the home page, and animate the charts as well on every page swipe
- [x] Add loading skeletons instead of the circular loading indicator. And for the skeleton, instead of the whole cards replaced with a skeleton, the real cards are already there with the title of them, but the values are the only thing replaced by skeletons while loading
- [x] Redesign the stats card to be like in the screenhot `stats-design.png`
- [x] Reduce the sizes of the add and return buttons in the header to match the sizes of the burger menu buttons in the home page. In fact, do that for every buttons that still doesn't have the same sizes in other active pages as well (Notification page, setting page, categpries page, wallet page, drawer )
- [x] Display the Year above the month caroussel on the top right of it.
- [x] The default month displayed in the month caroussel should be the current month.

## Design pattern and design language

- [x] In the following pages, apply the design pattern and design language of the home page and envelope page in term of theme, colors and sizes (only on the active pages, not the legacy ones that are not used anymore) : Category page, setting page, wallet page, notification page, setting sub-pages (edit profile page, change password page, notification setting page, currency page,default wallet page, theme page, language page, receipt page).
- [x] Apply the same animations as well in the above pages for lists and button feedback reactions, skeletons, etc...
- [x] In the pages mentioned above, the` add` and `Edit` functionalities should bring up the same bottom sheet as for Editing a transaction.
- [x] The dismissing animation of the bottom sheet for editing / manually adding transaction (as well as for the other similar bottom sheets) are too slow. It should dismiss quickly instead.
- [x] The text of the save button in the editing and manual adding of transaction should be white and not grey or black in light mode. and should be black on dark mode
- [x] Correctly implement the dark mode color contrast in the list of transactions in the home page, on dialogs, bottom sheets , every pages in this app including the subpages in the setting page. header buttons, All of the texts and Icons in this app, Cards and skeletons following the design skill you got.
- [x] In Dark mode, the skeleton in of the list items in the home is not clearly visible like on the other pages, so it needs to be fixed.
- [x] When entering or editing amounts everywhere in the app, automatically add the coma separators on thousands. That includes editing or adding transactions, envelopes, wallets.
- [x] Use a dark-mode background between the former near-black and the light-mode home banner gray, with card and skeleton shades adjusted for clear hierarchy.



## Category
- [x] The Expense and Income tabs design should be exactly the same design as in the Edit transaction bottom sheet. Pixel perfect.
- [x] The Icons in the cards are too much hidden in the right side, bring them out to the Left a bit.
- [x] In the legacy design, users were able to add subcategories within a category. Hide that feature for now.
- [x] Make sure that AI ALSO (Not exclusively) take into account the categories added manually by the user when it is adding a new transaction.

## Settings
- [x] The buttons and input fields in the settings page and all of the subpages should be designed exactly like the buttons and input field in the Edit transaction bottom sheet ( these are the common, design language and pattern of the app)
- [x] The font weight and sizes of the setting options (item lists) should match the font weight and sizes in the title of cards in the stats page (these are also the common design language and pattern)
- [x] The search currency input field should match the recent design changes (It is currently still rounded border). The log out button as well.
- [x] Write the app's version at the botton of the options in a small grey text, above the logout button.

## Wallets
- [x] The add or edit wallet bottom sheet layout should be the same as in the envelope page. (The amount field style and the rest...).


## AdMob integration
-[x] Integrate an AdMob Advanced Native ad after the final transaction in the home list, including after paginated transactions. Configure the App ID and ad unit ID through launch.json dart defines.

## Transaction entry
- [x] Allow users and AI to entre expenses even if there is 0 income. If there are no income, the negative expenses should be taken from the chosen default wallet (It will then have a negative value)
- [x] If it is not already the case, If users have allocated an envelope for a category and makes a transaction belonging to that category, the amount should be taken from the envelope instead of a wallet because normally the amount allocated in that envelope was already taken from a wallet.

## Notification
- [x] Fix the push notification for alerts on envelope budget almost reached , reached and exceeded. The implementation of notifications for these were already imopolemented but it doesn't work now.
- [x] The daily message notification should follow the language preferenc of the user. Currently it is only in french.

## App language and localization
- [x] Add Malagasy, German/deutch, Spanish, Italian languages.

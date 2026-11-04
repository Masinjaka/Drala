// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Over by $amount';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get changePassword => 'Change password';

  @override
  String get preferences => 'Preferences';

  @override
  String get notification => 'Notification';

  @override
  String get currency => 'Currency';

  @override
  String get setDefaultWallet => 'Set default wallet';

  @override
  String get defaultWalletLabel => 'Default';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get scannedReceipts => 'Scanned receipts';

  @override
  String get legal => 'Legal';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get adPrivacyOptions => 'Ad privacy choices';

  @override
  String get legalConsentPrefix => 'I agree to the ';

  @override
  String get legalConsentConnector => ' and the ';

  @override
  String get logOut => 'Log out';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get malagasy => 'Malagasy';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get italian => 'Italian';

  @override
  String get menu => 'Menu';

  @override
  String get collapseMenu => 'Collapse menu';

  @override
  String get expandMenu => 'Expand menu';

  @override
  String get activities => 'Activities';

  @override
  String get reports => 'Reports';

  @override
  String get profile => 'Profile';

  @override
  String get envelope => 'Envelope';

  @override
  String get stats => 'Stats';

  @override
  String get feedback => 'Feedback';

  @override
  String get resumeFromDate => 'Resume from a specific date';

  @override
  String get wallets => 'Wallets';

  @override
  String get addWallet => 'Add wallet';

  @override
  String get walletNameLabel => 'Wallet name';

  @override
  String get walletNameHint => 'e.g. Savings';

  @override
  String get currentBalanceLabel => 'Current balance';

  @override
  String get editWallet => 'Edit wallet';

  @override
  String get deleteWallet => 'Delete wallet';

  @override
  String get deleteWalletQuestion => 'Delete this wallet?';

  @override
  String get deleteWalletDescription =>
      'This wallet will be removed permanently. Its transaction history will remain intact.';

  @override
  String get walletUpdated => 'Wallet updated.';

  @override
  String get walletDeleted => 'Wallet deleted.';

  @override
  String get walletInUseCannotBeDeleted =>
      'This wallet is used by an envelope or transaction history and cannot be deleted.';

  @override
  String get allTime => 'All time';

  @override
  String get showBalance => 'Show balance';

  @override
  String get hideBalance => 'Hide balance';

  @override
  String get overallBalance => 'Wallet balance left';

  @override
  String takenFromEnvelope(String name) {
    return 'Taken from envelope $name';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications =>
      'You’re all caught up! We’ll keep you posted here.';

  @override
  String get noNotificationsDescription =>
      'Budget warnings and important finance updates will appear here.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'You went over your budget for the $name envelope.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'The $name envelope is almost spent.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'The $name envelope budget has been reached.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Today, $date';
  }

  @override
  String get noEntriesForDate => 'No entries for this date';

  @override
  String get emptyStateWelcomeBack => 'Welcome back!';

  @override
  String get emptyStateWelcomeTo => 'Welcome to';

  @override
  String get emptyStateIncomePrompt =>
      'Money just landed? Tell me about it so we can celebrate… and log it.';

  @override
  String get emptyStateExpensePrompt =>
      'Spent something fun (or necessary)? Spill how much and on what… I’m keeping the books.';

  @override
  String get emptyStateTransferPrompt =>
      'Moving money around? Tell me the from → to and I’ll make it happen.';

  @override
  String get firstEntryIncomePrompt =>
      'Start with an income or an expense. Try “I got paid xxx” or “I spent xxx on food” and I’ll record it.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count incomes',
      one: '1 income',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests => 'Unlimited AI requests with Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'You have $count AI requests remaining today';
  }

  @override
  String get chatHint => 'Your expenses…';

  @override
  String get startTyping => 'Start typing...';

  @override
  String get chatIncomeHint => 'Your income…';

  @override
  String get chatTransferHint => 'Transfer between wallets…';

  @override
  String expenseSuggestion(Object amount) {
    return 'I spent $amount on burgers';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'I received $amount from my salary';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Transfer $amount from Cash to Savings';
  }

  @override
  String get addReceipt => 'Add receipt';

  @override
  String get manualEntry => 'Manual entry';

  @override
  String get send => 'Send';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get importFile => 'Import file';

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get receiptGalleryEmpty =>
      'Your scanned and imported receipts will appear here.';

  @override
  String get deleteReceiptQuestion => 'Delete receipt?';

  @override
  String get deleteReceiptDescription =>
      'This removes every page of this receipt.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get receiptDeleted => 'Receipt deleted.';

  @override
  String get receipt => 'Receipt';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receipt pages',
      one: '1 receipt page',
    );
    return '$_temp0';
  }

  @override
  String pageCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get deleteReceipt => 'Delete receipt';

  @override
  String get save => 'Save';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get user => 'User';

  @override
  String get currentPassword => 'Current password';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get newPassword => 'New password';

  @override
  String get enterNewPassword => 'Enter your new password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmNewPassword => 'Confirm your new password';

  @override
  String get passwordsDoNotMatch => 'The new passwords do not match.';

  @override
  String get passwordMustDiffer =>
      'Choose a password different from the current one.';

  @override
  String get passwordUpdated => 'Password updated.';

  @override
  String get searchCurrency => 'Search currency';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get defaultWalletDescription =>
      'Expenses and new envelopes use this wallet by default.';

  @override
  String get walletSourceChooseAnother => 'Choose another wallet';

  @override
  String walletSourceAmountNeeded(String amount) {
    return 'The transaction needs $amount.';
  }

  @override
  String get walletSourceUseWallet => 'Use this wallet';

  @override
  String get walletSourceSaveWallet => 'Save wallet';

  @override
  String get walletSourceDefaultWallet => 'Default wallet';

  @override
  String get walletSourceInsufficientBalance => 'Insufficient balance';

  @override
  String get defaultWalletUpdated => 'Default wallet updated.';

  @override
  String get termsIntro => 'These terms explain the rules for using Drala.';

  @override
  String get termsDetails =>
      'Use Drala only for lawful personal finance management. You remain responsible for checking AI-created entries before relying on them. Service availability may change as the app evolves.';

  @override
  String get privacyIntro => 'Your financial information belongs to you.';

  @override
  String get privacyDetails =>
      'Drala stores account and transaction data to provide the app. Scanned receipts are kept in private per-user storage and are sent to the configured AI provider through the backend for extraction. You can delete individual receipts from Scanned receipts, or delete all stored data or your complete account from Edit profile.';

  @override
  String get legalLastUpdated => 'Last updated: July 21, 2026';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get dailyReminders => 'Daily reminders';

  @override
  String get budgetAlerts => 'Budget alerts';

  @override
  String get selectReminderTime => 'Select reminder time';

  @override
  String get preferredReminderTime => 'Preferred reminder time';

  @override
  String get reminderDeliveryTime => 'Daily reminder delivery time';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get notificationPermissionMessage =>
      'Allow notifications to receive daily reminders and budget alerts.';

  @override
  String get allow => 'Allow';

  @override
  String get deny => 'Deny';

  @override
  String get notificationsBlocked => 'Notifications blocked';

  @override
  String get notificationsBlockedMessage =>
      'Allow notifications in your device settings to receive reminders and alerts.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get deleteAllData => 'Delete all my data';

  @override
  String get deleteAllDataSummary =>
      'Deletes app data and files, but keeps your sign-in account.';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountSummary =>
      'Deletes your sign-in account, app data, and files.';

  @override
  String get deleteAllDataQuestion => 'Delete all data?';

  @override
  String get deleteAllDataDetails =>
      'Deletes transactions and wallet activity, non-default wallets, categories, envelopes, budgets and history, AI history, receipt scans, notification settings, profile details, and stored files. Your sign-in account remains. A zero-balance default wallet is kept or created. Your name is reset from your email, your photo is removed, and your currency resets to MGA.';

  @override
  String get deleteKeyword => 'DELETE';

  @override
  String get typeDeleteToConfirm => 'Type DELETE to confirm.';

  @override
  String get allDataDeleted => 'All your data has been deleted.';

  @override
  String get deleteAccountQuestion => 'Permanently delete account?';

  @override
  String get deleteAccountDetails =>
      'Deletes your sign-in account, profile, transactions, wallets and wallet activity, categories, envelopes, budgets and history, AI history, receipt scans, notification settings, and stored files. You will be signed out. This cannot be undone.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Type $value to confirm.';
  }

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get chooseSource => 'Choose a source';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get mediaPermissionMessage =>
      'We need camera and file access to continue.';

  @override
  String get cameraDenied => 'Camera access denied.';

  @override
  String get mediaDenied => 'Media access denied.';

  @override
  String get imageSelectionFailed => 'Could not select the image.';

  @override
  String get usernameUpdateFailed => 'Could not update the username.';

  @override
  String get profilePhotoUploadFailed => 'Could not upload the profile photo.';

  @override
  String get back => 'Back';

  @override
  String get enterEmail => 'Enter an email address';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get enterPassword => 'Enter a password';

  @override
  String get passwordMinLength =>
      'The password must contain at least 8 characters.';

  @override
  String get passwordNeedsUppercase =>
      'The password must contain at least one uppercase letter.';

  @override
  String get passwordNeedsLowercase =>
      'The password must contain at least one lowercase letter.';

  @override
  String get passwordNeedsNumber =>
      'The password must contain at least one number.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'The password must contain at least one special character.';

  @override
  String get passwordRuleMinLength => '8+ characters';

  @override
  String get passwordRuleUppercase => 'At least one uppercase letter';

  @override
  String get passwordRuleLowercase => 'At least one lowercase letter';

  @override
  String get passwordRuleNumber => 'At least one number';

  @override
  String get passwordRuleSpecialCharacter => 'At least one special character';

  @override
  String get netThisMonth => 'Net this month';

  @override
  String get transactions => 'Transactions';

  @override
  String get homeWelcome => 'Welcome';

  @override
  String get averagePerDay => 'Average / day';

  @override
  String get expenses => 'Expenses';

  @override
  String get income => 'Income';

  @override
  String get largestExpense => 'Largest expense';

  @override
  String get dailySpending => 'Daily Spending';

  @override
  String get topSpending => 'Top spending';

  @override
  String get noExpensesThisMonth => 'No expenses this month';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage% more than last month';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage% less than last month';
  }

  @override
  String get addEnvelope => 'Add envelope';

  @override
  String get createExpenseCategoryFirst =>
      'Create an expense category before adding another envelope.';

  @override
  String get monthlyEnvelopes => 'Monthly envelopes';

  @override
  String get availableAcrossEnvelopes => 'Available across envelopes';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Spent';

  @override
  String get newEnvelope => 'New envelope';

  @override
  String get name => 'Name';

  @override
  String get envelopeNameHint => 'e.g. Groceries';

  @override
  String get monthlyAmount => 'Monthly amount';

  @override
  String get expenseCategory => 'Expense category';

  @override
  String get saving => 'Saving…';

  @override
  String get create => 'Create';

  @override
  String get noEnvelopesYet => 'Give your plans a little room to grow.';

  @override
  String get envelopeEmptyDescription =>
      'Set a monthly amount for an expense category. Chat expenses will update it automatically.';

  @override
  String get deleteEnvelope => 'Delete envelope';

  @override
  String overBudgetBy(String amount) {
    return 'Over budget by $amount';
  }

  @override
  String amountSpent(String amount) {
    return '$amount spent';
  }

  @override
  String ofAmount(String amount) {
    return 'of $amount';
  }

  @override
  String get feedbackPrompt => 'Tell us what you think';

  @override
  String get feedbackHint => 'Describe an issue or share an idea';

  @override
  String get feedbackRequired => 'Please enter your feedback';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get feedbackSent => 'Feedback sent. Thank you!';

  @override
  String get availableBalance => 'Available balance';

  @override
  String get thisMonth => 'This month';

  @override
  String get operations => 'Operations';

  @override
  String get categories => 'Categories';

  @override
  String get deleteTransactionQuestion => 'Delete transaction?';

  @override
  String get deleteTransactionDescription =>
      'Are you sure you want to delete this transaction? This action is irreversible.';

  @override
  String get deleteBudgetQuestion => 'Delete budget?';

  @override
  String get deleteBudgetDescription =>
      'Are you sure you want to delete this budget? This action is irreversible.';

  @override
  String get deleteGoalQuestion => 'Delete goal?';

  @override
  String get deleteGoalDescription =>
      'Are you sure you want to delete this goal? This action is irreversible.';

  @override
  String get deleteCategoryQuestion => 'Delete category?';

  @override
  String get deleteCategoryDescription =>
      'Are you sure you want to delete this category? This action is irreversible.';

  @override
  String get categoryInUse =>
      'The category cannot be deleted because it is currently in use.';

  @override
  String get noActivitiesForDay =>
      'A little quiet today. Ready to track something?';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get expense => 'Expense';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get searchCategories => 'Search a category';

  @override
  String get done => 'Done';

  @override
  String get repeatEnvelopeMonthly => 'Repeat monthly';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Fund a fresh budget from the same wallet each month when funds are available.';

  @override
  String get editEnvelope => 'Edit envelope';

  @override
  String get aiRequestTimedOut =>
      'The AI request took too long. Please try again.';

  @override
  String get setupLanguageTitle => 'Your language';

  @override
  String get setupLanguageBody =>
      'Select your prefered language. You can always change it later in the settings.';

  @override
  String get setupCurrencyTitle => 'Your currency';

  @override
  String get setupCurrencyBody =>
      'Select your currency. You can also change this later in the settings.';

  @override
  String get setupCategoriesTitle => 'Your categories';

  @override
  String get setupCategoriesBody =>
      'These are a few of the usual categories. Select those you need. You can add custom ones in the settings as well.';

  @override
  String get setupWalletsTitle => 'Your wallets';

  @override
  String get setupWalletsBody =>
      'These are the places where you keep your money and where your expenses will be taken from. You can choose one of them to be your default wallet in the app. There is always a default one if you choose none. You can add more in the settings.';

  @override
  String get setupContinue => 'Continue';

  @override
  String get setupFinish => 'Start using Drala';

  @override
  String get setupCompleteTitle => 'You’re all set !';

  @override
  String get setupCompleteBody => 'Happy managing';

  @override
  String get setupDone => 'Nice';

  @override
  String get setupRetry => 'Try again';

  @override
  String get setupMainWallet => 'Main wallet';

  @override
  String get setupCash => 'Cash';

  @override
  String get setupBank => 'Bank';

  @override
  String get setupMobile => 'Mobile Money';

  @override
  String get authSignUp => 'Create an account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUpBody => 'A few details, then make Drala yours.';

  @override
  String get authSignInBody => 'Find your accounts and expenses.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authConfirmEmail =>
      'Check your email to confirm your account, then sign in to finish setup.';

  @override
  String get setupLoadError => 'Could not load the choices. Try again.';

  @override
  String get authResetInstruction =>
      'Enter your email and we’ll send you a verification code.';

  @override
  String get authResetCodeSent => 'Verification code sent';

  @override
  String get authCodeSentTo => 'A code was sent to';

  @override
  String get authVerificationCode => 'Verification code';

  @override
  String get authEnterSixDigitCode => 'Enter the 6-digit code';

  @override
  String get authResetButton => 'Reset password';

  @override
  String get authResetSuccess => 'Password reset successfully';

  @override
  String get guestWelcomeTitle => 'Take control of your money';

  @override
  String get guestWelcomeBody =>
      'Set up your budget in a few steps. You can start without an account.';

  @override
  String get guestGetStarted => 'Get started';

  @override
  String get guestChoiceTitle => 'How would you like to continue?';

  @override
  String get guestChoiceBody =>
      'Create an account to sync your budget, or keep it on this device for now.';

  @override
  String get guestContinue => 'Continue as guest';

  @override
  String get guestSyncNow => 'Sync now';

  @override
  String guestCurrencyRatePending(String preferred, String displayed) {
    return '$preferred is saved. Amounts stay in $displayed until exchange rates are available.';
  }

  @override
  String get guestCurrencyRateStillUnavailable =>
      'Exchange rates are still unavailable. Try again when you\'re online.';

  @override
  String get deleteEnvelopeDescription =>
      'Deleting this envelope returns its remaining funds to its wallet. Transaction history is preserved.';

  @override
  String get insufficientWalletFunds =>
      'The selected wallet does not have enough funds. Choose a wallet with a sufficient balance.';

  @override
  String get envelopeAmountBelowSpent =>
      'The envelope amount cannot be lower than the amount already spent.';

  @override
  String get monthlyScheduleNotLatest =>
      'Only the latest monthly envelope can change its renewal settings.';

  @override
  String get selectDate => 'Select a date';

  @override
  String get transfer => 'Transfer';

  @override
  String get fromWallet => 'From wallet';

  @override
  String get toWallet => 'To wallet';

  @override
  String get transferNeedsWallets =>
      'Add a second wallet to transfer money between wallets.';

  @override
  String get transferSaved => 'Transfer saved.';

  @override
  String get differentTransferWallets => 'Choose two different wallets.';

  @override
  String get walletCurrencyMismatch => 'Transfers require two wallets in MGA.';

  @override
  String get walletUnavailable =>
      'A selected wallet is no longer available. Choose another wallet.';

  @override
  String get transferConflict =>
      'This transfer was already submitted with different details. Open a new transfer.';

  @override
  String get selectItems => 'Select';

  @override
  String selectedItemCount(int count) {
    return '$count selected';
  }

  @override
  String get deleteSelectedItems => 'Delete selected';

  @override
  String deleteSelectedWalletsDescription(int count) {
    return 'Delete $count selected wallets? This cannot be undone.';
  }

  @override
  String deleteSelectedEnvelopesDescription(int count) {
    return 'Delete $count selected envelopes? Remaining funds return to their wallets. Transaction history is preserved.';
  }

  @override
  String get defaultWalletCannotDelete =>
      'The default wallet cannot be deleted. Choose another default wallet first.';

  @override
  String get envelopeUnavailable =>
      'A selected envelope is no longer available. Refresh the list.';

  @override
  String get operationInProgress =>
      'Please wait for the current operation to finish.';

  @override
  String get dailyReminderNotificationTitle => 'Daily reminder';

  @override
  String get dailyReminderNotificationBody =>
      'Remember to record your expenses or income today.';

  @override
  String get categoryNameRequired => 'Enter a category name.';

  @override
  String get envelopeNameRequired => 'Enter an envelope name.';

  @override
  String get envelopeCategoryRequired => 'Choose a category for this envelope.';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get positiveAmountRequired => 'Enter an amount greater than zero.';

  @override
  String get nonNegativeAmountRequired => 'Enter a balance of zero or more.';

  @override
  String get envelopeFundingWalletFixed =>
      'An existing envelope keeps its original funding wallet.';

  @override
  String get envelopeFundingWalletUnavailable => 'Funding wallet unavailable';

  @override
  String get home => 'Home';

  @override
  String get seeMore => 'See more';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get envelopes => 'Envelopes';

  @override
  String get noRecentTransactions =>
      'Add a transaction to start tracking your budget.';

  @override
  String get overviewLoadFailed => 'Unable to refresh. Tap to retry.';

  @override
  String get homeHello => 'Hi';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get networkUnavailable =>
      'Unable to reach the server. Check your internet connection and try again.';

  @override
  String get offlineModeToast =>
      'Connection lost. Offline mode is on. Your changes will sync when you reconnect.';

  @override
  String get onlineModeToast => 'Connection restored. Your changes are synced.';

  @override
  String get onlinePendingToast =>
      'Connection restored. Some changes still need your attention.';

  @override
  String get offlineStatus => 'Offline · changes saved on this device';

  @override
  String get syncingStatus => 'Syncing your changes…';

  @override
  String pendingStatus(int count) {
    return '$count changes waiting to sync';
  }

  @override
  String get offlineInitial =>
      'Connect to download your account data for offline use.';

  @override
  String get offlineSetupUnavailable =>
      'Sync is unavailable. Your local changes are safely stored on this device.';

  @override
  String get syncConflictTitle => 'Review changes before syncing';

  @override
  String get syncConflictMessage =>
      'Your cloud data changed while this device was offline. Review your pending changes before retrying, or use the cloud version.';

  @override
  String get offlineRetry => 'Retry';

  @override
  String get offlineReview => 'Review';

  @override
  String get offlineKeepCloud => 'Use cloud data';

  @override
  String get offlineRetryChanges => 'Sync these changes';

  @override
  String get offlineDiscardTitle => 'Discard changes saved on this device?';

  @override
  String get offlineDiscardBody =>
      'These changes have not reached the cloud. This removes them from this device and downloads the cloud version.';

  @override
  String get onlineRequired => 'This action needs an internet connection.';

  @override
  String get signInSyncRequired =>
      'Sign in again to continue syncing. Your local changes are kept.';

  @override
  String get categoryIconFood => 'Food & drinks';

  @override
  String get categoryIconShopping => 'Groceries';

  @override
  String get categoryIconTransport => 'Transport';

  @override
  String get categoryIconHousing => 'Housing';

  @override
  String get categoryIconHealth => 'Health';

  @override
  String get categoryIconUtilities => 'Utilities';

  @override
  String get categoryIconEntertainment => 'Entertainment';

  @override
  String get categoryIconEducation => 'Education';

  @override
  String get categoryIconSalary => 'Salary';

  @override
  String get categoryIconFreelance => 'Freelance';

  @override
  String get categoryIconIncome => 'Income';

  @override
  String get categoryIconOther => 'Other';

  @override
  String get categoryIconCoffee => 'Coffee';

  @override
  String get categoryIconDining => 'Restaurants';

  @override
  String get categoryIconTravel => 'Travel';

  @override
  String get categoryIconGifts => 'Gifts';

  @override
  String get categoryIconPets => 'Pets';

  @override
  String get categoryIconFamily => 'Family';

  @override
  String get categoryIconSubscriptions => 'Subscriptions';

  @override
  String get categoryIconPhone => 'Phone';

  @override
  String get categoryIconInternet => 'Internet';

  @override
  String get categoryIconSavings => 'Savings';

  @override
  String get categoryIconInvestment => 'Investments';

  @override
  String get categoryIconInsurance => 'Insurance';

  @override
  String get categoryIconTaxes => 'Taxes';

  @override
  String get categoryIconFitness => 'Fitness';

  @override
  String get categoryIconBeauty => 'Personal care';

  @override
  String get categoryIconClothing => 'Clothing';

  @override
  String get categoryIconRepairs => 'Repairs';

  @override
  String get categoryIconFuel => 'Fuel';

  @override
  String get categoryIconBicycle => 'Cycling';

  @override
  String get categoryIconBus => 'Public transport';

  @override
  String get categoryIconRain => 'Rainy day fund';

  @override
  String get categoryIconCharity => 'Donations';

  @override
  String get categoryIconMusic => 'Music';

  @override
  String get categoryIconBooks => 'Books';

  @override
  String get categoryIconTransfer => 'Transfers';

  @override
  String get chooseCategoryIcon => 'Choose an icon';

  @override
  String get searchCategoryIcons => 'Search icons';

  @override
  String get activitiesComposerHint => 'Tell me what you spent...';

  @override
  String get createEnvelope => 'Create envelope';

  @override
  String get trackYourBudget => 'Track your budget';

  @override
  String get emptyCategories => 'Make room for the things that matter to you.';

  @override
  String get emptyWallets => 'A home for your money starts here.';

  @override
  String get createCategory => 'Create a category';

  @override
  String get emptyExpenses =>
      'Small steps make a clearer budget. Let’s add your first expense.';

  @override
  String get emptyIncomes => 'Every income is a fresh start. Add yours here.';

  @override
  String get emptySearch =>
      'Let’s try another search to find what you’re looking for.';

  @override
  String get createExpense => 'Add an expense';

  @override
  String get createIncome => 'Add an income';

  @override
  String get resetSearch => 'Reset search';

  @override
  String get emptyBudgets =>
      'Give your spending a direction with your first budget.';

  @override
  String get emptyGoals =>
      'Big plans start with a little saving. What’s your first goal?';

  @override
  String get createBudget => 'Create a budget';

  @override
  String get createGoal => 'Create a goal';

  @override
  String get manageNotifications => 'Manage notifications';

  @override
  String get envelopeRemaining => 'Remaining';

  @override
  String get envelopeBudgetOf => 'of';

  @override
  String get statsNet => 'Net';

  @override
  String get statsNetDescription => 'Income minus expenses';

  @override
  String get statsNumbers => 'The numbers';

  @override
  String get statsCategories => 'The categories';

  @override
  String get statsOnAverage => 'on average';

  @override
  String get statsPreviousMonth => 'vs last month';

  @override
  String get statsEmptyCategories =>
      'Track an expense to see your spending by category.';

  @override
  String statsActivityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '1 activity',
    );
    return '$_temp0';
  }

  @override
  String get chooseCategoryColor => 'Choose a color';
}

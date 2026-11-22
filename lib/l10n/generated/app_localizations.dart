import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_mg.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('mg')
  ];

  /// No description provided for @envelopeOverBy.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String envelopeOverBy(String amount);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Drala'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @setDefaultWallet.
  ///
  /// In en, this message translates to:
  /// **'Set default wallet'**
  String get setDefaultWallet;

  /// No description provided for @defaultWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultWalletLabel;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @scannedReceipts.
  ///
  /// In en, this message translates to:
  /// **'Scanned receipts'**
  String get scannedReceipts;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @adPrivacyOptions.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy choices'**
  String get adPrivacyOptions;

  /// No description provided for @legalConsentPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get legalConsentPrefix;

  /// No description provided for @legalConsentConnector.
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get legalConsentConnector;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @malagasy.
  ///
  /// In en, this message translates to:
  /// **'Malagasy'**
  String get malagasy;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @collapseMenu.
  ///
  /// In en, this message translates to:
  /// **'Collapse menu'**
  String get collapseMenu;

  /// No description provided for @expandMenu.
  ///
  /// In en, this message translates to:
  /// **'Expand menu'**
  String get expandMenu;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @envelope.
  ///
  /// In en, this message translates to:
  /// **'Envelope'**
  String get envelope;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @resumeFromDate.
  ///
  /// In en, this message translates to:
  /// **'Resume from a specific date'**
  String get resumeFromDate;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add wallet'**
  String get addWallet;

  /// No description provided for @walletNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletNameLabel;

  /// No description provided for @walletNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Savings'**
  String get walletNameHint;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalanceLabel;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit wallet'**
  String get editWallet;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete wallet'**
  String get deleteWallet;

  /// No description provided for @deleteWalletQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this wallet?'**
  String get deleteWalletQuestion;

  /// No description provided for @deleteWalletDescription.
  ///
  /// In en, this message translates to:
  /// **'This wallet will be removed permanently. Its transaction history will remain intact.'**
  String get deleteWalletDescription;

  /// No description provided for @walletUpdated.
  ///
  /// In en, this message translates to:
  /// **'Wallet updated.'**
  String get walletUpdated;

  /// No description provided for @walletDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wallet deleted.'**
  String get walletDeleted;

  /// No description provided for @walletInUseCannotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'This wallet is used by an envelope or transaction history and cannot be deleted.'**
  String get walletInUseCannotBeDeleted;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @showBalance.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get showBalance;

  /// No description provided for @hideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide balance'**
  String get hideBalance;

  /// No description provided for @overallBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance left'**
  String get overallBalance;

  /// No description provided for @takenFromEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Taken from envelope {name}'**
  String takenFromEnvelope(String name);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up! We’ll keep you posted here.'**
  String get noNotifications;

  /// No description provided for @noNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Budget warnings and important finance updates will appear here.'**
  String get noNotificationsDescription;

  /// No description provided for @envelopeBudgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'You went over your budget for the {name} envelope.'**
  String envelopeBudgetExceeded(String name);

  /// No description provided for @envelopeBudgetAlmostReached.
  ///
  /// In en, this message translates to:
  /// **'The {name} envelope is almost spent.'**
  String envelopeBudgetAlmostReached(String name);

  /// No description provided for @envelopeBudgetReached.
  ///
  /// In en, this message translates to:
  /// **'The {name} envelope budget has been reached.'**
  String envelopeBudgetReached(String name);

  /// No description provided for @todayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String todayWithDate(Object date);

  /// No description provided for @noEntriesForDate.
  ///
  /// In en, this message translates to:
  /// **'No entries for this date'**
  String get noEntriesForDate;

  /// No description provided for @emptyStateWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get emptyStateWelcomeBack;

  /// No description provided for @emptyStateWelcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get emptyStateWelcomeTo;

  /// No description provided for @emptyStateIncomePrompt.
  ///
  /// In en, this message translates to:
  /// **'Money just landed? Tell me about it so we can celebrate… and log it.'**
  String get emptyStateIncomePrompt;

  /// No description provided for @emptyStateExpensePrompt.
  ///
  /// In en, this message translates to:
  /// **'Spent something fun (or necessary)? Spill how much and on what… I’m keeping the books.'**
  String get emptyStateExpensePrompt;

  /// No description provided for @emptyStateTransferPrompt.
  ///
  /// In en, this message translates to:
  /// **'Moving money around? Tell me the from → to and I’ll make it happen.'**
  String get emptyStateTransferPrompt;

  /// No description provided for @firstEntryIncomePrompt.
  ///
  /// In en, this message translates to:
  /// **'Start with an income or an expense. Try “I got paid xxx” or “I spent xxx on food” and I’ll record it.'**
  String get firstEntryIncomePrompt;

  /// No description provided for @entryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry} other{{count} entries}}'**
  String entryCount(num count);

  /// No description provided for @expenseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expense} other{{count} expenses}}'**
  String expenseCount(num count);

  /// No description provided for @incomeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 income} other{{count} incomes}}'**
  String incomeCount(num count);

  /// No description provided for @transferCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transfer} other{{count} transfers}}'**
  String transferCount(num count);

  /// No description provided for @unlimitedAiRequests.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI requests with Drala Plus'**
  String get unlimitedAiRequests;

  /// No description provided for @aiRequestsRemaining.
  ///
  /// In en, this message translates to:
  /// **'You have {count} AI requests remaining today'**
  String aiRequestsRemaining(Object count);

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Your expenses…'**
  String get chatHint;

  /// No description provided for @startTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing...'**
  String get startTyping;

  /// No description provided for @chatIncomeHint.
  ///
  /// In en, this message translates to:
  /// **'Your income…'**
  String get chatIncomeHint;

  /// No description provided for @chatTransferHint.
  ///
  /// In en, this message translates to:
  /// **'Transfer between wallets…'**
  String get chatTransferHint;

  /// No description provided for @expenseSuggestion.
  ///
  /// In en, this message translates to:
  /// **'I spent {amount} on burgers'**
  String expenseSuggestion(Object amount);

  /// No description provided for @incomeSuggestion.
  ///
  /// In en, this message translates to:
  /// **'I received {amount} from my salary'**
  String incomeSuggestion(Object amount);

  /// No description provided for @transferSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Transfer {amount} from Cash to Savings'**
  String transferSuggestion(Object amount);

  /// No description provided for @addReceipt.
  ///
  /// In en, this message translates to:
  /// **'Add receipt'**
  String get addReceipt;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get manualEntry;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @importFile.
  ///
  /// In en, this message translates to:
  /// **'Import file'**
  String get importFile;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceipt;

  /// No description provided for @receiptGalleryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your scanned and imported receipts will appear here.'**
  String get receiptGalleryEmpty;

  /// No description provided for @deleteReceiptQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete receipt?'**
  String get deleteReceiptQuestion;

  /// No description provided for @deleteReceiptDescription.
  ///
  /// In en, this message translates to:
  /// **'This removes every page of this receipt.'**
  String get deleteReceiptDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @receiptDeleted.
  ///
  /// In en, this message translates to:
  /// **'Receipt deleted.'**
  String get receiptDeleted;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @receiptPages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 receipt page} other{{count} receipt pages}}'**
  String receiptPages(num count);

  /// No description provided for @pageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String pageCount(num count);

  /// No description provided for @deleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Delete receipt'**
  String get deleteReceipt;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The new passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'Choose a password different from the current one.'**
  String get passwordMustDiffer;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get passwordUpdated;

  /// No description provided for @searchCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search currency'**
  String get searchCurrency;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @defaultWalletDescription.
  ///
  /// In en, this message translates to:
  /// **'Expenses and new envelopes use this wallet by default.'**
  String get defaultWalletDescription;

  /// No description provided for @walletSourceChooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another wallet'**
  String get walletSourceChooseAnother;

  /// No description provided for @walletSourceAmountNeeded.
  ///
  /// In en, this message translates to:
  /// **'The transaction needs {amount}.'**
  String walletSourceAmountNeeded(String amount);

  /// No description provided for @walletSourceUseWallet.
  ///
  /// In en, this message translates to:
  /// **'Use this wallet'**
  String get walletSourceUseWallet;

  /// No description provided for @walletSourceSaveWallet.
  ///
  /// In en, this message translates to:
  /// **'Save wallet'**
  String get walletSourceSaveWallet;

  /// No description provided for @walletSourceDefaultWallet.
  ///
  /// In en, this message translates to:
  /// **'Default wallet'**
  String get walletSourceDefaultWallet;

  /// No description provided for @walletSourceInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get walletSourceInsufficientBalance;

  /// No description provided for @defaultWalletUpdated.
  ///
  /// In en, this message translates to:
  /// **'Default wallet updated.'**
  String get defaultWalletUpdated;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'These terms explain the rules for using Drala.'**
  String get termsIntro;

  /// No description provided for @termsDetails.
  ///
  /// In en, this message translates to:
  /// **'Use Drala only for lawful personal finance management. You remain responsible for checking AI-created entries before relying on them. Service availability may change as the app evolves.'**
  String get termsDetails;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Your financial information belongs to you.'**
  String get privacyIntro;

  /// No description provided for @privacyDetails.
  ///
  /// In en, this message translates to:
  /// **'Drala stores account and transaction data to provide the app. Scanned receipts are kept in private per-user storage and are sent to the configured AI provider through the backend for extraction. You can delete individual receipts from Scanned receipts, or delete all stored data or your complete account from the Account section in Settings.'**
  String get privacyDetails;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: July 21, 2026'**
  String get legalLastUpdated;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allowNotifications;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get dailyReminders;

  /// No description provided for @budgetAlerts.
  ///
  /// In en, this message translates to:
  /// **'Budget alerts'**
  String get budgetAlerts;

  /// No description provided for @selectReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Select reminder time'**
  String get selectReminderTime;

  /// No description provided for @preferredReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred reminder time'**
  String get preferredReminderTime;

  /// No description provided for @reminderDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder delivery time'**
  String get reminderDeliveryTime;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to receive daily reminders and budget alerts.'**
  String get notificationPermissionMessage;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @notificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications blocked'**
  String get notificationsBlocked;

  /// No description provided for @notificationsBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications in your device settings to receive reminders and alerts.'**
  String get notificationsBlockedMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountActions;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all my data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataSummary.
  ///
  /// In en, this message translates to:
  /// **'Deletes app data and files, but keeps your sign-in account.'**
  String get deleteAllDataSummary;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSummary.
  ///
  /// In en, this message translates to:
  /// **'Deletes your sign-in account, app data, and files.'**
  String get deleteAccountSummary;

  /// No description provided for @deleteAllDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllDataQuestion;

  /// No description provided for @deleteAllDataDetails.
  ///
  /// In en, this message translates to:
  /// **'Deletes transactions and wallet activity, non-default wallets, categories, envelopes, budgets and history, AI history, receipt scans, notification settings, profile details, and stored files. Your sign-in account remains. A zero-balance default wallet is kept or created. Your name is reset from your email, your photo is removed, and your currency resets to MGA.'**
  String get deleteAllDataDetails;

  /// No description provided for @deleteKeyword.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteKeyword;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm.'**
  String get typeDeleteToConfirm;

  /// No description provided for @allDataDeleted.
  ///
  /// In en, this message translates to:
  /// **'All your data has been deleted.'**
  String get allDataDeleted;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Deletes your sign-in account, profile, transactions, wallets and wallet activity, categories, envelopes, budgets and history, AI history, receipt scans, notification settings, and stored files. You will be signed out. This cannot be undone.'**
  String get deleteAccountDetails;

  /// No description provided for @typeValueToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type {value} to confirm.'**
  String typeValueToConfirm(Object value);

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @chooseSource.
  ///
  /// In en, this message translates to:
  /// **'Choose a source'**
  String get chooseSource;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get fromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @mediaPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We need camera and file access to continue.'**
  String get mediaPermissionMessage;

  /// No description provided for @cameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access denied.'**
  String get cameraDenied;

  /// No description provided for @mediaDenied.
  ///
  /// In en, this message translates to:
  /// **'Media access denied.'**
  String get mediaDenied;

  /// No description provided for @imageSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not select the image.'**
  String get imageSelectionFailed;

  /// No description provided for @usernameUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the username.'**
  String get usernameUpdateFailed;

  /// No description provided for @profilePhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the profile photo.'**
  String get profilePhotoUploadFailed;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter an email address'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least 8 characters.'**
  String get passwordMinLength;

  /// No description provided for @passwordNeedsUppercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one uppercase letter.'**
  String get passwordNeedsUppercase;

  /// No description provided for @passwordNeedsLowercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one lowercase letter.'**
  String get passwordNeedsLowercase;

  /// No description provided for @passwordNeedsNumber.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one number.'**
  String get passwordNeedsNumber;

  /// No description provided for @passwordNeedsSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one special character.'**
  String get passwordNeedsSpecialCharacter;

  /// No description provided for @passwordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'8+ characters'**
  String get passwordRuleMinLength;

  /// No description provided for @passwordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get passwordRuleUppercase;

  /// No description provided for @passwordRuleLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter'**
  String get passwordRuleLowercase;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'At least one special character'**
  String get passwordRuleSpecialCharacter;

  /// No description provided for @netThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Net this month'**
  String get netThisMonth;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get homeWelcome;

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average / day'**
  String get averagePerDay;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @largestExpense.
  ///
  /// In en, this message translates to:
  /// **'Largest expense'**
  String get largestExpense;

  /// No description provided for @dailySpending.
  ///
  /// In en, this message translates to:
  /// **'Daily Spending'**
  String get dailySpending;

  /// No description provided for @topSpending.
  ///
  /// In en, this message translates to:
  /// **'Top spending'**
  String get topSpending;

  /// No description provided for @noExpensesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get noExpensesThisMonth;

  /// No description provided for @moreThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% more than last month'**
  String moreThanLastMonth(String percentage);

  /// No description provided for @lessThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% less than last month'**
  String lessThanLastMonth(String percentage);

  /// No description provided for @addEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Add envelope'**
  String get addEnvelope;

  /// No description provided for @createExpenseCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Create an expense category before adding another envelope.'**
  String get createExpenseCategoryFirst;

  /// No description provided for @monthlyEnvelopes.
  ///
  /// In en, this message translates to:
  /// **'Monthly envelopes'**
  String get monthlyEnvelopes;

  /// No description provided for @availableAcrossEnvelopes.
  ///
  /// In en, this message translates to:
  /// **'Available across envelopes'**
  String get availableAcrossEnvelopes;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @newEnvelope.
  ///
  /// In en, this message translates to:
  /// **'New envelope'**
  String get newEnvelope;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @envelopeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries'**
  String get envelopeNameHint;

  /// No description provided for @monthlyAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly amount'**
  String get monthlyAmount;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense category'**
  String get expenseCategory;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @noEnvelopesYet.
  ///
  /// In en, this message translates to:
  /// **'Give your plans a little room to grow.'**
  String get noEnvelopesYet;

  /// No description provided for @envelopeEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly amount for an expense category. Chat expenses will update it automatically.'**
  String get envelopeEmptyDescription;

  /// No description provided for @deleteEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Delete envelope'**
  String get deleteEnvelope;

  /// No description provided for @overBudgetBy.
  ///
  /// In en, this message translates to:
  /// **'Over budget by {amount}'**
  String overBudgetBy(String amount);

  /// No description provided for @amountSpent.
  ///
  /// In en, this message translates to:
  /// **'{amount} spent'**
  String amountSpent(String amount);

  /// No description provided for @ofAmount.
  ///
  /// In en, this message translates to:
  /// **'of {amount}'**
  String ofAmount(String amount);

  /// No description provided for @feedbackPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think'**
  String get feedbackPrompt;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Describe an issue or share an idea'**
  String get feedbackHint;

  /// No description provided for @feedbackRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your feedback'**
  String get feedbackRequired;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent. Thank you!'**
  String get feedbackSent;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalance;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @deleteTransactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get deleteTransactionQuestion;

  /// No description provided for @deleteTransactionDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction? This action is irreversible.'**
  String get deleteTransactionDescription;

  /// No description provided for @deleteBudgetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete budget?'**
  String get deleteBudgetQuestion;

  /// No description provided for @deleteBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this budget? This action is irreversible.'**
  String get deleteBudgetDescription;

  /// No description provided for @deleteGoalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete goal?'**
  String get deleteGoalQuestion;

  /// No description provided for @deleteGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this goal? This action is irreversible.'**
  String get deleteGoalDescription;

  /// No description provided for @deleteCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get deleteCategoryQuestion;

  /// No description provided for @deleteCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category? This action is irreversible.'**
  String get deleteCategoryDescription;

  /// No description provided for @categoryInUse.
  ///
  /// In en, this message translates to:
  /// **'The category cannot be deleted because it is currently in use.'**
  String get categoryInUse;

  /// No description provided for @noActivitiesForDay.
  ///
  /// In en, this message translates to:
  /// **'A little quiet today. Ready to track something?'**
  String get noActivitiesForDay;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search a category'**
  String get searchCategories;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @repeatEnvelopeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Repeat monthly'**
  String get repeatEnvelopeMonthly;

  /// No description provided for @repeatEnvelopeMonthlyHelp.
  ///
  /// In en, this message translates to:
  /// **'Fund a fresh budget from the same wallet each month when funds are available.'**
  String get repeatEnvelopeMonthlyHelp;

  /// No description provided for @editEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Edit envelope'**
  String get editEnvelope;

  /// No description provided for @aiRequestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The AI request took too long. Please try again.'**
  String get aiRequestTimedOut;

  /// No description provided for @setupLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your language'**
  String get setupLanguageTitle;

  /// No description provided for @setupLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Select your prefered language. You can always change it later in the settings.'**
  String get setupLanguageBody;

  /// No description provided for @setupCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your currency'**
  String get setupCurrencyTitle;

  /// No description provided for @setupCurrencyBody.
  ///
  /// In en, this message translates to:
  /// **'Select your currency. You can also change this later in the settings.'**
  String get setupCurrencyBody;

  /// No description provided for @setupCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your categories'**
  String get setupCategoriesTitle;

  /// No description provided for @setupCategoriesBody.
  ///
  /// In en, this message translates to:
  /// **'These are a few of the usual categories. Select those you need. You can add custom ones in the settings as well.'**
  String get setupCategoriesBody;

  /// No description provided for @setupWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wallets'**
  String get setupWalletsTitle;

  /// No description provided for @setupWalletsBody.
  ///
  /// In en, this message translates to:
  /// **'These are the places where you keep your money and where your expenses will be taken from. You can choose one of them to be your default wallet in the app. There is always a default one if you choose none. You can add more in the settings.'**
  String get setupWalletsBody;

  /// No description provided for @setupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get setupContinue;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Start using Drala'**
  String get setupFinish;

  /// No description provided for @setupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re all set !'**
  String get setupCompleteTitle;

  /// No description provided for @setupCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Happy managing'**
  String get setupCompleteBody;

  /// No description provided for @setupDone.
  ///
  /// In en, this message translates to:
  /// **'Nice'**
  String get setupDone;

  /// No description provided for @setupRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get setupRetry;

  /// No description provided for @setupMainWallet.
  ///
  /// In en, this message translates to:
  /// **'Main wallet'**
  String get setupMainWallet;

  /// No description provided for @setupCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get setupCash;

  /// No description provided for @setupBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get setupBank;

  /// No description provided for @setupMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get setupMobile;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get authSignUp;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUpBody.
  ///
  /// In en, this message translates to:
  /// **'A few details, then make Drala yours.'**
  String get authSignUpBody;

  /// No description provided for @authSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Find your accounts and expenses.'**
  String get authSignInBody;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authConfirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account, then sign in to finish setup.'**
  String get authConfirmEmail;

  /// No description provided for @setupLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the choices. Try again.'**
  String get setupLoadError;

  /// No description provided for @authResetInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a verification code.'**
  String get authResetInstruction;

  /// No description provided for @authResetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get authResetCodeSent;

  /// No description provided for @authCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A code was sent to'**
  String get authCodeSentTo;

  /// No description provided for @authVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get authVerificationCode;

  /// No description provided for @authEnterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authEnterSixDigitCode;

  /// No description provided for @authResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetButton;

  /// No description provided for @authResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get authResetSuccess;

  /// No description provided for @guestWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Take control of your money'**
  String get guestWelcomeTitle;

  /// No description provided for @guestWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Set up your budget in a few steps. You can start without an account.'**
  String get guestWelcomeBody;

  /// No description provided for @guestGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get guestGetStarted;

  /// No description provided for @guestChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to continue?'**
  String get guestChoiceTitle;

  /// No description provided for @guestChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to sync your budget, or keep it on this device for now.'**
  String get guestChoiceBody;

  /// No description provided for @guestContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get guestContinue;

  /// No description provided for @guestSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get guestSyncNow;

  /// No description provided for @guestCurrencyRatePending.
  ///
  /// In en, this message translates to:
  /// **'{preferred} is saved. Amounts stay in {displayed} until exchange rates are available.'**
  String guestCurrencyRatePending(String preferred, String displayed);

  /// No description provided for @guestCurrencyRateStillUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates are still unavailable. Try again when you\'re online.'**
  String get guestCurrencyRateStillUnavailable;

  /// No description provided for @deleteEnvelopeDescription.
  ///
  /// In en, this message translates to:
  /// **'Deleting this envelope returns its remaining funds to its wallet. Transaction history is preserved.'**
  String get deleteEnvelopeDescription;

  /// No description provided for @insufficientWalletFunds.
  ///
  /// In en, this message translates to:
  /// **'The selected wallet does not have enough funds. Choose a wallet with a sufficient balance.'**
  String get insufficientWalletFunds;

  /// No description provided for @envelopeAmountBelowSpent.
  ///
  /// In en, this message translates to:
  /// **'The envelope amount cannot be lower than the amount already spent.'**
  String get envelopeAmountBelowSpent;

  /// No description provided for @monthlyScheduleNotLatest.
  ///
  /// In en, this message translates to:
  /// **'Only the latest monthly envelope can change its renewal settings.'**
  String get monthlyScheduleNotLatest;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @fromWallet.
  ///
  /// In en, this message translates to:
  /// **'From wallet'**
  String get fromWallet;

  /// No description provided for @toWallet.
  ///
  /// In en, this message translates to:
  /// **'To wallet'**
  String get toWallet;

  /// No description provided for @transferNeedsWallets.
  ///
  /// In en, this message translates to:
  /// **'Add a second wallet to transfer money between wallets.'**
  String get transferNeedsWallets;

  /// No description provided for @transferSaved.
  ///
  /// In en, this message translates to:
  /// **'Transfer saved.'**
  String get transferSaved;

  /// No description provided for @differentTransferWallets.
  ///
  /// In en, this message translates to:
  /// **'Choose two different wallets.'**
  String get differentTransferWallets;

  /// No description provided for @walletCurrencyMismatch.
  ///
  /// In en, this message translates to:
  /// **'Transfers require two wallets in MGA.'**
  String get walletCurrencyMismatch;

  /// No description provided for @walletUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A selected wallet is no longer available. Choose another wallet.'**
  String get walletUnavailable;

  /// No description provided for @transferConflict.
  ///
  /// In en, this message translates to:
  /// **'This transfer was already submitted with different details. Open a new transfer.'**
  String get transferConflict;

  /// No description provided for @selectItems.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectItems;

  /// No description provided for @selectedItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedItemCount(int count);

  /// No description provided for @deleteSelectedItems.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelectedItems;

  /// No description provided for @deleteSelectedWalletsDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} selected wallets? This cannot be undone.'**
  String deleteSelectedWalletsDescription(int count);

  /// No description provided for @deleteSelectedEnvelopesDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} selected envelopes? Remaining funds return to their wallets. Transaction history is preserved.'**
  String deleteSelectedEnvelopesDescription(int count);

  /// No description provided for @defaultWalletCannotDelete.
  ///
  /// In en, this message translates to:
  /// **'The default wallet cannot be deleted. Choose another default wallet first.'**
  String get defaultWalletCannotDelete;

  /// No description provided for @envelopeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A selected envelope is no longer available. Refresh the list.'**
  String get envelopeUnavailable;

  /// No description provided for @operationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the current operation to finish.'**
  String get operationInProgress;

  /// No description provided for @dailyReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminderNotificationTitle;

  /// No description provided for @dailyReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Remember to record your expenses or income today.'**
  String get dailyReminderNotificationBody;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a category name.'**
  String get categoryNameRequired;

  /// No description provided for @envelopeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an envelope name.'**
  String get envelopeNameRequired;

  /// No description provided for @envelopeCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a category for this envelope.'**
  String get envelopeCategoryRequired;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @positiveAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get positiveAmountRequired;

  /// No description provided for @nonNegativeAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a balance of zero or more.'**
  String get nonNegativeAmountRequired;

  /// No description provided for @envelopeFundingWalletFixed.
  ///
  /// In en, this message translates to:
  /// **'An existing envelope keeps its original funding wallet.'**
  String get envelopeFundingWalletFixed;

  /// No description provided for @envelopeFundingWalletUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Funding wallet unavailable'**
  String get envelopeFundingWalletUnavailable;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @envelopes.
  ///
  /// In en, this message translates to:
  /// **'Envelopes'**
  String get envelopes;

  /// No description provided for @activityEmptyWithAction.
  ///
  /// In en, this message translates to:
  /// **'A little quiet today. {action} to get started.'**
  String activityEmptyWithAction(String action);

  /// Home empty-state sentence. Keep {action} where the tappable phrase belongs.
  ///
  /// In en, this message translates to:
  /// **'Give your plans a little room to grow with your {action}.'**
  String homeEmptyEnvelopeMessage(String action);

  /// No description provided for @homeEmptyEnvelopeAction.
  ///
  /// In en, this message translates to:
  /// **'first envelope'**
  String get homeEmptyEnvelopeAction;

  /// Home empty-state sentence. Keep {action} where the tappable phrase belongs.
  ///
  /// In en, this message translates to:
  /// **'{action} to start tracking your budget.'**
  String homeEmptyTransactionMessage(String action);

  /// No description provided for @homeEmptyTransactionAction.
  ///
  /// In en, this message translates to:
  /// **'Add a transaction'**
  String get homeEmptyTransactionAction;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Add a transaction to start tracking your budget.'**
  String get noRecentTransactions;

  /// No description provided for @overviewLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh. Tap to retry.'**
  String get overviewLoadFailed;

  /// No description provided for @homeHello.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get homeHello;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @networkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Check your internet connection and try again.'**
  String get networkUnavailable;

  /// No description provided for @offlineModeToast.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Offline mode is on. Your changes will sync when you reconnect.'**
  String get offlineModeToast;

  /// No description provided for @onlineModeToast.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Your changes are synced.'**
  String get onlineModeToast;

  /// No description provided for @onlinePendingToast.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Some changes still need your attention.'**
  String get onlinePendingToast;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Offline · changes saved on this device'**
  String get offlineStatus;

  /// No description provided for @syncingStatus.
  ///
  /// In en, this message translates to:
  /// **'Syncing your changes…'**
  String get syncingStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'{count} changes waiting to sync'**
  String pendingStatus(int count);

  /// No description provided for @offlineInitial.
  ///
  /// In en, this message translates to:
  /// **'Connect to download your account data for offline use.'**
  String get offlineInitial;

  /// No description provided for @offlineSetupUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sync is unavailable. Your local changes are safely stored on this device.'**
  String get offlineSetupUnavailable;

  /// No description provided for @syncConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Review changes before syncing'**
  String get syncConflictTitle;

  /// No description provided for @syncConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cloud data changed while this device was offline. Review your pending changes before retrying, or use the cloud version.'**
  String get syncConflictMessage;

  /// No description provided for @offlineRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get offlineRetry;

  /// No description provided for @offlineReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get offlineReview;

  /// No description provided for @offlineKeepCloud.
  ///
  /// In en, this message translates to:
  /// **'Use cloud data'**
  String get offlineKeepCloud;

  /// No description provided for @offlineRetryChanges.
  ///
  /// In en, this message translates to:
  /// **'Sync these changes'**
  String get offlineRetryChanges;

  /// No description provided for @offlineDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes saved on this device?'**
  String get offlineDiscardTitle;

  /// No description provided for @offlineDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'These changes have not reached the cloud. This removes them from this device and downloads the cloud version.'**
  String get offlineDiscardBody;

  /// No description provided for @onlineRequired.
  ///
  /// In en, this message translates to:
  /// **'This action needs an internet connection.'**
  String get onlineRequired;

  /// No description provided for @signInSyncRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in again to continue syncing. Your local changes are kept.'**
  String get signInSyncRequired;

  /// No description provided for @categoryIconFood.
  ///
  /// In en, this message translates to:
  /// **'Food & drinks'**
  String get categoryIconFood;

  /// No description provided for @categoryIconShopping.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get categoryIconShopping;

  /// No description provided for @categoryIconTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryIconTransport;

  /// No description provided for @categoryIconHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryIconHousing;

  /// No description provided for @categoryIconHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryIconHealth;

  /// No description provided for @categoryIconUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get categoryIconUtilities;

  /// No description provided for @categoryIconEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryIconEntertainment;

  /// No description provided for @categoryIconEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryIconEducation;

  /// No description provided for @categoryIconSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categoryIconSalary;

  /// No description provided for @categoryIconFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryIconFreelance;

  /// No description provided for @categoryIconIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryIconIncome;

  /// No description provided for @categoryIconOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryIconOther;

  /// No description provided for @categoryIconCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get categoryIconCoffee;

  /// No description provided for @categoryIconDining.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get categoryIconDining;

  /// No description provided for @categoryIconTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryIconTravel;

  /// No description provided for @categoryIconGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryIconGifts;

  /// No description provided for @categoryIconPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get categoryIconPets;

  /// No description provided for @categoryIconFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get categoryIconFamily;

  /// No description provided for @categoryIconSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get categoryIconSubscriptions;

  /// No description provided for @categoryIconPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get categoryIconPhone;

  /// No description provided for @categoryIconInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get categoryIconInternet;

  /// No description provided for @categoryIconSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get categoryIconSavings;

  /// No description provided for @categoryIconInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get categoryIconInvestment;

  /// No description provided for @categoryIconInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get categoryIconInsurance;

  /// No description provided for @categoryIconTaxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get categoryIconTaxes;

  /// No description provided for @categoryIconFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get categoryIconFitness;

  /// No description provided for @categoryIconBeauty.
  ///
  /// In en, this message translates to:
  /// **'Personal care'**
  String get categoryIconBeauty;

  /// No description provided for @categoryIconClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get categoryIconClothing;

  /// No description provided for @categoryIconRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get categoryIconRepairs;

  /// No description provided for @categoryIconFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get categoryIconFuel;

  /// No description provided for @categoryIconBicycle.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get categoryIconBicycle;

  /// No description provided for @categoryIconBus.
  ///
  /// In en, this message translates to:
  /// **'Public transport'**
  String get categoryIconBus;

  /// No description provided for @categoryIconRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy day fund'**
  String get categoryIconRain;

  /// No description provided for @categoryIconCharity.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get categoryIconCharity;

  /// No description provided for @categoryIconMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryIconMusic;

  /// No description provided for @categoryIconBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get categoryIconBooks;

  /// No description provided for @categoryIconTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get categoryIconTransfer;

  /// No description provided for @chooseCategoryIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseCategoryIcon;

  /// No description provided for @searchCategoryIcons.
  ///
  /// In en, this message translates to:
  /// **'Search icons'**
  String get searchCategoryIcons;

  /// No description provided for @activitiesComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Tell me what you spent...'**
  String get activitiesComposerHint;

  /// No description provided for @createEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Create envelope'**
  String get createEnvelope;

  /// No description provided for @trackYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Track your budget'**
  String get trackYourBudget;

  /// No description provided for @emptyCategories.
  ///
  /// In en, this message translates to:
  /// **'Make room for the things that matter to you.'**
  String get emptyCategories;

  /// No description provided for @emptyWallets.
  ///
  /// In en, this message translates to:
  /// **'A home for your money starts here.'**
  String get emptyWallets;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create a category'**
  String get createCategory;

  /// No description provided for @emptyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Small steps make a clearer budget. Let’s add your first expense.'**
  String get emptyExpenses;

  /// No description provided for @emptyIncomes.
  ///
  /// In en, this message translates to:
  /// **'Every income is a fresh start. Add yours here.'**
  String get emptyIncomes;

  /// No description provided for @emptySearch.
  ///
  /// In en, this message translates to:
  /// **'Let’s try another search to find what you’re looking for.'**
  String get emptySearch;

  /// No description provided for @createExpense.
  ///
  /// In en, this message translates to:
  /// **'Add an expense'**
  String get createExpense;

  /// No description provided for @createIncome.
  ///
  /// In en, this message translates to:
  /// **'Add an income'**
  String get createIncome;

  /// No description provided for @resetSearch.
  ///
  /// In en, this message translates to:
  /// **'Reset search'**
  String get resetSearch;

  /// No description provided for @emptyBudgets.
  ///
  /// In en, this message translates to:
  /// **'Give your spending a direction with your first budget.'**
  String get emptyBudgets;

  /// No description provided for @emptyGoals.
  ///
  /// In en, this message translates to:
  /// **'Big plans start with a little saving. What’s your first goal?'**
  String get emptyGoals;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create a budget'**
  String get createBudget;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'Create a goal'**
  String get createGoal;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications'**
  String get manageNotifications;

  /// No description provided for @envelopeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get envelopeRemaining;

  /// No description provided for @envelopeBudgetOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get envelopeBudgetOf;

  /// No description provided for @statsNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get statsNet;

  /// No description provided for @statsNetDescription.
  ///
  /// In en, this message translates to:
  /// **'Income minus expenses'**
  String get statsNetDescription;

  /// No description provided for @statsNumbers.
  ///
  /// In en, this message translates to:
  /// **'The numbers'**
  String get statsNumbers;

  /// No description provided for @statsCategories.
  ///
  /// In en, this message translates to:
  /// **'The categories'**
  String get statsCategories;

  /// No description provided for @statsOnAverage.
  ///
  /// In en, this message translates to:
  /// **'on average'**
  String get statsOnAverage;

  /// No description provided for @statsPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get statsPreviousMonth;

  /// No description provided for @statsEmptyCategories.
  ///
  /// In en, this message translates to:
  /// **'Track an expense to see your spending by category.'**
  String get statsEmptyCategories;

  /// No description provided for @statsActivityCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 activity} other{{count} activities}}'**
  String statsActivityCount(int count);

  /// No description provided for @chooseCategoryColor.
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get chooseCategoryColor;

  /// No description provided for @settingsGuestSyncPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your budget.'**
  String get settingsGuestSyncPrompt;

  /// No description provided for @dailyAiCreditsExhausted.
  ///
  /// In en, this message translates to:
  /// **'You’ve used today’s AI credits. They reset tomorrow.'**
  String get dailyAiCreditsExhausted;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirmation;

  /// No description provided for @offlineBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline'**
  String get offlineBannerMessage;

  /// No description provided for @dismissOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissOfflineBanner;

  /// No description provided for @entryAdded.
  ///
  /// In en, this message translates to:
  /// **'Entry added.'**
  String get entryAdded;

  /// No description provided for @entryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Entry updated.'**
  String get entryUpdated;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted.'**
  String get entryDeleted;

  /// No description provided for @aiEntriesAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry added.} other{{count} entries added.}}'**
  String aiEntriesAdded(int count);

  /// No description provided for @insufficientFundsAllWallets.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds across all wallets.'**
  String get insufficientFundsAllWallets;

  /// No description provided for @transactionNotCompletedInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds. The transaction was not completed.'**
  String get transactionNotCompletedInsufficientFunds;

  /// No description provided for @aiPaidTierNotice.
  ///
  /// In en, this message translates to:
  /// **'This request used a paid AI provider tier.'**
  String get aiPaidTierNotice;

  /// No description provided for @receiptImportedReady.
  ///
  /// In en, this message translates to:
  /// **'File imported and ready for AI extraction.'**
  String get receiptImportedReady;

  /// No description provided for @receiptScannedReady.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanned and ready for AI extraction.'**
  String get receiptScannedReady;

  /// No description provided for @savingsCategoryLocked.
  ///
  /// In en, this message translates to:
  /// **'This category is used for your savings goals and can’t be edited.'**
  String get savingsCategoryLocked;

  /// No description provided for @plusCheckoutUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Drala Plus checkout will be available once billing is configured.'**
  String get plusCheckoutUnavailable;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again.'**
  String get serverError;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get signInToContinue;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email before signing in.'**
  String get emailNotConfirmed;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get accountNotFound;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyUsed;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get emailPasswordRequired;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weakPassword;

  /// No description provided for @checkRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please check the required fields.'**
  String get checkRequiredFields;

  /// No description provided for @duplicateEntry.
  ///
  /// In en, this message translates to:
  /// **'An identical entry already exists.'**
  String get duplicateEntry;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied. Please try again.'**
  String get accessDenied;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found.'**
  String get fileNotFound;

  /// No description provided for @fileProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'The file couldn’t be processed. Please try again.'**
  String get fileProcessingFailed;

  /// No description provided for @noCameraAvailable.
  ///
  /// In en, this message translates to:
  /// **'No camera is available on this device.'**
  String get noCameraAvailable;

  /// No description provided for @receiptFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Each receipt file must be smaller than 15 MB.'**
  String get receiptFileTooLarge;

  /// No description provided for @receiptFormatUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Only JPG, PNG and PDF receipts are supported.'**
  String get receiptFormatUnsupported;

  /// No description provided for @receiptScanningUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanning is unavailable.'**
  String get receiptScanningUnavailable;

  /// No description provided for @receiptUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This receipt can’t be read.'**
  String get receiptUnreadable;

  /// No description provided for @receiptTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This receipt is too large to process. Use fewer or smaller pages.'**
  String get receiptTooLarge;

  /// No description provided for @receiptPdfUnsupported.
  ///
  /// In en, this message translates to:
  /// **'PDF receipts can’t be read right now. Scan or import images instead.'**
  String get receiptPdfUnsupported;

  /// No description provided for @receiptNotFound.
  ///
  /// In en, this message translates to:
  /// **'Receipt not found.'**
  String get receiptNotFound;

  /// No description provided for @aiDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You’ve used all your AI credits for today. Try again tomorrow.'**
  String get aiDailyLimitReached;

  /// No description provided for @aiRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Wait a few seconds and try again.'**
  String get aiRateLimited;

  /// No description provided for @aiUnreadableResponse.
  ///
  /// In en, this message translates to:
  /// **'The AI couldn’t understand that. Try rephrasing.'**
  String get aiUnreadableResponse;

  /// No description provided for @aiServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The AI service is unavailable right now. Please try again later.'**
  String get aiServiceUnavailable;

  /// No description provided for @futureDateNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Transactions can’t be added to a future date.'**
  String get futureDateNotAllowed;

  /// No description provided for @invalidEntryRequest.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid message and transaction date.'**
  String get invalidEntryRequest;

  /// No description provided for @amountOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'This amount is too small or too large to store.'**
  String get amountOutOfRange;

  /// No description provided for @exchangeRateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates are unavailable right now. Please try again later.'**
  String get exchangeRateUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'mg'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'mg':
      return AppLocalizationsMg();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

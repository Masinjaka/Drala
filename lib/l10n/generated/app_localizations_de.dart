// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Um $amount überschritten';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Einstellungen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get notification => 'Benachrichtigung';

  @override
  String get currency => 'Währung';

  @override
  String get setDefaultWallet => 'Standard-Wallet festlegen';

  @override
  String get defaultWalletLabel => 'Standard';

  @override
  String get theme => 'Darstellung';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get language => 'Sprache';

  @override
  String get scannedReceipts => 'Gespeicherte Belege';

  @override
  String get legal => 'Rechtliches';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get termsAndConditions => 'Allgemeinen Geschäftsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get adPrivacyOptions => 'Datenschutzoptionen für Werbung';

  @override
  String get legalConsentPrefix => 'Ich stimme den ';

  @override
  String get legalConsentConnector => ' und der ';

  @override
  String get logOut => 'Abmelden';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get english => 'Englisch';

  @override
  String get french => 'Französisch';

  @override
  String get malagasy => 'Malagasy';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get menu => 'Menü';

  @override
  String get collapseMenu => 'Menü einklappen';

  @override
  String get expandMenu => 'Menü ausklappen';

  @override
  String get activities => 'Aktivitäten';

  @override
  String get reports => 'Berichte';

  @override
  String get profile => 'Profil';

  @override
  String get envelope => 'Umschlag';

  @override
  String get stats => 'Statistiken';

  @override
  String get feedback => 'Feedback';

  @override
  String get resumeFromDate => 'Ab einem bestimmten Datum fortfahren';

  @override
  String get wallets => 'Wallets';

  @override
  String get addWallet => 'Wallet hinzufügen';

  @override
  String get walletNameLabel => 'Name der Wallet';

  @override
  String get walletNameHint => 'z. B. Ersparnisse';

  @override
  String get currentBalanceLabel => 'Aktueller Kontostand';

  @override
  String get editWallet => 'Wallet bearbeiten';

  @override
  String get deleteWallet => 'Wallet löschen';

  @override
  String get deleteWalletQuestion => 'Diese Wallet löschen?';

  @override
  String get deleteWalletDescription =>
      'Diese Wallet wird dauerhaft entfernt. Der Transaktionsverlauf bleibt erhalten.';

  @override
  String get walletUpdated => 'Wallet aktualisiert.';

  @override
  String get walletDeleted => 'Wallet gelöscht.';

  @override
  String get walletInUseCannotBeDeleted =>
      'Diese Geldbörse wird von einem Umschlag oder Transaktionsverlauf verwendet und kann nicht gelöscht werden.';

  @override
  String get allTime => 'Gesamter Zeitraum';

  @override
  String get showBalance => 'Kontostand anzeigen';

  @override
  String get hideBalance => 'Kontostand ausblenden';

  @override
  String get overallBalance => 'Verbleibendes Wallet-Guthaben';

  @override
  String takenFromEnvelope(String name) {
    return 'Aus dem Umschlag $name entnommen';
  }

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get noNotifications =>
      'Du bist auf dem Laufenden! Neuigkeiten findest du hier.';

  @override
  String get noNotificationsDescription =>
      'Budgetwarnungen und wichtige Finanzmeldungen erscheinen hier.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'Du hast das Budget für den Umschlag $name überschritten.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'Das Budget für $name ist fast aufgebraucht.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'Das Budget für $name ist aufgebraucht.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Heute, $date';
  }

  @override
  String get noEntriesForDate => 'Keine Einträge für dieses Datum';

  @override
  String get emptyStateWelcomeBack => 'Willkommen zurück!';

  @override
  String get emptyStateWelcomeTo => 'Willkommen bei';

  @override
  String get emptyStateIncomePrompt =>
      'Geld erhalten? Erzähl mir davon, damit ich es eintragen kann.';

  @override
  String get emptyStateExpensePrompt =>
      'Etwas ausgegeben? Sag mir, wie viel und wofür – ich trage es ein.';

  @override
  String get emptyStateTransferPrompt =>
      'Geld verschieben? Sag mir, von wo nach wo es gehen soll.';

  @override
  String get firstEntryIncomePrompt =>
      'Beginne mit einer Einnahme oder Ausgabe. Schreibe „Ich habe xxx erhalten“ oder „Ich habe xxx für Essen ausgegeben“, und ich trage es ein.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausgaben',
      one: '1 Ausgabe',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einnahmen',
      one: '1 Einnahme',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Überweisungen',
      one: '1 Überweisung',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests => 'Unbegrenzte KI-Anfragen mit Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'Du hast heute noch $count KI-Anfragen übrig';
  }

  @override
  String get chatHint => 'Deine Ausgaben…';

  @override
  String get startTyping => 'Schreibe etwas…';

  @override
  String get chatIncomeHint => 'Deine Einnahmen…';

  @override
  String get chatTransferHint => 'Zwischen Wallets übertragen…';

  @override
  String expenseSuggestion(Object amount) {
    return 'Ich habe $amount für Burger ausgegeben';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'Ich habe $amount Gehalt erhalten';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Überweise $amount von Bargeld auf Ersparnisse';
  }

  @override
  String get addReceipt => 'Beleg hinzufügen';

  @override
  String get manualEntry => 'Manueller Eintrag';

  @override
  String get send => 'Senden';

  @override
  String get enterManually => 'Manuell eingeben';

  @override
  String get importFile => 'Datei importieren';

  @override
  String get scanReceipt => 'Beleg scannen';

  @override
  String get receiptGalleryEmpty =>
      'Deine gescannten und importierten Belege erscheinen hier.';

  @override
  String get deleteReceiptQuestion => 'Beleg löschen?';

  @override
  String get deleteReceiptDescription =>
      'Dadurch werden alle Seiten dieses Belegs entfernt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get receiptDeleted => 'Beleg gelöscht.';

  @override
  String get receipt => 'Beleg';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Belegseiten',
      one: '1 Belegseite',
    );
    return '$_temp0';
  }

  @override
  String pageCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '1 Seite',
    );
    return '$_temp0';
  }

  @override
  String get deleteReceipt => 'Beleg löschen';

  @override
  String get save => 'Speichern';

  @override
  String get username => 'Benutzername';

  @override
  String get enterUsername => 'Benutzernamen eingeben';

  @override
  String get user => 'Benutzer';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get enterCurrentPassword => 'Aktuelles Passwort eingeben';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get enterNewPassword => 'Neues Passwort eingeben';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get passwordsDoNotMatch =>
      'Die neuen Passwörter stimmen nicht überein.';

  @override
  String get passwordMustDiffer =>
      'Wähle ein anderes Passwort als das aktuelle.';

  @override
  String get passwordUpdated => 'Passwort aktualisiert.';

  @override
  String get searchCurrency => 'Währung suchen';

  @override
  String errorWithMessage(Object message) {
    return 'Fehler: $message';
  }

  @override
  String get defaultWalletDescription =>
      'Ausgaben und neue Umschläge verwenden standardmäßig diese Wallet.';

  @override
  String get walletSourceChooseAnother => 'Anderes Wallet auswählen';

  @override
  String walletSourceAmountNeeded(String amount) {
    return 'Für diese Transaktion werden $amount benötigt.';
  }

  @override
  String get walletSourceUseWallet => 'Dieses Wallet verwenden';

  @override
  String get walletSourceSaveWallet => 'Wallet speichern';

  @override
  String get walletSourceDefaultWallet => 'Standard-Wallet';

  @override
  String get walletSourceInsufficientBalance => 'Guthaben nicht ausreichend';

  @override
  String get defaultWalletUpdated => 'Standard-Wallet aktualisiert.';

  @override
  String get termsIntro =>
      'Diese Bedingungen erläutern die Regeln für die Nutzung von Drala.';

  @override
  String get termsDetails =>
      'Verwende Drala nur zur rechtmäßigen Verwaltung deiner persönlichen Finanzen. Prüfe von KI erstellte Einträge, bevor du dich auf sie verlässt. Die Verfügbarkeit des Dienstes kann sich ändern, während die App weiterentwickelt wird.';

  @override
  String get privacyIntro => 'Deine Finanzdaten gehören dir.';

  @override
  String get privacyDetails =>
      'Drala speichert Konto- und Transaktionsdaten, um die App bereitzustellen. Gescannte Belege werden in einem privaten Speicher pro Nutzer aufbewahrt und zur Auswertung über das Backend an den konfigurierten KI-Anbieter gesendet. Du kannst einzelne Belege unter „Gespeicherte Belege“ löschen oder alle gespeicherten Daten beziehungsweise dein gesamtes Konto im Abschnitt „Konto“ der Einstellungen entfernen.';

  @override
  String get legalLastUpdated => 'Zuletzt aktualisiert: 21. Juli 2026';

  @override
  String get allowNotifications => 'Benachrichtigungen erlauben';

  @override
  String get dailyReminders => 'Tägliche Erinnerungen';

  @override
  String get budgetAlerts => 'Budgetwarnungen';

  @override
  String get selectReminderTime => 'Uhrzeit für Erinnerung auswählen';

  @override
  String get preferredReminderTime => 'Bevorzugte Erinnerungszeit';

  @override
  String get reminderDeliveryTime => 'Uhrzeit der täglichen Erinnerung';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get notificationPermissionMessage =>
      'Erlaube Benachrichtigungen, um tägliche Erinnerungen und Budgetwarnungen zu erhalten.';

  @override
  String get allow => 'Erlauben';

  @override
  String get deny => 'Ablehnen';

  @override
  String get notificationsBlocked => 'Benachrichtigungen blockiert';

  @override
  String get notificationsBlockedMessage =>
      'Erlaube Benachrichtigungen in den Geräteeinstellungen, um Erinnerungen und Warnungen zu erhalten.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get accountActions => 'Konto';

  @override
  String get dangerZone => 'Gefahrenbereich';

  @override
  String get deleteAllData => 'Alle meine Daten löschen';

  @override
  String get deleteAllDataSummary =>
      'Löscht App-Daten und Dateien, behält aber dein Anmeldekonto.';

  @override
  String get deleteAccount => 'Mein Konto löschen';

  @override
  String get deleteAccountSummary =>
      'Löscht dein Anmeldekonto, App-Daten und Dateien.';

  @override
  String get deleteAllDataQuestion => 'Alle Daten löschen?';

  @override
  String get deleteAllDataDetails =>
      'Löscht Transaktionen und Wallet-Aktivitäten, alle nicht als Standard festgelegten Wallets, Kategorien, Umschläge, Budgets und Verläufe, KI-Verlauf, gescannte Belege, Benachrichtigungseinstellungen, Profildaten und gespeicherte Dateien. Dein Anmeldekonto bleibt bestehen. Ein Standard-Wallet mit einem Kontostand von null bleibt bestehen oder wird erstellt. Dein Name wird aus deiner E-Mail zurückgesetzt, dein Foto entfernt und deine Währung auf MGA gesetzt.';

  @override
  String get deleteKeyword => 'DELETE';

  @override
  String get typeDeleteToConfirm => 'Gib DELETE ein, um zu bestätigen.';

  @override
  String get allDataDeleted => 'Alle deine Daten wurden gelöscht.';

  @override
  String get deleteAccountQuestion => 'Konto dauerhaft löschen?';

  @override
  String get deleteAccountDetails =>
      'Löscht dein Anmeldekonto, Profil, Transaktionen, Wallets und Wallet-Aktivitäten, Kategorien, Umschläge, Budgets und Verläufe, KI-Verlauf, gescannte Belege, Benachrichtigungseinstellungen und gespeicherte Dateien. Du wirst abgemeldet. Dies kann nicht rückgängig gemacht werden.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Gib $value ein, um zu bestätigen.';
  }

  @override
  String get accountDeleted => 'Dein Konto wurde gelöscht.';

  @override
  String get confirmation => 'Bestätigung';

  @override
  String get chooseSource => 'Quelle auswählen';

  @override
  String get fromGallery => 'Aus Galerie';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get mediaPermissionMessage =>
      'Wir benötigen Zugriff auf Kamera und Dateien, um fortzufahren.';

  @override
  String get cameraDenied => 'Kamerazugriff verweigert.';

  @override
  String get mediaDenied => 'Medienzugriff verweigert.';

  @override
  String get imageSelectionFailed => 'Bild konnte nicht ausgewählt werden.';

  @override
  String get usernameUpdateFailed =>
      'Benutzername konnte nicht aktualisiert werden.';

  @override
  String get profilePhotoUploadFailed =>
      'Profilfoto konnte nicht hochgeladen werden.';

  @override
  String get back => 'Zurück';

  @override
  String get enterEmail => 'E-Mail-Adresse eingeben';

  @override
  String get invalidEmail => 'Gültige E-Mail-Adresse eingeben';

  @override
  String get enterPassword => 'Passwort eingeben';

  @override
  String get passwordMinLength =>
      'Das Passwort muss mindestens 8 Zeichen enthalten.';

  @override
  String get passwordNeedsUppercase =>
      'Das Passwort muss mindestens einen Großbuchstaben enthalten.';

  @override
  String get passwordNeedsLowercase =>
      'Das Passwort muss mindestens einen Kleinbuchstaben enthalten.';

  @override
  String get passwordNeedsNumber =>
      'Das Passwort muss mindestens eine Zahl enthalten.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'Das Passwort muss mindestens ein Sonderzeichen enthalten.';

  @override
  String get passwordRuleMinLength => 'Mindestens 8 Zeichen';

  @override
  String get passwordRuleUppercase => 'Mindestens ein Großbuchstabe';

  @override
  String get passwordRuleLowercase => 'Mindestens ein Kleinbuchstabe';

  @override
  String get passwordRuleNumber => 'Mindestens eine Zahl';

  @override
  String get passwordRuleSpecialCharacter => 'Mindestens ein Sonderzeichen';

  @override
  String get netThisMonth => 'Netto in diesem Monat';

  @override
  String get transactions => 'Transaktionen';

  @override
  String get homeWelcome => 'Willkommen';

  @override
  String get averagePerDay => 'Durchschnitt pro Tag';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get income => 'Einnahmen';

  @override
  String get largestExpense => 'Größte Ausgabe';

  @override
  String get dailySpending => 'Tägliche Ausgaben';

  @override
  String get topSpending => 'Höchste Ausgaben';

  @override
  String get noExpensesThisMonth => 'Keine Ausgaben in diesem Monat';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage % mehr als im letzten Monat';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage % weniger als im letzten Monat';
  }

  @override
  String get addEnvelope => 'Umschlag hinzufügen';

  @override
  String get createExpenseCategoryFirst =>
      'Erstelle eine Ausgabenkategorie, bevor du einen weiteren Umschlag hinzufügst.';

  @override
  String get monthlyEnvelopes => 'Monatliche Umschläge';

  @override
  String get availableAcrossEnvelopes => 'In Umschlägen verfügbar';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get newEnvelope => 'Neuer Umschlag';

  @override
  String get name => 'Name';

  @override
  String get envelopeNameHint => 'z. B. Lebensmittel';

  @override
  String get monthlyAmount => 'Monatlicher Betrag';

  @override
  String get expenseCategory => 'Ausgabenkategorie';

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get create => 'Erstellen';

  @override
  String get noEnvelopesYet =>
      'Gib deinen Plänen Raum mit deinem ersten Umschlag.';

  @override
  String get envelopeEmptyDescription =>
      'Lege einen monatlichen Betrag für eine Ausgabenkategorie fest. Ausgaben aus dem Chat aktualisieren ihn automatisch.';

  @override
  String get deleteEnvelope => 'Umschlag löschen';

  @override
  String overBudgetBy(String amount) {
    return 'Budget um $amount überschritten';
  }

  @override
  String amountSpent(String amount) {
    return '$amount ausgegeben';
  }

  @override
  String ofAmount(String amount) {
    return 'von $amount';
  }

  @override
  String get feedbackPrompt => 'Sag uns deine Meinung';

  @override
  String get feedbackHint => 'Beschreibe ein Problem oder teile eine Idee';

  @override
  String get feedbackRequired => 'Bitte gib dein Feedback ein';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get feedbackSent => 'Feedback gesendet. Vielen Dank!';

  @override
  String get availableBalance => 'Verfügbares Guthaben';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get operations => 'Vorgänge';

  @override
  String get categories => 'Kategorien';

  @override
  String get deleteTransactionQuestion => 'Transaktion löschen?';

  @override
  String get deleteTransactionDescription =>
      'Möchtest du diese Transaktion wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteBudgetQuestion => 'Budget löschen?';

  @override
  String get deleteBudgetDescription =>
      'Möchtest du dieses Budget wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteGoalQuestion => 'Ziel löschen?';

  @override
  String get deleteGoalDescription =>
      'Möchtest du dieses Ziel wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteCategoryQuestion => 'Kategorie löschen?';

  @override
  String get deleteCategoryDescription =>
      'Möchtest du diese Kategorie wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get categoryInUse =>
      'Diese Kategorie kann nicht gelöscht werden, da sie noch verwendet wird.';

  @override
  String get noActivitiesForDay =>
      'Heute ist es noch ruhig. Möchtest du etwas erfassen?';

  @override
  String get editTransaction => 'Transaktion bearbeiten';

  @override
  String get expense => 'Ausgabe';

  @override
  String get title => 'Titel';

  @override
  String get description => 'Beschreibung';

  @override
  String get searchCategories => 'Kategorie suchen';

  @override
  String get done => 'Fertig';

  @override
  String get repeatEnvelopeMonthly => 'Monatlich wiederholen';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Finanziere jeden Monat ein neues Budget aus derselben Wallet, wenn genügend Guthaben vorhanden ist.';

  @override
  String get editEnvelope => 'Umschlag bearbeiten';

  @override
  String get aiRequestTimedOut =>
      'Die KI-Anfrage hat zu lange gedauert. Bitte versuche es erneut.';

  @override
  String get setupLanguageTitle => 'Deine Sprache';

  @override
  String get setupLanguageBody => 'Wähle die Sprache für Drala.';

  @override
  String get setupCurrencyTitle => 'Deine Währung';

  @override
  String get setupCurrencyBody => 'Wähle die Anzeigewährung.';

  @override
  String get setupCategoriesTitle => 'Deine Kategorien';

  @override
  String get setupCategoriesBody =>
      'Wähle passende Kategorien. Weitere kannst du später hinzufügen.';

  @override
  String get setupWalletsTitle => 'Deine Konten';

  @override
  String get setupWalletsBody =>
      'Ordne dein Geld nach Verwendung. Das Hauptkonto ist immer enthalten.';

  @override
  String get setupContinue => 'Weiter';

  @override
  String get setupFinish => 'Drala starten';

  @override
  String get setupCompleteTitle => 'Alles bereit!';

  @override
  String get setupCompleteBody => 'Viel Erfolg bei der Verwaltung';

  @override
  String get setupDone => 'Super';

  @override
  String get setupRetry => 'Erneut versuchen';

  @override
  String get setupMainWallet => 'Hauptkonto';

  @override
  String get setupCash => 'Bargeld';

  @override
  String get setupBank => 'Bankkonto';

  @override
  String get setupMobile => 'Mobiles Geld';

  @override
  String get authSignUp => 'Konto erstellen';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignUpBody => 'Ein paar Angaben, dann wird Drala persönlich.';

  @override
  String get authSignInBody => 'Deine Konten und Ausgaben.';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authConfirmEmail =>
      'Bestätige dein Konto per E-Mail und melde dich an, um die Einrichtung abzuschließen.';

  @override
  String get setupLoadError =>
      'Auswahl konnte nicht geladen werden. Versuche es erneut.';

  @override
  String get authResetInstruction =>
      'Gib deine E-Mail-Adresse ein, um einen Bestätigungscode zu erhalten.';

  @override
  String get authResetCodeSent => 'Bestätigungscode gesendet';

  @override
  String get authCodeSentTo => 'Ein Code wurde gesendet an';

  @override
  String get authVerificationCode => 'Bestätigungscode';

  @override
  String get authEnterSixDigitCode => 'Gib den 6-stelligen Code ein';

  @override
  String get authResetButton => 'Passwort zurücksetzen';

  @override
  String get authResetSuccess => 'Passwort erfolgreich zurückgesetzt';

  @override
  String get guestWelcomeTitle => 'Behalte dein Geld im Blick';

  @override
  String get guestWelcomeBody =>
      'Richte dein Budget in wenigen Schritten ein. Du kannst ohne Konto starten.';

  @override
  String get guestGetStarted => 'Loslegen';

  @override
  String get guestChoiceTitle => 'Wie möchtest du fortfahren?';

  @override
  String get guestChoiceBody =>
      'Erstelle ein Konto, um dein Budget zu synchronisieren, oder speichere es vorerst auf diesem Gerät.';

  @override
  String get guestContinue => 'Als Gast fortfahren';

  @override
  String get guestSyncNow => 'Jetzt synchronisieren';

  @override
  String guestCurrencyRatePending(String preferred, String displayed) {
    return 'Die Auswahl $preferred ist gespeichert. Beträge bleiben in $displayed, bis Wechselkurse verfügbar sind.';
  }

  @override
  String get guestCurrencyRateStillUnavailable =>
      'Wechselkurse sind noch nicht verfügbar. Versuche es online erneut.';

  @override
  String get deleteEnvelopeDescription =>
      'Beim Löschen wird das Restguthaben auf die Geldbörse zurückgebucht. Der Transaktionsverlauf bleibt erhalten.';

  @override
  String get insufficientWalletFunds =>
      'Die ausgewählte Geldbörse hat nicht genug Guthaben. Wähle eine Geldbörse mit ausreichendem Guthaben.';

  @override
  String get envelopeAmountBelowSpent =>
      'Der Umschlagbetrag darf nicht unter dem bereits ausgegebenen Betrag liegen.';

  @override
  String get monthlyScheduleNotLatest =>
      'Nur beim neuesten monatlichen Umschlag können die Erneuerungseinstellungen geändert werden.';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get transfer => 'Überweisung';

  @override
  String get fromWallet => 'Von Geldbörse';

  @override
  String get toWallet => 'An Geldbörse';

  @override
  String get transferNeedsWallets =>
      'Füge eine zweite Geldbörse hinzu, um Geld zu übertragen.';

  @override
  String get transferSaved => 'Überweisung gespeichert.';

  @override
  String get differentTransferWallets => 'Wähle zwei verschiedene Geldbörsen.';

  @override
  String get walletCurrencyMismatch =>
      'Überweisungen erfordern zwei Geldbörsen in MGA.';

  @override
  String get walletUnavailable =>
      'Eine ausgewählte Geldbörse ist nicht mehr verfügbar. Wähle eine andere.';

  @override
  String get transferConflict =>
      'Diese Überweisung wurde bereits mit anderen Angaben übermittelt. Öffne eine neue Überweisung.';

  @override
  String get selectItems => 'Auswählen';

  @override
  String selectedItemCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get deleteSelectedItems => 'Auswahl löschen';

  @override
  String deleteSelectedWalletsDescription(int count) {
    return '$count ausgewählte Geldbörsen löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String deleteSelectedEnvelopesDescription(int count) {
    return '$count ausgewählte Umschläge löschen? Restguthaben wird zurückgebucht. Der Verlauf bleibt erhalten.';
  }

  @override
  String get defaultWalletCannotDelete =>
      'Die Standardgeldbörse kann nicht gelöscht werden. Wähle zuerst eine andere Standardgeldbörse.';

  @override
  String get envelopeUnavailable =>
      'Ein ausgewählter Umschlag ist nicht mehr verfügbar. Aktualisiere die Liste.';

  @override
  String get operationInProgress =>
      'Bitte warte, bis der aktuelle Vorgang abgeschlossen ist.';

  @override
  String get dailyReminderNotificationTitle => 'Tägliche Erinnerung';

  @override
  String get dailyReminderNotificationBody =>
      'Denke daran, heute deine Ausgaben oder Einnahmen einzutragen.';

  @override
  String get categoryNameRequired => 'Gib einen Kategorienamen ein.';

  @override
  String get envelopeNameRequired => 'Gib einen Umschlagnamen ein.';

  @override
  String get envelopeCategoryRequired =>
      'Wähle eine Kategorie für diesen Umschlag.';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich.';

  @override
  String get positiveAmountRequired => 'Gib einen Betrag größer als null ein.';

  @override
  String get nonNegativeAmountRequired =>
      'Gib einen Kontostand von null oder mehr ein.';

  @override
  String get envelopeFundingWalletFixed =>
      'Ein bestehender Umschlag behält sein ursprüngliches Finanzierungskonto.';

  @override
  String get envelopeFundingWalletUnavailable =>
      'Finanzierungskonto nicht verfügbar';

  @override
  String get home => 'Start';

  @override
  String get seeMore => 'Mehr anzeigen';

  @override
  String get recentTransactions => 'Letzte Transaktionen';

  @override
  String get envelopes => 'Umschläge';

  @override
  String activityEmptyWithAction(String action) {
    return 'Heute ist es etwas ruhig. $action, um loszulegen.';
  }

  @override
  String homeEmptyEnvelopeMessage(String action) {
    return 'Gib deinen Plänen Raum mit deinem $action.';
  }

  @override
  String get homeEmptyEnvelopeAction => 'ersten Umschlag';

  @override
  String homeEmptyTransactionMessage(String action) {
    return '$action, um dein Budget zu verfolgen.';
  }

  @override
  String get homeEmptyTransactionAction => 'Füge eine Buchung hinzu';

  @override
  String get noRecentTransactions =>
      'Füge eine Buchung hinzu, um dein Budget zu verfolgen.';

  @override
  String get overviewLoadFailed =>
      'Aktualisieren fehlgeschlagen. Erneut versuchen.';

  @override
  String get homeHello => 'Hallo';

  @override
  String homeGreeting(String name) {
    return 'Hallo, $name';
  }

  @override
  String get networkUnavailable =>
      'Der Server ist nicht erreichbar. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get offlineModeToast =>
      'Verbindung verloren. Offline-Modus ist aktiv. Änderungen werden beim Wiederverbinden synchronisiert.';

  @override
  String get onlineModeToast =>
      'Verbindung wiederhergestellt. Änderungen sind synchronisiert.';

  @override
  String get onlinePendingToast =>
      'Verbindung wiederhergestellt. Einige Änderungen müssen geprüft werden.';

  @override
  String get offlineStatus =>
      'Offline · Änderungen auf diesem Gerät gespeichert';

  @override
  String get syncingStatus => 'Änderungen werden synchronisiert…';

  @override
  String pendingStatus(int count) {
    return '$count Änderungen warten auf Synchronisierung';
  }

  @override
  String get offlineInitial =>
      'Verbinde dich, um deine Kontodaten für die Offline-Nutzung herunterzuladen.';

  @override
  String get offlineSetupUnavailable =>
      'Synchronisierung nicht verfügbar. Lokale Änderungen bleiben gespeichert.';

  @override
  String get syncConflictTitle => 'Änderungen vor dem Synchronisieren prüfen';

  @override
  String get syncConflictMessage =>
      'Deine Cloud-Daten wurden geändert. Prüfe deine ausstehenden Änderungen oder verwende die Cloud-Version.';

  @override
  String get offlineRetry => 'Erneut versuchen';

  @override
  String get offlineReview => 'Prüfen';

  @override
  String get offlineKeepCloud => 'Cloud-Daten verwenden';

  @override
  String get offlineRetryChanges => 'Diese Änderungen synchronisieren';

  @override
  String get offlineDiscardTitle => 'Änderungen auf diesem Gerät verwerfen?';

  @override
  String get offlineDiscardBody =>
      'Diese Änderungen wurden noch nicht hochgeladen. Sie werden auf diesem Gerät gelöscht und durch die Cloud-Version ersetzt.';

  @override
  String get onlineRequired =>
      'Diese Aktion erfordert eine Internetverbindung.';

  @override
  String get signInSyncRequired =>
      'Melde dich erneut an, um zu synchronisieren. Lokale Änderungen bleiben erhalten.';

  @override
  String get categoryIconFood => 'Essen & Trinken';

  @override
  String get categoryIconShopping => 'Lebensmittel';

  @override
  String get categoryIconTransport => 'Transport';

  @override
  String get categoryIconHousing => 'Wohnen';

  @override
  String get categoryIconHealth => 'Gesundheit';

  @override
  String get categoryIconUtilities => 'Nebenkosten';

  @override
  String get categoryIconEntertainment => 'Unterhaltung';

  @override
  String get categoryIconEducation => 'Bildung';

  @override
  String get categoryIconSalary => 'Gehalt';

  @override
  String get categoryIconFreelance => 'Freiberuflich';

  @override
  String get categoryIconIncome => 'Einnahmen';

  @override
  String get categoryIconOther => 'Sonstiges';

  @override
  String get categoryIconCoffee => 'Kaffee';

  @override
  String get categoryIconDining => 'Restaurants';

  @override
  String get categoryIconTravel => 'Reisen';

  @override
  String get categoryIconGifts => 'Geschenke';

  @override
  String get categoryIconPets => 'Haustiere';

  @override
  String get categoryIconFamily => 'Familie';

  @override
  String get categoryIconSubscriptions => 'Abonnements';

  @override
  String get categoryIconPhone => 'Telefon';

  @override
  String get categoryIconInternet => 'Internet';

  @override
  String get categoryIconSavings => 'Ersparnisse';

  @override
  String get categoryIconInvestment => 'Investitionen';

  @override
  String get categoryIconInsurance => 'Versicherung';

  @override
  String get categoryIconTaxes => 'Steuern';

  @override
  String get categoryIconFitness => 'Fitness';

  @override
  String get categoryIconBeauty => 'Körperpflege';

  @override
  String get categoryIconClothing => 'Kleidung';

  @override
  String get categoryIconRepairs => 'Reparaturen';

  @override
  String get categoryIconFuel => 'Kraftstoff';

  @override
  String get categoryIconBicycle => 'Radfahren';

  @override
  String get categoryIconBus => 'Öffentlicher Verkehr';

  @override
  String get categoryIconRain => 'Notfallfonds';

  @override
  String get categoryIconCharity => 'Spenden';

  @override
  String get categoryIconMusic => 'Musik';

  @override
  String get categoryIconBooks => 'Bücher';

  @override
  String get categoryIconTransfer => 'Überweisungen';

  @override
  String get chooseCategoryIcon => 'Symbol auswählen';

  @override
  String get searchCategoryIcons => 'Symbole suchen';

  @override
  String get activitiesComposerHint => 'Sag mir, was du ausgegeben hast…';

  @override
  String get createEnvelope => 'Budgetumschlag erstellen';

  @override
  String get trackYourBudget => 'Budget verfolgen';

  @override
  String get emptyCategories => 'Schaffe Platz für das, was dir wichtig ist.';

  @override
  String get emptyWallets => 'Hier bekommt dein Geld ein Zuhause.';

  @override
  String get createCategory => 'Kategorie erstellen';

  @override
  String get emptyExpenses =>
      'Kleine Schritte bringen Klarheit. Erfasse deine erste Ausgabe.';

  @override
  String get emptyIncomes =>
      'Jede Einnahme ist ein neuer Anfang. Trage deine hier ein.';

  @override
  String get emptySearch =>
      'Versuchen wir eine andere Suche, um das Richtige zu finden.';

  @override
  String get createExpense => 'Ausgabe hinzufügen';

  @override
  String get createIncome => 'Einnahme hinzufügen';

  @override
  String get resetSearch => 'Suche zurücksetzen';

  @override
  String get emptyBudgets =>
      'Gib deinen Ausgaben mit deinem ersten Budget eine Richtung.';

  @override
  String get emptyGoals =>
      'Große Pläne beginnen mit kleinen Ersparnissen. Was ist dein Ziel?';

  @override
  String get createBudget => 'Budget erstellen';

  @override
  String get createGoal => 'Ziel erstellen';

  @override
  String get manageNotifications => 'Benachrichtigungen verwalten';

  @override
  String get envelopeRemaining => 'Übrig';

  @override
  String get envelopeBudgetOf => 'von';

  @override
  String get statsNet => 'Netto';

  @override
  String get statsNetDescription => 'Einnahmen minus Ausgaben';

  @override
  String get statsNumbers => 'Die Zahlen';

  @override
  String get statsCategories => 'Die Kategorien';

  @override
  String get statsOnAverage => 'im Durchschnitt';

  @override
  String get statsPreviousMonth => 'zum Vormonat';

  @override
  String get statsEmptyCategories =>
      'Erfasse eine Ausgabe, um deine Ausgaben nach Kategorien zu sehen.';

  @override
  String statsActivityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aktivitäten',
      one: '1 Aktivität',
    );
    return '$_temp0';
  }

  @override
  String get chooseCategoryColor => 'Farbe wählen';

  @override
  String get settingsGuestSyncPrompt =>
      'Melde dich an, um dein Budget zu synchronisieren.';

  @override
  String get dailyAiCreditsExhausted =>
      'Deine KI-Credits für heute sind aufgebraucht. Morgen werden sie erneuert.';

  @override
  String get logOutConfirmation => 'Möchtest du dich wirklich abmelden?';
}

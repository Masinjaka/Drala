// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Superato di $amount';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Impostazioni';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get preferences => 'Preferenze';

  @override
  String get notification => 'Notifica';

  @override
  String get currency => 'Valuta';

  @override
  String get setDefaultWallet => 'Imposta portafoglio predefinito';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get system => 'Sistema';

  @override
  String get language => 'Lingua';

  @override
  String get scannedReceipts => 'Ricevute scansionate';

  @override
  String get legal => 'Informazioni legali';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get termsAndConditions => 'Termini e condizioni';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get adPrivacyOptions => 'Scelte sulla privacy degli annunci';

  @override
  String get legalConsentPrefix => 'Accetto i ';

  @override
  String get legalConsentConnector => ' e l\'';

  @override
  String get logOut => 'Esci';

  @override
  String appVersion(String version) {
    return 'Versione $version';
  }

  @override
  String get english => 'Inglese';

  @override
  String get french => 'Francese';

  @override
  String get malagasy => 'Malgascio';

  @override
  String get german => 'Tedesco';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get italian => 'Italiano';

  @override
  String get menu => 'Menu';

  @override
  String get collapseMenu => 'Comprimi menu';

  @override
  String get expandMenu => 'Espandi menu';

  @override
  String get envelope => 'Busta';

  @override
  String get stats => 'Statistiche';

  @override
  String get feedback => 'Feedback';

  @override
  String get resumeFromDate => 'Riprendi da una data specifica';

  @override
  String get wallets => 'Portafogli';

  @override
  String get addWallet => 'Aggiungi portafoglio';

  @override
  String get walletNameLabel => 'Nome del portafoglio';

  @override
  String get walletNameHint => 'ad es. Risparmi';

  @override
  String get currentBalanceLabel => 'Saldo attuale';

  @override
  String get editWallet => 'Modifica portafoglio';

  @override
  String get deleteWallet => 'Elimina portafoglio';

  @override
  String get deleteWalletQuestion => 'Eliminare questo portafoglio?';

  @override
  String get deleteWalletDescription =>
      'Questo portafoglio verrà rimosso definitivamente. La cronologia delle transazioni rimarrà invariata.';

  @override
  String get walletUpdated => 'Portafoglio aggiornato.';

  @override
  String get walletDeleted => 'Portafoglio eliminato.';

  @override
  String get walletInUseCannotBeDeleted =>
      'Questo portafoglio contiene transazioni e non può essere eliminato.';

  @override
  String get allTime => 'Tutto il periodo';

  @override
  String get showBalance => 'Mostra saldo';

  @override
  String get hideBalance => 'Nascondi saldo';

  @override
  String get overallBalance => 'Saldo residuo nei portafogli';

  @override
  String takenFromEnvelope(String name) {
    return 'Prelevato dalla busta $name';
  }

  @override
  String get notifications => 'Notifiche';

  @override
  String get noNotifications => 'Nessuna notifica';

  @override
  String get noNotificationsDescription =>
      'Qui appariranno gli avvisi sul budget e gli aggiornamenti finanziari importanti.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'Hai superato il budget della busta $name.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'Il budget della busta $name è quasi esaurito.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'Il budget della busta $name è stato raggiunto.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Oggi, $date';
  }

  @override
  String get noEntriesForDate => 'Nessuna voce per questa data';

  @override
  String get emptyStateWelcomeBack => 'Bentornato!';

  @override
  String get emptyStateWelcomeTo => 'Benvenuto su';

  @override
  String get emptyStateIncomePrompt =>
      'Hai ricevuto denaro? Raccontamelo così possiamo festeggiare… e registrarlo.';

  @override
  String get emptyStateExpensePrompt =>
      'Hai fatto una spesa? Dimmi quanto e per cosa… terrò io i conti.';

  @override
  String get emptyStateTransferPrompt =>
      'Vuoi spostare denaro? Dimmi da dove a dove e lo farò.';

  @override
  String get firstEntryIncomePrompt =>
      'Inizia con un\'entrata o una spesa. Scrivi «Ho ricevuto xxx» o «Ho speso xxx per il cibo» e la registrerò.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voci',
      one: '1 voce',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spese',
      one: '1 spesa',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrate',
      one: '1 entrata',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trasferimenti',
      one: '1 trasferimento',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests => 'Richieste IA illimitate con Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'Oggi ti restano $count richieste IA';
  }

  @override
  String get chatHint => 'Le tue spese…';

  @override
  String get startTyping => 'Inizia a scrivere…';

  @override
  String get chatIncomeHint => 'Le tue entrate…';

  @override
  String get chatTransferHint => 'Trasferisci tra portafogli…';

  @override
  String expenseSuggestion(Object amount) {
    return 'Ho speso $amount per degli hamburger';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'Ho ricevuto $amount di stipendio';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Trasferisci $amount da Contanti a Risparmi';
  }

  @override
  String get addReceipt => 'Aggiungi ricevuta';

  @override
  String get manualEntry => 'Inserimento manuale';

  @override
  String get send => 'Invia';

  @override
  String get enterManually => 'Inserisci manualmente';

  @override
  String get importFile => 'Importa file';

  @override
  String get scanReceipt => 'Scansiona ricevuta';

  @override
  String get receiptGalleryEmpty =>
      'Le ricevute scansionate e importate appariranno qui.';

  @override
  String get deleteReceiptQuestion => 'Eliminare la ricevuta?';

  @override
  String get deleteReceiptDescription =>
      'Questo rimuoverà tutte le pagine della ricevuta.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get receiptDeleted => 'Ricevuta eliminata.';

  @override
  String get receipt => 'Ricevuta';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagine della ricevuta',
      one: '1 pagina della ricevuta',
    );
    return '$_temp0';
  }

  @override
  String pageCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagine',
      one: '1 pagina',
    );
    return '$_temp0';
  }

  @override
  String get deleteReceipt => 'Elimina ricevuta';

  @override
  String get save => 'Salva';

  @override
  String get username => 'Nome utente';

  @override
  String get enterUsername => 'Inserisci il nome utente';

  @override
  String get user => 'Utente';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get enterCurrentPassword => 'Inserisci la password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get enterNewPassword => 'Inserisci la nuova password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get confirmNewPassword => 'Conferma la nuova password';

  @override
  String get passwordsDoNotMatch => 'Le nuove password non corrispondono.';

  @override
  String get passwordMustDiffer =>
      'Scegli una password diversa da quella attuale.';

  @override
  String get passwordUpdated => 'Password aggiornata.';

  @override
  String get searchCurrency => 'Cerca una valuta';

  @override
  String errorWithMessage(Object message) {
    return 'Errore: $message';
  }

  @override
  String get defaultWalletDescription =>
      'Le spese e le nuove buste usano questo portafoglio per impostazione predefinita.';

  @override
  String get defaultWalletUpdated => 'Portafoglio predefinito aggiornato.';

  @override
  String get termsIntro => 'Questi termini spiegano le regole per usare Drala.';

  @override
  String get termsDetails =>
      'Usa Drala solo per gestire legalmente le tue finanze personali. Sei responsabile di verificare le voci create dall\'IA prima di farvi affidamento. La disponibilità del servizio può cambiare con l\'evoluzione dell\'app.';

  @override
  String get privacyIntro => 'Le tue informazioni finanziarie ti appartengono.';

  @override
  String get privacyDetails =>
      'Drala memorizza i dati dell\'account e delle transazioni per fornire l\'app. Le ricevute scansionate sono conservate in uno spazio privato per ciascun utente e inviate al provider IA configurato tramite il backend per l\'estrazione. Puoi eliminare singole ricevute da Ricevute scansionate, oppure eliminare tutti i dati memorizzati o l\'intero account da Modifica profilo.';

  @override
  String get legalLastUpdated => 'Ultimo aggiornamento: 21 luglio 2026';

  @override
  String get allowNotifications => 'Consenti notifiche';

  @override
  String get dailyReminders => 'Promemoria quotidiani';

  @override
  String get budgetAlerts => 'Avvisi sul budget';

  @override
  String get selectReminderTime => 'Seleziona l\'ora del promemoria';

  @override
  String get preferredReminderTime => 'Ora preferita del promemoria';

  @override
  String get reminderDeliveryTime => 'Ora di invio del promemoria quotidiano';

  @override
  String get enableNotifications => 'Attiva notifiche';

  @override
  String get notificationPermissionMessage =>
      'Consenti le notifiche per ricevere promemoria quotidiani e avvisi sul budget.';

  @override
  String get allow => 'Consenti';

  @override
  String get deny => 'Nega';

  @override
  String get notificationsBlocked => 'Notifiche bloccate';

  @override
  String get notificationsBlockedMessage =>
      'Consenti le notifiche nelle impostazioni del dispositivo per ricevere promemoria e avvisi.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get dangerZone => 'Zona pericolosa';

  @override
  String get deleteAllData => 'Elimina tutti i miei dati';

  @override
  String get deleteAllDataSummary =>
      'Elimina definitivamente tutti i contenuti dell\'app.';

  @override
  String get deleteAccount => 'Elimina il mio account';

  @override
  String get deleteAccountSummary =>
      'Elimina i tuoi dati e disattiva l\'accesso.';

  @override
  String get deleteAllDataQuestion => 'Eliminare tutti i dati?';

  @override
  String get deleteAllDataDetails =>
      'Saranno eliminati transazioni, portafogli, buste, budget, obiettivi, cronologia IA, preferenze e file. Il tuo account e il tuo piano saranno mantenuti.';

  @override
  String get deleteKeyword => 'DELETE';

  @override
  String get typeDeleteToConfirm => 'Digita DELETE per confermare.';

  @override
  String get allDataDeleted => 'Tutti i tuoi dati sono stati eliminati.';

  @override
  String get deleteAccountQuestion => 'Eliminare definitivamente l\'account?';

  @override
  String get deleteAccountDetails =>
      'Questo elimina il tuo account, il piano, i file e tutti i tuoi dati. L\'azione non può essere annullata.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Digita $value per confermare.';
  }

  @override
  String get accountDeleted => 'Il tuo account è stato eliminato.';

  @override
  String get confirmation => 'Conferma';

  @override
  String get chooseSource => 'Scegli una fonte';

  @override
  String get fromGallery => 'Dalla galleria';

  @override
  String get takePhoto => 'Scatta una foto';

  @override
  String get mediaPermissionMessage =>
      'Per continuare abbiamo bisogno dell\'accesso alla fotocamera e ai file.';

  @override
  String get cameraDenied => 'Accesso alla fotocamera negato.';

  @override
  String get mediaDenied => 'Accesso ai file negato.';

  @override
  String get imageSelectionFailed => 'Impossibile selezionare l\'immagine.';

  @override
  String get usernameUpdateFailed => 'Impossibile aggiornare il nome utente.';

  @override
  String get profilePhotoUploadFailed =>
      'Impossibile caricare la foto del profilo.';

  @override
  String get back => 'Indietro';

  @override
  String get enterEmail => 'Inserisci un indirizzo email';

  @override
  String get invalidEmail => 'Inserisci un indirizzo email valido';

  @override
  String get enterPassword => 'Inserisci una password';

  @override
  String get passwordMinLength =>
      'La password deve contenere almeno 8 caratteri.';

  @override
  String get passwordNeedsUppercase =>
      'La password deve contenere almeno una lettera maiuscola.';

  @override
  String get passwordNeedsLowercase =>
      'La password deve contenere almeno una lettera minuscola.';

  @override
  String get passwordNeedsNumber =>
      'La password deve contenere almeno un numero.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'La password deve contenere almeno un carattere speciale.';

  @override
  String get passwordRuleMinLength => 'Almeno 8 caratteri';

  @override
  String get passwordRuleUppercase => 'Almeno una lettera maiuscola';

  @override
  String get passwordRuleLowercase => 'Almeno una lettera minuscola';

  @override
  String get passwordRuleNumber => 'Almeno un numero';

  @override
  String get passwordRuleSpecialCharacter => 'Almeno un carattere speciale';

  @override
  String get netThisMonth => 'Netto di questo mese';

  @override
  String get transactions => 'Transazioni';

  @override
  String get homeWelcome => 'Benvenuto';

  @override
  String get averagePerDay => 'Media giornaliera';

  @override
  String get expenses => 'Spese';

  @override
  String get income => 'Entrate';

  @override
  String get largestExpense => 'Spesa maggiore';

  @override
  String get dailySpending => 'Spese giornaliere';

  @override
  String get topSpending => 'Spese principali';

  @override
  String get noExpensesThisMonth => 'Nessuna spesa questo mese';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage% in più rispetto al mese scorso';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage% in meno rispetto al mese scorso';
  }

  @override
  String get addEnvelope => 'Aggiungi busta';

  @override
  String get createExpenseCategoryFirst =>
      'Crea una categoria di spesa prima di aggiungere un\'altra busta.';

  @override
  String get monthlyEnvelopes => 'Buste mensili';

  @override
  String get availableAcrossEnvelopes => 'Disponibile nelle buste';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Speso';

  @override
  String get newEnvelope => 'Nuova busta';

  @override
  String get name => 'Nome';

  @override
  String get envelopeNameHint => 'ad es. Spesa alimentare';

  @override
  String get monthlyAmount => 'Importo mensile';

  @override
  String get expenseCategory => 'Categoria di spesa';

  @override
  String get saving => 'Salvataggio…';

  @override
  String get create => 'Crea';

  @override
  String get noEnvelopesYet => 'Nessuna busta';

  @override
  String get envelopeEmptyDescription =>
      'Imposta un importo mensile per una categoria di spesa. Le spese inserite in chat lo aggiorneranno automaticamente.';

  @override
  String get deleteEnvelope => 'Elimina busta';

  @override
  String overBudgetBy(String amount) {
    return 'Budget superato di $amount';
  }

  @override
  String amountSpent(String amount) {
    return '$amount spesi';
  }

  @override
  String ofAmount(String amount) {
    return 'di $amount';
  }

  @override
  String get feedbackPrompt => 'Dicci cosa ne pensi';

  @override
  String get feedbackHint => 'Descrivi un problema o condividi un\'idea';

  @override
  String get feedbackRequired => 'Inserisci il tuo feedback';

  @override
  String get sendFeedback => 'Invia feedback';

  @override
  String get feedbackSent => 'Feedback inviato. Grazie!';

  @override
  String get availableBalance => 'Saldo disponibile';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String get operations => 'Operazioni';

  @override
  String get categories => 'Categorie';

  @override
  String get deleteTransactionQuestion => 'Eliminare la transazione?';

  @override
  String get deleteTransactionDescription =>
      'Vuoi davvero eliminare questa transazione? L\'azione non può essere annullata.';

  @override
  String get deleteBudgetQuestion => 'Eliminare il budget?';

  @override
  String get deleteBudgetDescription =>
      'Vuoi davvero eliminare questo budget? L\'azione non può essere annullata.';

  @override
  String get deleteGoalQuestion => 'Eliminare l\'obiettivo?';

  @override
  String get deleteGoalDescription =>
      'Vuoi davvero eliminare questo obiettivo? L\'azione non può essere annullata.';

  @override
  String get deleteCategoryQuestion => 'Eliminare la categoria?';

  @override
  String get deleteCategoryDescription =>
      'Vuoi davvero eliminare questa categoria? L\'azione non può essere annullata.';

  @override
  String get editTransaction => 'Modifica transazione';

  @override
  String get expense => 'Spesa';

  @override
  String get title => 'Titolo';

  @override
  String get description => 'Descrizione';

  @override
  String get searchCategories => 'Cerca una categoria';

  @override
  String get done => 'Fatto';

  @override
  String get repeatEnvelopeMonthly => 'Ripeti ogni mese';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Finanzia un nuovo budget dallo stesso portafoglio ogni mese, quando sono disponibili fondi.';

  @override
  String get editEnvelope => 'Modifica busta';

  @override
  String get aiRequestTimedOut =>
      'La richiesta IA ha impiegato troppo tempo. Riprova.';

  @override
  String get setupLanguageTitle => 'La tua lingua';

  @override
  String get setupLanguageBody => 'Scegli la lingua di Drala.';

  @override
  String get setupCurrencyTitle => 'La tua valuta';

  @override
  String get setupCurrencyBody => 'Scegli come visualizzare gli importi.';

  @override
  String get setupCategoriesTitle => 'Le tue categorie';

  @override
  String get setupCategoriesBody =>
      'Scegli le categorie utili. Potrai aggiungerne altre in seguito.';

  @override
  String get setupWalletsTitle => 'I tuoi portafogli';

  @override
  String get setupWalletsBody =>
      'Separa il denaro in base all’uso. Il portafoglio principale è sempre incluso.';

  @override
  String get setupContinue => 'Continua';

  @override
  String get setupFinish => 'Inizia';

  @override
  String get setupCompleteTitle => 'È tutto pronto!';

  @override
  String get setupCompleteBody => 'Buona gestione';

  @override
  String get setupDone => 'Ottimo';

  @override
  String get setupRetry => 'Riprova';

  @override
  String get setupMainWallet => 'Portafoglio principale';

  @override
  String get setupCash => 'Contanti';

  @override
  String get setupBank => 'Conto bancario';

  @override
  String get setupMobile => 'Denaro mobile';

  @override
  String get authSignUp => 'Crea un account';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authSignUpBody => 'Qualche dettaglio, poi personalizza Drala.';

  @override
  String get authSignInBody => 'Ritrova i tuoi conti e le tue spese.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Conferma password';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get authConfirmEmail =>
      'Conferma il tuo account via email, poi accedi per completare la configurazione.';

  @override
  String get setupLoadError => 'Impossibile caricare le opzioni. Riprova.';

  @override
  String get authResetInstruction =>
      'Inserisci la tua email per ricevere un codice di verifica.';

  @override
  String get authResetCodeSent => 'Codice di verifica inviato';

  @override
  String get authCodeSentTo => 'Un codice è stato inviato a';

  @override
  String get authVerificationCode => 'Codice di verifica';

  @override
  String get authEnterSixDigitCode => 'Inserisci il codice a 6 cifre';

  @override
  String get authResetButton => 'Reimposta password';

  @override
  String get authResetSuccess => 'Password reimpostata';
}

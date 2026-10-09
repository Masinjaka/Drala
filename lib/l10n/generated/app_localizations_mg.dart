// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malagasy (`mg`).
class AppLocalizationsMg extends AppLocalizations {
  AppLocalizationsMg([String locale = 'mg']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Nihoatra $amount';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Fikirana';

  @override
  String get editProfile => 'Hanova ny mombamomba';

  @override
  String get changePassword => 'Hanova tenimiafina';

  @override
  String get preferences => 'Safidy';

  @override
  String get notification => 'Fampandrenesana';

  @override
  String get currency => 'Vola';

  @override
  String get setDefaultWallet => 'Hametraka poketra ampiasaina voalohany';

  @override
  String get theme => 'Endrika';

  @override
  String get light => 'Mazava';

  @override
  String get dark => 'Maizina';

  @override
  String get system => 'Araka ny rafitra';

  @override
  String get language => 'Fiteny';

  @override
  String get scannedReceipts => 'Rosia noskenina';

  @override
  String get legal => 'Lalàna';

  @override
  String get termsOfService => 'Fepetra fampiasana';

  @override
  String get termsAndConditions => 'Fepetra sy fitsipika';

  @override
  String get privacyPolicy => 'Politika momba ny fiainana manokana';

  @override
  String get adPrivacyOptions => 'Safidy momba ny tsiambaratelon\'ny doka';

  @override
  String get legalConsentPrefix => 'Manaiky ny ';

  @override
  String get legalConsentConnector => ' sy ny ';

  @override
  String get logOut => 'Hivoaka';

  @override
  String appVersion(String version) {
    return 'Dika $version';
  }

  @override
  String get english => 'Anglisy';

  @override
  String get french => 'Frantsay';

  @override
  String get malagasy => 'Malagasy';

  @override
  String get german => 'Alemà';

  @override
  String get spanish => 'Espaniola';

  @override
  String get italian => 'Italiana';

  @override
  String get menu => 'Menu';

  @override
  String get collapseMenu => 'Afeno ny menu';

  @override
  String get expandMenu => 'Asehoy ny menu';

  @override
  String get envelope => 'Valopy';

  @override
  String get stats => 'Antontan\'isa';

  @override
  String get feedback => 'Hevitra';

  @override
  String get resumeFromDate => 'Hanohy manomboka amin\'ny daty voafaritra';

  @override
  String get wallets => 'Poketra';

  @override
  String get addWallet => 'Hanampy poketra';

  @override
  String get walletNameLabel => 'Anaran\'ny poketra';

  @override
  String get walletNameHint => 'ohatra: Tahiry';

  @override
  String get currentBalanceLabel => 'Vola sisa ankehitriny';

  @override
  String get editWallet => 'Hanova poketra';

  @override
  String get deleteWallet => 'Hamafa poketra';

  @override
  String get deleteWalletQuestion => 'Hofafana ve ity poketra ity?';

  @override
  String get deleteWalletDescription =>
      'Hesorina tanteraka ity poketra ity. Hijanona ny tantaran\'ny fifanakalozana.';

  @override
  String get walletUpdated => 'Nohavaozina ny poketra.';

  @override
  String get walletDeleted => 'Voafafa ny poketra.';

  @override
  String get walletInUseCannotBeDeleted =>
      'Misy tantaran\'ny fifanakalozana ity poketra ity ka tsy azo fafana.';

  @override
  String get allTime => 'Fotoana rehetra';

  @override
  String get showBalance => 'Asehoy ny vola sisa';

  @override
  String get hideBalance => 'Afeno ny vola sisa';

  @override
  String get overallBalance => 'Vola sisa ao amin\'ny poketra';

  @override
  String takenFromEnvelope(String name) {
    return 'Nalaina tao amin\'ny valopy $name';
  }

  @override
  String get notifications => 'Fampandrenesana';

  @override
  String get noNotifications => 'Tsy misy fampandrenesana';

  @override
  String get noNotificationsDescription =>
      'Hiseho eto ny fampitandremana momba ny tetibola sy ny vaovao ara-bola manan-danja.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'Nihoatra ny tetibola ho an\'ny valopy $name ianao.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'Efa ho lany ny vola ao amin\'ny valopy $name.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'Lany ny tetibola ao amin\'ny valopy $name.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Androany, $date';
  }

  @override
  String get noEntriesForDate => 'Tsy misy firaketana amin\'ity daty ity';

  @override
  String get emptyStateWelcomeBack => 'Tongasoa indray!';

  @override
  String get emptyStateWelcomeTo => 'Tongasoa eto amin\'ny';

  @override
  String get emptyStateIncomePrompt =>
      'Nahazo vola ve ianao? Lazao ahy mba hahafahantsika mifaly… sy mirakitra izany.';

  @override
  String get emptyStateExpensePrompt =>
      'Nandany vola ve ianao? Lazao hoe ohatrinona sy tamin\'inona… izaho no hitahiry ny kaonty.';

  @override
  String get emptyStateTransferPrompt =>
      'Hamindra vola ve ianao? Lazao ny fiaviany sy ny halehany dia hataoko.';

  @override
  String get firstEntryIncomePrompt =>
      'Atombohy amin\'ny vola miditra na fandaniana. Soraty hoe “Nahazo xxx aho” na “Nandany xxx tamin\'ny sakafo aho” dia horaketiko izany.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count firaketana',
      one: '1 firaketana',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fandaniana',
      one: '1 fandaniana',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vola miditra',
      one: '1 vola miditra',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count famindrana',
      one: '1 famindrana',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests =>
      'Fangatahana AI tsy voafetra amin\'ny Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'Mbola manana fangatahana AI $count ianao androany';
  }

  @override
  String get chatHint => 'Ny fandanianao…';

  @override
  String get startTyping => 'Atombohy manoratra…';

  @override
  String get chatIncomeHint => 'Ny vola miditra aminao…';

  @override
  String get chatTransferHint => 'Famindrana eo amin\'ny poketra…';

  @override
  String expenseSuggestion(Object amount) {
    return 'Nandany $amount tamin\'ny burger aho';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'Nahazo $amount tamin\'ny karamako aho';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Mamindra $amount avy amin\'ny Vola mivantana ho any amin\'ny Tahiry';
  }

  @override
  String get addReceipt => 'Hanampy rosia';

  @override
  String get manualEntry => 'Firaketana an-tanana';

  @override
  String get send => 'Alefa';

  @override
  String get enterManually => 'Ampidiro an-tanana';

  @override
  String get importFile => 'Hampiditra rakitra';

  @override
  String get scanReceipt => 'Skeno ny rosia';

  @override
  String get receiptGalleryEmpty =>
      'Hiseho eto ny rosia noskeninao sy nampidirinao.';

  @override
  String get deleteReceiptQuestion => 'Hofafana ve ny rosia?';

  @override
  String get deleteReceiptDescription =>
      'Hanala ny pejy rehetra amin\'ity rosia ity izany.';

  @override
  String get cancel => 'Aoka ihany';

  @override
  String get delete => 'Fafao';

  @override
  String get receiptDeleted => 'Voafafa ny rosia.';

  @override
  String get receipt => 'Rosia';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pejin\'ny rosia',
      one: '1 pejin\'ny rosia',
    );
    return '$_temp0';
  }

  @override
  String pageCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pejy',
      one: '1 pejy',
    );
    return '$_temp0';
  }

  @override
  String get deleteReceipt => 'Hamafa rosia';

  @override
  String get save => 'Tehirizo';

  @override
  String get username => 'Anaran\'ny mpampiasa';

  @override
  String get enterUsername => 'Ampidiro ny anaran\'ny mpampiasa';

  @override
  String get user => 'Mpampiasa';

  @override
  String get currentPassword => 'Tenimiafina ankehitriny';

  @override
  String get enterCurrentPassword => 'Ampidiro ny tenimiafina ankehitriny';

  @override
  String get newPassword => 'Tenimiafina vaovao';

  @override
  String get enterNewPassword => 'Ampidiro ny tenimiafina vaovao';

  @override
  String get confirmPassword => 'Hamafiso ny tenimiafina';

  @override
  String get confirmNewPassword => 'Hamafiso ny tenimiafina vaovao';

  @override
  String get passwordsDoNotMatch => 'Tsy mitovy ny tenimiafina vaovao.';

  @override
  String get passwordMustDiffer =>
      'Misafidiana tenimiafina hafa noho ny ankehitriny.';

  @override
  String get passwordUpdated => 'Nohavaozina ny tenimiafina.';

  @override
  String get searchCurrency => 'Mitady vola';

  @override
  String errorWithMessage(Object message) {
    return 'Hadisoana: $message';
  }

  @override
  String get defaultWalletDescription =>
      'Ity poketra ity no ampiasaina voalohany amin\'ny fandaniana sy valopy vaovao.';

  @override
  String get defaultWalletUpdated =>
      'Nohavaozina ny poketra ampiasaina voalohany.';

  @override
  String get termsIntro =>
      'Manazava ny fitsipika fampiasana an\'i Drala ireo fepetra ireo.';

  @override
  String get termsDetails =>
      'Ampiasao amin\'ny fitantanana ara-dalàna ny volanao manokana ihany i Drala. Anjaranao ny manamarina ireo firaketana noforonin\'ny AI alohan\'ny hianteherana aminy. Mety hiova ny fisian\'ny tolotra rehefa mivoatra ny fampiharana.';

  @override
  String get privacyIntro => 'Anao ny mombamomba ny volanao.';

  @override
  String get privacyDetails =>
      'Mitahiry angona momba ny kaonty sy ny fifanakalozana i Drala mba hampandeha ny fampiharana. Ny rosia noskenina dia tehirizina amin\'ny toerana manokana ho an\'ny mpampiasa tsirairay ary alefa amin\'ny mpamatsy AI voafantina amin\'ny alalan\'ny lohamilina mba hakana ny angona. Afaka mamafa rosia tsirairay ao amin\'ny Rosia noskenina ianao, na mamafa ny angona rehetra na ny kaontinao manontolo ao amin\'ny Hanova ny mombamomba.';

  @override
  String get legalLastUpdated => 'Nohavaozina farany: 21 Jolay 2026';

  @override
  String get allowNotifications => 'Avelao ny fampandrenesana';

  @override
  String get dailyReminders => 'Fampahatsiahivana isan\'andro';

  @override
  String get budgetAlerts => 'Fampitandremana momba ny tetibola';

  @override
  String get selectReminderTime => 'Safidio ny ora fampahatsiahivana';

  @override
  String get preferredReminderTime => 'Ora fampahatsiahivana tiana';

  @override
  String get reminderDeliveryTime =>
      'Ora handefasana ny fampahatsiahivana isan\'andro';

  @override
  String get enableNotifications => 'Ampandehano ny fampandrenesana';

  @override
  String get notificationPermissionMessage =>
      'Avelao ny fampandrenesana hahazoana fampahatsiahivana isan\'andro sy fampitandremana momba ny tetibola.';

  @override
  String get allow => 'Avelao';

  @override
  String get deny => 'Aza avela';

  @override
  String get notificationsBlocked => 'Voasakana ny fampandrenesana';

  @override
  String get notificationsBlockedMessage =>
      'Avelao ny fampandrenesana ao amin\'ny fikirana amin\'ny findainao mba hahazoana fampahatsiahivana sy fampitandremana.';

  @override
  String get openSettings => 'Sokafy ny fikirana';

  @override
  String get dangerZone => 'Faritra mampidi-doza';

  @override
  String get deleteAllData => 'Hamafa ny angonako rehetra';

  @override
  String get deleteAllDataSummary =>
      'Mamafa tanteraka ny votoatin\'ny fampiharana rehetra.';

  @override
  String get deleteAccount => 'Hamafa ny kaontiko';

  @override
  String get deleteAccountSummary =>
      'Mamafa ny angonao ary manakana ny fidiranao.';

  @override
  String get deleteAllDataQuestion => 'Hofafana ve ny angona rehetra?';

  @override
  String get deleteAllDataDetails =>
      'Hofafana ny fifanakalozana, poketra, valopy, tetibola, tanjona, tantaran\'ny AI, safidy ary rakitra. Hijanona ny kaontinao sy ny drafitrao.';

  @override
  String get deleteKeyword => 'DELETE';

  @override
  String get typeDeleteToConfirm => 'Soraty DELETE hanamafisana.';

  @override
  String get allDataDeleted => 'Voafafa ny angonao rehetra.';

  @override
  String get deleteAccountQuestion => 'Hofafana tanteraka ve ny kaonty?';

  @override
  String get deleteAccountDetails =>
      'Mamafa ny kaontinao, ny drafitrao, ny rakitrao ary ny angonao rehetra izany. Tsy azo averina intsony.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Soraty $value hanamafisana.';
  }

  @override
  String get accountDeleted => 'Voafafa ny kaontinao.';

  @override
  String get confirmation => 'Fanamafisana';

  @override
  String get chooseSource => 'Safidio ny loharano';

  @override
  String get fromGallery => 'Avy amin\'ny tahirin-tsary';

  @override
  String get takePhoto => 'Maka sary';

  @override
  String get mediaPermissionMessage =>
      'Mila alalana hampiasa ny fakantsary sy ny rakitra izahay mba hanohy.';

  @override
  String get cameraDenied => 'Tsy nahazo alalana hampiasa ny fakantsary.';

  @override
  String get mediaDenied => 'Tsy nahazo alalana hampiasa ny rakitra.';

  @override
  String get imageSelectionFailed => 'Tsy voafidy ny sary.';

  @override
  String get usernameUpdateFailed => 'Tsy nohavaozina ny anaran\'ny mpampiasa.';

  @override
  String get profilePhotoUploadFailed =>
      'Tsy tafakatra ny sarin\'ny mombamomba.';

  @override
  String get back => 'Miverina';

  @override
  String get enterEmail => 'Ampidiro ny adiresy mailaka';

  @override
  String get invalidEmail => 'Ampidiro ny adiresy mailaka manan-kery';

  @override
  String get enterPassword => 'Ampidiro ny tenimiafina';

  @override
  String get passwordMinLength =>
      'Tsy maintsy misy tarehintsoratra 8 farafahakeliny ny tenimiafina.';

  @override
  String get passwordNeedsUppercase =>
      'Tsy maintsy misy sora-baventy iray farafahakeliny ny tenimiafina.';

  @override
  String get passwordNeedsLowercase =>
      'Tsy maintsy misy sora-madinika iray farafahakeliny ny tenimiafina.';

  @override
  String get passwordNeedsNumber =>
      'Tsy maintsy misy isa iray farafahakeliny ny tenimiafina.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'Tsy maintsy misy marika manokana iray farafahakeliny ny tenimiafina.';

  @override
  String get passwordRuleMinLength => 'Tarehintsoratra 8 na mihoatra';

  @override
  String get passwordRuleUppercase => 'Sora-baventy iray farafahakeliny';

  @override
  String get passwordRuleLowercase => 'Sora-madinika iray farafahakeliny';

  @override
  String get passwordRuleNumber => 'Isa iray farafahakeliny';

  @override
  String get passwordRuleSpecialCharacter =>
      'Marika manokana iray farafahakeliny';

  @override
  String get netThisMonth => 'Vola madio amin\'ity volana ity';

  @override
  String get transactions => 'Fifanakalozana';

  @override
  String get homeWelcome => 'Tongasoa';

  @override
  String get averagePerDay => 'Salan\'isa isan\'andro';

  @override
  String get expenses => 'Fandaniana';

  @override
  String get income => 'Vola miditra';

  @override
  String get largestExpense => 'Fandaniana lehibe indrindra';

  @override
  String get dailySpending => 'Fandaniana isan\'andro';

  @override
  String get topSpending => 'Fandaniana ambony indrindra';

  @override
  String get noExpensesThisMonth => 'Tsy misy fandaniana amin\'ity volana ity';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage% mihoatra ny volana lasa';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage% latsaka ny volana lasa';
  }

  @override
  String get addEnvelope => 'Hanampy valopy';

  @override
  String get createExpenseCategoryFirst =>
      'Mamoròna sokajin\'ny fandaniana alohan\'ny hanampiana valopy hafa.';

  @override
  String get monthlyEnvelopes => 'Valopy isam-bolana';

  @override
  String get availableAcrossEnvelopes => 'Vola azo ampiasaina amin\'ny valopy';

  @override
  String get budget => 'Tetibola';

  @override
  String get spent => 'Lany';

  @override
  String get newEnvelope => 'Valopy vaovao';

  @override
  String get name => 'Anarana';

  @override
  String get envelopeNameHint => 'ohatra: Sakafo';

  @override
  String get monthlyAmount => 'Vola isam-bolana';

  @override
  String get expenseCategory => 'Sokajin\'ny fandaniana';

  @override
  String get saving => 'Tehirizina…';

  @override
  String get create => 'Mamorona';

  @override
  String get noEnvelopesYet => 'Tsy mbola misy valopy';

  @override
  String get envelopeEmptyDescription =>
      'Mametraha vola isam-bolana ho an\'ny sokajin\'ny fandaniana. Hanavao azy ho azy ny fandaniana avy amin\'ny resaka.';

  @override
  String get deleteEnvelope => 'Hamafa valopy';

  @override
  String overBudgetBy(String amount) {
    return 'Nihoatra ny tetibola $amount';
  }

  @override
  String amountSpent(String amount) {
    return '$amount no lany';
  }

  @override
  String ofAmount(String amount) {
    return 'amin\'ny $amount';
  }

  @override
  String get feedbackPrompt => 'Lazao anay ny hevitrao';

  @override
  String get feedbackHint => 'Farito ny olana na zarao ny hevitrao';

  @override
  String get feedbackRequired => 'Ampidiro azafady ny hevitrao';

  @override
  String get sendFeedback => 'Alefa ny hevitra';

  @override
  String get feedbackSent => 'Nalefa ny hevitra. Misaotra!';

  @override
  String get availableBalance => 'Vola azo ampiasaina';

  @override
  String get thisMonth => 'Ity volana ity';

  @override
  String get operations => 'Hetsika';

  @override
  String get categories => 'Sokajy';

  @override
  String get deleteTransactionQuestion => 'Hofafana ve ny fifanakalozana?';

  @override
  String get deleteTransactionDescription =>
      'Tena tianao hofafana ve ity fifanakalozana ity? Tsy azo averina intsony izany.';

  @override
  String get deleteBudgetQuestion => 'Hofafana ve ny tetibola?';

  @override
  String get deleteBudgetDescription =>
      'Tena tianao hofafana ve ity tetibola ity? Tsy azo averina intsony izany.';

  @override
  String get deleteGoalQuestion => 'Hofafana ve ny tanjona?';

  @override
  String get deleteGoalDescription =>
      'Tena tianao hofafana ve ity tanjona ity? Tsy azo averina intsony izany.';

  @override
  String get deleteCategoryQuestion => 'Hofafana ve ny sokajy?';

  @override
  String get deleteCategoryDescription =>
      'Tena tianao hofafana ve ity sokajy ity? Tsy azo averina intsony izany.';

  @override
  String get editTransaction => 'Hanova fifanakalozana';

  @override
  String get expense => 'Fandaniana';

  @override
  String get title => 'Lohateny';

  @override
  String get description => 'Fanazavana';

  @override
  String get searchCategories => 'Mitady sokajy';

  @override
  String get done => 'Vita';

  @override
  String get repeatEnvelopeMonthly => 'Averina isam-bolana';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Mamatsy tetibola vaovao avy amin\'ilay poketra ihany isam-bolana raha misy vola ampy.';

  @override
  String get editEnvelope => 'Hanova valopy';

  @override
  String get aiRequestTimedOut =>
      'Ela loatra ny fangatahana tamin\'ny AI. Andramo indray azafady.';

  @override
  String get setupLanguageTitle => 'Ny fiteninao';

  @override
  String get setupLanguageBody =>
      'Safidio ny fiteny ampiasaina ao amin’i Drala.';

  @override
  String get setupCurrencyTitle => 'Ny vola ampiasainao';

  @override
  String get setupCurrencyBody => 'Safidio ny vola hanehoana ny sandany.';

  @override
  String get setupCategoriesTitle => 'Ny sokajinao';

  @override
  String get setupCategoriesBody =>
      'Safidio ireo sokajy ilainao. Afaka manampy hafa ianao any aoriana.';

  @override
  String get setupWalletsTitle => 'Ny kitapom-bolanao';

  @override
  String get setupWalletsBody =>
      'Zarao araka ny fampiasana azy ny volanao. Tafiditra foana ny kitapom-bola fototra.';

  @override
  String get setupContinue => 'Hanohy';

  @override
  String get setupFinish => 'Hanomboka';

  @override
  String get setupCompleteTitle => 'Vita soa!';

  @override
  String get setupCompleteBody => 'Mirary fitantanana mahafinaritra';

  @override
  String get setupDone => 'Tsara';

  @override
  String get setupRetry => 'Hanandrana indray';

  @override
  String get setupMainWallet => 'Kitapom-bola fototra';

  @override
  String get setupCash => 'Vola mivantana';

  @override
  String get setupBank => 'Kaonty banky';

  @override
  String get setupMobile => 'Mobile money';

  @override
  String get authSignUp => 'Hamorona kaonty';

  @override
  String get authSignIn => 'Hiditra';

  @override
  String get authSignUpBody => 'Fenoy ny mombamomba anao dia amboary Drala.';

  @override
  String get authSignInBody => 'Jereo ny kaontinao sy ny fandanianao.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Teny miafina';

  @override
  String get authConfirmPassword => 'Hamafiso ny teny miafina';

  @override
  String get authForgotPassword => 'Hadinonao ny teny miafina?';

  @override
  String get authConfirmEmail =>
      'Hamafiso amin’ny email ny kaontinao, dia midira hamita ny fikirakirana.';

  @override
  String get setupLoadError => 'Tsy azo nampidirina ny safidy. Andramo indray.';

  @override
  String get authResetInstruction =>
      'Ampidiro ny mailakao handraisana kaody fanamarinana.';

  @override
  String get authResetCodeSent => 'Nalefa ny kaody fanamarinana';

  @override
  String get authCodeSentTo => 'Nisy kaody nalefa tany amin’ny';

  @override
  String get authVerificationCode => 'Kaody fanamarinana';

  @override
  String get authEnterSixDigitCode => 'Ampidiro ny kaody 6 isa';

  @override
  String get authResetButton => 'Avereno ny teny miafina';

  @override
  String get authResetSuccess => 'Vita ny famerenana ny teny miafina';
}

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
  String get defaultWalletLabel => 'Voalohany';

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
  String get activities => 'Hetsika';

  @override
  String get reports => 'Tatitra';

  @override
  String get profile => 'Mombamomba';

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
      'Ampiasain’ny valopy na ny tantaran’ny fifanakalozana ity kitapom-bola ity ka tsy azo fafana.';

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
  String get noNotifications =>
      'Efa voarainao daholo ny vaovao! Eto no hisy ny manaraka.';

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
  String get walletSourceChooseAnother => 'Misafidiana kitapom-bola hafa';

  @override
  String walletSourceAmountNeeded(String amount) {
    return 'Mila $amount ity fifanakalozana ity.';
  }

  @override
  String get walletSourceUseWallet => 'Ampiasao ity kitapom-bola ity';

  @override
  String get walletSourceSaveWallet => 'Tehirizo ny kitapom-bola';

  @override
  String get walletSourceDefaultWallet => 'Kitapom-bola fototra';

  @override
  String get walletSourceInsufficientBalance => 'Tsy ampy ny vola';

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
      'Mitahiry angona momba ny kaonty sy ny fifanakalozana i Drala mba hampandeha ny fampiharana. Ny rosia noskenina dia tehirizina amin\'ny toerana manokana ho an\'ny mpampiasa tsirairay ary alefa amin\'ny mpamatsy AI voafantina amin\'ny alalan\'ny lohamilina mba hakana ny angona. Afaka mamafa rosia tsirairay ao amin\'ny Rosia noskenina ianao, na mamafa ny angona rehetra na ny kaontinao manontolo ao amin\'ny fizarana Kaonty ao amin\'ny Fikirana.';

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
  String get accountActions => 'Kaonty';

  @override
  String get dangerZone => 'Faritra mampidi-doza';

  @override
  String get deleteAllData => 'Hamafa ny angonako rehetra';

  @override
  String get deleteAllDataSummary =>
      'Mamafa ny angona sy rakitry ny fampiharana, fa mitahiry ny kaonty fidiranao.';

  @override
  String get deleteAccount => 'Hamafa ny kaontiko';

  @override
  String get deleteAccountSummary =>
      'Mamafa ny kaonty fidiranao, ny angona ary ny rakitra.';

  @override
  String get deleteAllDataQuestion => 'Hofafana ve ny angona rehetra?';

  @override
  String get deleteAllDataDetails =>
      'Hofafana ny fifanakalozana sy ny fivezivezen\'ny vola, ny poketra tsy toerana voalohany, ny sokajy, valopy, tetibola sy ny tantarany, tantaran\'ny AI, tapakila notarafina, fikirana fampandrenesana, mombamomba ary rakitra voatahiry. Hijanona ny kaonty fidiranao. Hotahirizina na hoforonina ny poketra toerana voalohany manana salan\'isa aotra. Haverina avy amin\'ny mailakao ny anaranao, hofafana ny sarinao, ary haverina ho MGA ny volanao.';

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
      'Hofafana ny kaonty fidiranao, mombamomba, fifanakalozana, poketra sy fivezivezen\'ny vola, sokajy, valopy, tetibola sy ny tantarany, tantaran\'ny AI, tapakila notarafina, fikirana fampandrenesana ary rakitra voatahiry. Hivoaka amin\'ny kaonty ianao. Tsy azo averina izany.';

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
  String get noEnvelopesYet =>
      'Omeo toerana ny tetikasanao amin’ny valopy voalohany.';

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
  String get categoryInUse =>
      'Tsy azo fafana ity sokajy ity satria mbola ampiasaina.';

  @override
  String get noActivitiesForDay =>
      'Mbola milamina ny andro. Hanomboka hanara-maso ve isika?';

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

  @override
  String get guestWelcomeTitle => 'Tantano ny volanao';

  @override
  String get guestWelcomeBody =>
      'Amboary amin\'ny dingana vitsivitsy ny teti-bolanao. Afaka manomboka tsy misy kaonty ianao.';

  @override
  String get guestGetStarted => 'Hanomboka';

  @override
  String get guestChoiceTitle => 'Ahoana no tianao hanohizana?';

  @override
  String get guestChoiceBody =>
      'Mamoròna kaonty hampifanarahana ny teti-bolanao, na tehirizo amin\'ity fitaovana ity aloha.';

  @override
  String get guestContinue => 'Hanohy tsy misy kaonty';

  @override
  String get guestSyncNow => 'Ampifanaraho izao';

  @override
  String guestCurrencyRatePending(String preferred, String displayed) {
    return 'Voatahiry ny $preferred. Mbola aseho amin\'ny $displayed ny vola mandra-pahazoana ny tahan\'ny fifanakalozana.';
  }

  @override
  String get guestCurrencyRateStillUnavailable =>
      'Mbola tsy misy ny tahan\'ny fifanakalozana. Andramo indray rehefa misy aterineto.';

  @override
  String get deleteEnvelopeDescription =>
      'Haverina ao amin’ny kitapom-bola ny vola sisa amin’ity valopy ity rehefa fafana. Voatahiry ny tantaran’ny fifanakalozana.';

  @override
  String get insufficientWalletFunds =>
      'Tsy ampy ny vola ao amin’ny kitapom-bola voafidy. Misafidiana kitapom-bola manana vola ampy.';

  @override
  String get envelopeAmountBelowSpent =>
      'Tsy azo atao ambany noho ny vola efa lany ny tetibolan’ny valopy.';

  @override
  String get monthlyScheduleNotLatest =>
      'Ny valopy isam-bolana farany ihany no afaka manova ny fanavaozana azy.';

  @override
  String get selectDate => 'Misafidiana daty';

  @override
  String get transfer => 'Famindram-bola';

  @override
  String get fromWallet => 'Avy amin’ny kitapom-bola';

  @override
  String get toWallet => 'Ho an’ny kitapom-bola';

  @override
  String get transferNeedsWallets =>
      'Manampia kitapom-bola faharoa mba hamindrana vola.';

  @override
  String get transferSaved => 'Voatahiry ny famindram-bola.';

  @override
  String get differentTransferWallets =>
      'Misafidiana kitapom-bola roa samy hafa.';

  @override
  String get walletCurrencyMismatch =>
      'Mila kitapom-bola roa amin’ny MGA ny famindram-bola.';

  @override
  String get walletUnavailable =>
      'Tsy misy intsony ny kitapom-bola voafidy. Misafidiana hafa.';

  @override
  String get transferConflict =>
      'Efa nalefa tamin’ny antsipiriany hafa ity famindram-bola ity. Manomboha famindram-bola vaovao.';

  @override
  String get selectItems => 'Misafidy';

  @override
  String selectedItemCount(int count) {
    return '$count voafidy';
  }

  @override
  String get deleteSelectedItems => 'Fafao ny voafidy';

  @override
  String deleteSelectedWalletsDescription(int count) {
    return 'Hofafana ve ireo kitapom-bola $count voafidy? Tsy azo averina izany.';
  }

  @override
  String deleteSelectedEnvelopesDescription(int count) {
    return 'Hofafana ve ireo valopy $count voafidy? Haverina ao amin’ny kitapom-bola ny vola sisa. Voatahiry ny tantara.';
  }

  @override
  String get defaultWalletCannotDelete =>
      'Tsy azo fafana ny kitapom-bola fototra. Misafidiana kitapom-bola fototra hafa aloha.';

  @override
  String get envelopeUnavailable =>
      'Tsy misy intsony ny valopy voafidy. Havaozy ny lisitra.';

  @override
  String get operationInProgress =>
      'Andraso ho vita ny asa efa mandeha azafady.';

  @override
  String get dailyReminderNotificationTitle => 'Fampahatsiahivana isan’andro';

  @override
  String get dailyReminderNotificationBody =>
      'Aza adino ny manoratra ny fandaniana na ny vola miditra androany.';

  @override
  String get categoryNameRequired => 'Ampidiro ny anaran’ny sokajy.';

  @override
  String get envelopeNameRequired => 'Ampidiro ny anaran’ny valopy.';

  @override
  String get envelopeCategoryRequired =>
      'Misafidiana sokajy ho an’ity valopy ity.';

  @override
  String get fieldRequired => 'Tsy maintsy fenoina ity saha ity.';

  @override
  String get positiveAmountRequired => 'Ampidiro ny vola mihoatra ny aotra.';

  @override
  String get nonNegativeAmountRequired =>
      'Ampidiro ny ambim-bola aotra na mihoatra.';

  @override
  String get envelopeFundingWalletFixed =>
      'Ny valopy efa misy dia mitazona ny kitapom-bola namatsiana azy tany am-boalohany.';

  @override
  String get envelopeFundingWalletUnavailable =>
      'Tsy misy ny kitapom-bola namatsiana ny valopy';

  @override
  String get home => 'Fandraisana';

  @override
  String get seeMore => 'Hijery misimisy';

  @override
  String get recentTransactions => 'Fifanakalozana farany';

  @override
  String get envelopes => 'Valopy';

  @override
  String activityEmptyWithAction(String action) {
    return 'Somary mangina androany. $action mba hanombohana.';
  }

  @override
  String homeEmptyEnvelopeMessage(String action) {
    return 'Omeo toerana ny tetikasanao amin’ny $action.';
  }

  @override
  String get homeEmptyEnvelopeAction => 'valopy voalohany';

  @override
  String homeEmptyTransactionMessage(String action) {
    return '$action hanombohana manara-maso ny teti-bolanao.';
  }

  @override
  String get homeEmptyTransactionAction =>
      'Ampidiro ny fifanakalozana voalohany';

  @override
  String get noRecentTransactions =>
      'Ampidiro ny fifanakalozana voalohany hanombohana manara-maso ny teti-bolanao.';

  @override
  String get overviewLoadFailed => 'Tsy afaka nanavao. Andramo indray.';

  @override
  String get homeHello => 'Salama';

  @override
  String homeGreeting(String name) {
    return 'Salama, $name';
  }

  @override
  String get networkUnavailable =>
      'Tsy afaka mifandray amin’ny lohamilina. Hamarino ny fifandraisana internet ary andramo indray.';

  @override
  String get offlineModeToast =>
      'Tapaka ny fifandraisana. Miasa tsy misy internet izao ny rindranasa. Halefa rehefa miverina ny fifandraisana ny fanovana nataonao.';

  @override
  String get onlineModeToast =>
      'Tafaverina ny fifandraisana. Vita ny fampifanarahana ny fanovana nataonao.';

  @override
  String get onlinePendingToast =>
      'Tafaverina ny fifandraisana. Misy fanovana mbola mila jerenao.';

  @override
  String get offlineStatus =>
      'Tsy misy internet · voatahiry ato amin’ity fitaovana ity ny fanovana';

  @override
  String get syncingStatus => 'Mampifanaraka ny fanovana nataonao…';

  @override
  String pendingStatus(int count) {
    return 'Fanovana $count miandry halefa';
  }

  @override
  String get offlineInitial =>
      'Mifandraisa amin’ny internet mba hisintonana ny angon-kaontinao hampiasaina tsy misy internet.';

  @override
  String get offlineSetupUnavailable =>
      'Tsy azo ampifanarahana izao. Voatahiry ato amin’ity fitaovana ity ny fanovana nataonao.';

  @override
  String get syncConflictTitle => 'Jereo ny fanovana alohan’ny hampifanarahana';

  @override
  String get syncConflictMessage =>
      'Niova ny angona an-tserasera raha tsy nisy internet ity fitaovana ity. Jereo ny fanovana nataonao alohan’ny hanandramana indray, na ampiasao ny angona an-tserasera.';

  @override
  String get offlineRetry => 'Andramo indray';

  @override
  String get offlineReview => 'Hijery';

  @override
  String get offlineKeepCloud => 'Ampiasao ny angona an-tserasera';

  @override
  String get offlineRetryChanges => 'Ampifanaraho ireo fanovana';

  @override
  String get offlineDiscardTitle =>
      'Fafana ny fanovana voatahiry ato amin’ity fitaovana ity ?';

  @override
  String get offlineDiscardBody =>
      'Mbola tsy nalefa an-tserasera ireo fanovana ireo. Hofafana ato amin’ity fitaovana ity izy ireo ary hosoloina ny angona an-tserasera.';

  @override
  String get onlineRequired => 'Mila fifandraisana internet ity asa ity.';

  @override
  String get signInSyncRequired =>
      'Midira indray mba hampifanarahana. Voatahiry ny fanovana nataonao.';

  @override
  String get categoryIconFood => 'Sakafo sy zava-pisotro';

  @override
  String get categoryIconShopping => 'Fiantsenana';

  @override
  String get categoryIconTransport => 'Fitaterana';

  @override
  String get categoryIconHousing => 'Trano';

  @override
  String get categoryIconHealth => 'Fahasalamana';

  @override
  String get categoryIconUtilities => 'Jiro sy rano';

  @override
  String get categoryIconEntertainment => 'Fialam-boly';

  @override
  String get categoryIconEducation => 'Fanabeazana';

  @override
  String get categoryIconSalary => 'Karama';

  @override
  String get categoryIconFreelance => 'Asa mahaleo tena';

  @override
  String get categoryIconIncome => 'Vola miditra';

  @override
  String get categoryIconOther => 'Hafa';

  @override
  String get categoryIconCoffee => 'Kafe';

  @override
  String get categoryIconDining => 'Toeram-pisakafoanana';

  @override
  String get categoryIconTravel => 'Dia';

  @override
  String get categoryIconGifts => 'Fanomezana';

  @override
  String get categoryIconPets => 'Biby fiompy';

  @override
  String get categoryIconFamily => 'Fianakaviana';

  @override
  String get categoryIconSubscriptions => 'Famandrihana';

  @override
  String get categoryIconPhone => 'Finday';

  @override
  String get categoryIconInternet => 'Aterineto';

  @override
  String get categoryIconSavings => 'Tahiry';

  @override
  String get categoryIconInvestment => 'Fampiasam-bola';

  @override
  String get categoryIconInsurance => 'Fiantohana';

  @override
  String get categoryIconTaxes => 'Hetra';

  @override
  String get categoryIconFitness => 'Fanatanjahan-tena';

  @override
  String get categoryIconBeauty => 'Fikarakarana tena';

  @override
  String get categoryIconClothing => 'Akanjo';

  @override
  String get categoryIconRepairs => 'Fanamboarana';

  @override
  String get categoryIconFuel => 'Solika';

  @override
  String get categoryIconBicycle => 'Bisikileta';

  @override
  String get categoryIconBus => 'Fitateram-bahoaka';

  @override
  String get categoryIconRain => 'Tahiry vonjy taitra';

  @override
  String get categoryIconCharity => 'Fanampiana';

  @override
  String get categoryIconMusic => 'Mozika';

  @override
  String get categoryIconBooks => 'Boky';

  @override
  String get categoryIconTransfer => 'Famindram-bola';

  @override
  String get chooseCategoryIcon => 'Misafidiana kisary';

  @override
  String get searchCategoryIcons => 'Hitady kisary';

  @override
  String get activitiesComposerHint => 'Lazao izay nandanianao vola…';

  @override
  String get createEnvelope => 'Hamorona valopy';

  @override
  String get trackYourBudget => 'Araho ny tetibolanao';

  @override
  String get emptyCategories => 'Omeo toerana izay zava-dehibe aminao.';

  @override
  String get emptyWallets =>
      'Eto no manomboka ny toerana hitehirizana ny volanao.';

  @override
  String get createCategory => 'Hamorona sokajy';

  @override
  String get emptyExpenses =>
      'Dingana kely hanatsarana ny teti-bola: ampidiro ny fandaniana voalohany.';

  @override
  String get emptyIncomes =>
      'Manokatra fahafahana vaovao ny vola miditra. Ampidiro ny anao!';

  @override
  String get emptySearch =>
      'Andao hanandrana fikarohana hafa hahitana izay tadiavinao.';

  @override
  String get createExpense => 'Hanampy fandaniana';

  @override
  String get createIncome => 'Hanampy vola miditra';

  @override
  String get resetSearch => 'Hamerina ny fikarohana';

  @override
  String get emptyBudgets =>
      'Omeo lalana ny fandanianao amin’ny teti-bola voalohany.';

  @override
  String get emptyGoals =>
      'Manomboka amin’ny tahiry kely ny tetikasa lehibe. Inona ny tanjonao?';

  @override
  String get createBudget => 'Hamorona teti-bola';

  @override
  String get createGoal => 'Hamorona tanjona';

  @override
  String get manageNotifications => 'Hitantana fampandrenesana';

  @override
  String get envelopeRemaining => 'Ambiny';

  @override
  String get envelopeBudgetOf => 'amin’ny';

  @override
  String get statsNet => 'Ambiny';

  @override
  String get statsNetDescription => 'Vola miditra esorina ny fandaniana';

  @override
  String get statsNumbers => 'Ny isa';

  @override
  String get statsCategories => 'Ny sokajy';

  @override
  String get statsOnAverage => 'amin’ny salanisa';

  @override
  String get statsPreviousMonth => 'vs volana lasa';

  @override
  String get statsEmptyCategories =>
      'Ampidiro ny fandaniana hahitana ny fizarana isaky ny sokajy.';

  @override
  String statsActivityCount(int count) {
    return '$count hetsika';
  }

  @override
  String get chooseCategoryColor => 'Misafidiana loko';

  @override
  String get settingsGuestSyncPrompt =>
      'Midira mba hampifanarahana ny teti-bolanao.';

  @override
  String get dailyAiCreditsExhausted =>
      'Lany ny crédit AI androany. Hiverina rahampitso izy ireo.';

  @override
  String get logOutConfirmation => 'Tena te hivoaka ve ianao ?';

  @override
  String get offlineBannerMessage =>
      'Tsy mifandray amin\'ny internet ianao izao';

  @override
  String get dismissOfflineBanner => 'Hidio';

  @override
  String get entryAdded => 'Voampiditra ny fifanakalozana.';

  @override
  String get entryUpdated => 'Nohavaozina ny fifanakalozana.';

  @override
  String get entryDeleted => 'Voafafa ny fifanakalozana.';

  @override
  String aiEntriesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fifanakalozana $count voampiditra.',
      one: 'Fifanakalozana 1 voampiditra.',
    );
    return '$_temp0';
  }

  @override
  String get insufficientFundsAllWallets =>
      'Tsy ampy ny vola ao amin’ny poketra rehetra.';

  @override
  String get transactionNotCompletedInsufficientFunds =>
      'Tsy ampy ny vola. Tsy vita ny fifanakalozana.';

  @override
  String get aiPaidTierNotice =>
      'Nampiasa tolotra AI andoavam-bola ity fangatahana ity.';

  @override
  String get receiptImportedReady =>
      'Voafandrika ny rakitra ary vonona hovakian’ny AI.';

  @override
  String get receiptScannedReady =>
      'Voaskana ny rosia ary vonona hovakian’ny AI.';

  @override
  String get savingsCategoryLocked =>
      'Ampiasaina amin’ny tanjona fitahirizam-bola ity sokajy ity ka tsy azo ovaina.';

  @override
  String get plusCheckoutUnavailable =>
      'Ho azo atao ny famandrihana Drala Plus rehefa voalamina ny fandoavam-bola.';

  @override
  String get genericError => 'Nisy olana. Andramo indray azafady.';

  @override
  String get serverError =>
      'Nisy olana teo amin’ny lohamilina. Andramo indray azafady.';

  @override
  String get signInToContinue => 'Midira amin’ny kaontinao vao manohy azafady.';

  @override
  String get invalidCredentials => 'Diso ny mailaka na ny teny miafina.';

  @override
  String get emailNotConfirmed => 'Hamarino aloha ny mailakao vao miditra.';

  @override
  String get accountNotFound =>
      'Tsy misy kaonty mifanaraka amin’io mailaka io.';

  @override
  String get emailAlreadyUsed => 'Efa ampiasaina io mailaka io.';

  @override
  String get emailPasswordRequired => 'Ampidiro ny mailaka sy ny teny miafina.';

  @override
  String get weakPassword => 'Malemy loatra ny teny miafina.';

  @override
  String get checkRequiredFields => 'Hamarino ireo saha tsy maintsy fenoina.';

  @override
  String get duplicateEntry => 'Efa misy zavatra mitovy amin’izany.';

  @override
  String get accessDenied => 'Nolavina ny fidirana. Andramo indray azafady.';

  @override
  String get fileNotFound => 'Tsy hita ny rakitra.';

  @override
  String get fileProcessingFailed =>
      'Tsy voahodina ny rakitra. Andramo indray azafady.';

  @override
  String get noCameraAvailable =>
      'Tsy misy fakan-tsary amin’ity fitaovana ity.';

  @override
  String get receiptFileTooLarge =>
      'Tsy maintsy latsaky ny 15 MB ny rakitra rosia tsirairay.';

  @override
  String get receiptFormatUnsupported =>
      'Rosia JPG, PNG ary PDF ihany no ekena.';

  @override
  String get receiptScanningUnavailable => 'Tsy azo atao ny manaskana rosia.';

  @override
  String get receiptUnreadable => 'Tsy azo vakiana ity rosia ity.';

  @override
  String get receiptTooLarge =>
      'Lehibe loatra ity rosia ity. Ahenao ny pejy na ataovy kely kokoa.';

  @override
  String get receiptPdfUnsupported =>
      'Tsy azo vakiana amin’izao ny rosia PDF. Manaskana na mampidira sary kosa.';

  @override
  String get receiptNotFound => 'Tsy hita ny rosia.';

  @override
  String get aiDailyLimitReached =>
      'Lany ny crédit AI-nao androany. Andramo indray rahampitso.';

  @override
  String get aiRateLimited =>
      'Be loatra ny fangatahana. Miandrasa segondra vitsivitsy dia andramo indray.';

  @override
  String get aiUnreadableResponse =>
      'Tsy azon’ny AI izany. Andramo averina amin’ny fomba hafa.';

  @override
  String get aiServiceUnavailable =>
      'Tsy misy ny serivisy AI amin’izao. Andramo indray any aoriana.';

  @override
  String get futureDateNotAllowed =>
      'Tsy azo ampidirina amin’ny daty ho avy ny fifanakalozana.';

  @override
  String get invalidEntryRequest =>
      'Ampidiro hafatra sy daty fifanakalozana marina.';

  @override
  String get amountOutOfRange =>
      'Kely loatra na lehibe loatra ity vola ity ka tsy azo raketina.';

  @override
  String get exchangeRateUnavailable =>
      'Tsy misy ny taham-pifanakalozana amin’izao. Andramo indray any aoriana.';
}

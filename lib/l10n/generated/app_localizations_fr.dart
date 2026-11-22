// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Dépassé de $amount';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Paramètres';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get preferences => 'Préférences';

  @override
  String get notification => 'Notifications';

  @override
  String get currency => 'Devise';

  @override
  String get setDefaultWallet => 'Portefeuille par défaut';

  @override
  String get defaultWalletLabel => 'Par défaut';

  @override
  String get theme => 'Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get scannedReceipts => 'Reçus numérisés';

  @override
  String get legal => 'Mentions légales';

  @override
  String get termsOfService => 'Conditions d’utilisation';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get adPrivacyOptions => 'Choix de confidentialité des annonces';

  @override
  String get legalConsentPrefix => 'J’accepte les ';

  @override
  String get legalConsentConnector => ' et la ';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get malagasy => 'Malgache';

  @override
  String get german => 'Allemand';

  @override
  String get spanish => 'Espagnol';

  @override
  String get italian => 'Italien';

  @override
  String get menu => 'Menu';

  @override
  String get collapseMenu => 'Réduire le menu';

  @override
  String get expandMenu => 'Développer le menu';

  @override
  String get activities => 'Activités';

  @override
  String get reports => 'Rapports';

  @override
  String get profile => 'Profil';

  @override
  String get envelope => 'Enveloppes';

  @override
  String get stats => 'Statistiques';

  @override
  String get feedback => 'Avis';

  @override
  String get resumeFromDate => 'Reprendre à une date précise';

  @override
  String get wallets => 'Portefeuilles';

  @override
  String get addWallet => 'Ajouter un portefeuille';

  @override
  String get walletNameLabel => 'Nom du portefeuille';

  @override
  String get walletNameHint => 'ex. Épargne';

  @override
  String get currentBalanceLabel => 'Solde actuel';

  @override
  String get editWallet => 'Modifier le portefeuille';

  @override
  String get deleteWallet => 'Supprimer le portefeuille';

  @override
  String get deleteWalletQuestion => 'Supprimer ce portefeuille ?';

  @override
  String get deleteWalletDescription =>
      'Ce portefeuille sera supprimé définitivement. Son historique de transactions restera intact.';

  @override
  String get walletUpdated => 'Portefeuille modifié.';

  @override
  String get walletDeleted => 'Portefeuille supprimé.';

  @override
  String get walletInUseCannotBeDeleted =>
      'Ce portefeuille est utilisé par une enveloppe ou un historique de transactions et ne peut pas être supprimé.';

  @override
  String get allTime => 'Depuis toujours';

  @override
  String get showBalance => 'Afficher le solde';

  @override
  String get hideBalance => 'Masquer le solde';

  @override
  String get overallBalance => 'Solde restant des portefeuilles';

  @override
  String takenFromEnvelope(String name) {
    return 'Prélevé sur l’enveloppe $name';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications =>
      'Vous êtes à jour ! Vos prochaines nouvelles vous attendront ici.';

  @override
  String get noNotificationsDescription =>
      'Les alertes de budget et les informations financières importantes apparaîtront ici.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'Vous avez dépassé le budget de l\'enveloppe $name.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'Le budget de l\'enveloppe $name est presque épuisé.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'Le budget de l\'enveloppe $name est atteint.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Aujourd’hui, $date';
  }

  @override
  String get noEntriesForDate => 'Aucune entrée pour cette date';

  @override
  String get emptyStateWelcomeBack => 'Bon retour !';

  @override
  String get emptyStateWelcomeTo => 'Bienvenue sur';

  @override
  String get emptyStateIncomePrompt =>
      'Une rentrée d’argent ? Dites-m’en plus pour qu’on puisse célébrer… et l’enregistrer.';

  @override
  String get emptyStateExpensePrompt =>
      'Une dépense plaisir (ou nécessaire) ? Dites-moi combien et pour quoi… je tiens les comptes.';

  @override
  String get emptyStateTransferPrompt =>
      'Un transfert d’argent ? Indiquez-moi le compte de départ → d’arrivée et je m’en occupe.';

  @override
  String get firstEntryIncomePrompt =>
      'Commencez par un revenu ou une dépense. Écrivez « J’ai reçu xxx » ou « J’ai dépensé xxx en nourriture » et je l’enregistrerai.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrées',
      one: '1 entrée',
      zero: '0 entrée',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses',
      one: '1 dépense',
      zero: '0 dépense',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count revenus',
      one: '1 revenu',
      zero: '0 revenu',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferts',
      one: '1 transfert',
      zero: '0 transfert',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests => 'Requêtes IA illimitées avec Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'Il vous reste $count requêtes IA aujourd’hui';
  }

  @override
  String get chatHint => 'Vos dépenses…';

  @override
  String get startTyping => 'Commencez à écrire...';

  @override
  String get chatIncomeHint => 'Vos gains…';

  @override
  String get chatTransferHint => 'Transfert entre portefeuilles…';

  @override
  String expenseSuggestion(Object amount) {
    return 'J’ai dépensé $amount pour des burgers';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'J’ai reçu $amount de salaire';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Transférer $amount de Principal à Épargne';
  }

  @override
  String get addReceipt => 'Ajouter un reçu';

  @override
  String get manualEntry => 'Saisie manuelle';

  @override
  String get send => 'Envoyer';

  @override
  String get enterManually => 'Saisir manuellement';

  @override
  String get importFile => 'Importer un fichier';

  @override
  String get scanReceipt => 'Numériser un reçu';

  @override
  String get receiptGalleryEmpty =>
      'Vos reçus numérisés et importés apparaîtront ici.';

  @override
  String get deleteReceiptQuestion => 'Supprimer ce reçu ?';

  @override
  String get deleteReceiptDescription =>
      'Toutes les pages de ce reçu seront supprimées.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get receiptDeleted => 'Reçu supprimé.';

  @override
  String get receipt => 'Reçu';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages de reçu',
      one: '1 page de reçu',
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
  String get deleteReceipt => 'Supprimer le reçu';

  @override
  String get save => 'Enregistrer';

  @override
  String get username => 'Nom d’utilisateur';

  @override
  String get enterUsername => 'Saisissez votre nom d’utilisateur';

  @override
  String get user => 'Utilisateur';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get enterCurrentPassword => 'Saisissez votre mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get enterNewPassword => 'Saisissez votre nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmNewPassword => 'Confirmez votre nouveau mot de passe';

  @override
  String get passwordsDoNotMatch =>
      'Les nouveaux mots de passe ne correspondent pas.';

  @override
  String get passwordMustDiffer =>
      'Choisissez un mot de passe différent de l’actuel.';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour.';

  @override
  String get searchCurrency => 'Rechercher une devise';

  @override
  String errorWithMessage(Object message) {
    return 'Erreur : $message';
  }

  @override
  String get defaultWalletDescription =>
      'Les dépenses et les nouvelles enveloppes utilisent ce portefeuille par défaut.';

  @override
  String get walletSourceChooseAnother => 'Choisir un autre portefeuille';

  @override
  String walletSourceAmountNeeded(String amount) {
    return 'Cette opération nécessite $amount.';
  }

  @override
  String get walletSourceUseWallet => 'Utiliser ce portefeuille';

  @override
  String get walletSourceSaveWallet => 'Enregistrer le portefeuille';

  @override
  String get walletSourceDefaultWallet => 'Portefeuille par défaut';

  @override
  String get walletSourceInsufficientBalance => 'Solde insuffisant';

  @override
  String get defaultWalletUpdated => 'Portefeuille par défaut mis à jour.';

  @override
  String get termsIntro =>
      'Ces conditions expliquent les règles d’utilisation de Drala.';

  @override
  String get termsDetails =>
      'Utilisez Drala uniquement pour gérer légalement vos finances personnelles. Vous restez responsable de la vérification des entrées créées par l’IA avant de vous y fier. La disponibilité du service peut évoluer avec l’application.';

  @override
  String get privacyIntro => 'Vos informations financières vous appartiennent.';

  @override
  String get privacyDetails =>
      'Drala conserve les données de compte et de transaction nécessaires au fonctionnement de l’application. Les reçus numérisés sont stockés dans un espace privé propre à chaque utilisateur et transmis au fournisseur d’IA configuré via le backend pour extraction. Vous pouvez supprimer un reçu depuis Reçus numérisés, toutes vos données ou votre compte complet depuis la section Compte des paramètres.';

  @override
  String get legalLastUpdated => 'Dernière mise à jour : 21 juillet 2026';

  @override
  String get allowNotifications => 'Autoriser les notifications';

  @override
  String get dailyReminders => 'Rappels quotidiens';

  @override
  String get budgetAlerts => 'Alertes de budget';

  @override
  String get selectReminderTime => 'Choisir l’heure du rappel';

  @override
  String get preferredReminderTime => 'Heure de rappel préférée';

  @override
  String get reminderDeliveryTime => 'Heure d’envoi du rappel quotidien';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get notificationPermissionMessage =>
      'Autorisez les notifications pour recevoir les rappels quotidiens et les alertes de budget.';

  @override
  String get allow => 'Autoriser';

  @override
  String get deny => 'Refuser';

  @override
  String get notificationsBlocked => 'Notifications bloquées';

  @override
  String get notificationsBlockedMessage =>
      'Autorisez les notifications dans les paramètres de votre appareil pour recevoir les rappels et alertes.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get accountActions => 'Compte';

  @override
  String get dangerZone => 'Zone de danger';

  @override
  String get deleteAllData => 'Supprimer toutes mes données';

  @override
  String get deleteAllDataSummary =>
      'Supprime les données et fichiers de l’application, mais conserve votre compte de connexion.';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteAccountSummary =>
      'Supprime votre compte de connexion, vos données et fichiers.';

  @override
  String get deleteAllDataQuestion => 'Supprimer toutes les données ?';

  @override
  String get deleteAllDataDetails =>
      'Supprime les transactions et mouvements de portefeuille, les portefeuilles non définis par défaut, les catégories, enveloppes, budgets et historiques, historiques IA, reçus numérisés, paramètres de notification, données du profil et fichiers stockés. Votre compte de connexion est conservé. Un portefeuille par défaut avec un solde nul est conservé ou créé. Votre nom est réinitialisé à partir de votre e-mail, votre photo est supprimée et votre devise redevient MGA.';

  @override
  String get deleteKeyword => 'SUPPRIMER';

  @override
  String get typeDeleteToConfirm => 'Saisissez SUPPRIMER pour confirmer.';

  @override
  String get allDataDeleted => 'Toutes vos données ont été supprimées.';

  @override
  String get deleteAccountQuestion => 'Supprimer définitivement le compte ?';

  @override
  String get deleteAccountDetails =>
      'Supprime votre compte de connexion, profil, transactions, portefeuilles et mouvements, catégories, enveloppes, budgets et historiques, historiques IA, reçus numérisés, paramètres de notification et fichiers stockés. Vous serez déconnecté. Cette action est irréversible.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Saisissez $value pour confirmer.';
  }

  @override
  String get accountDeleted => 'Votre compte a été supprimé.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get chooseSource => 'Choisir une source';

  @override
  String get fromGallery => 'Depuis la galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get mediaPermissionMessage =>
      'Nous avons besoin de la caméra et de l’accès aux fichiers pour continuer.';

  @override
  String get cameraDenied => 'Accès à la caméra refusé.';

  @override
  String get mediaDenied => 'Accès aux médias refusé.';

  @override
  String get imageSelectionFailed => 'Impossible de sélectionner l’image.';

  @override
  String get usernameUpdateFailed =>
      'Impossible de mettre à jour le nom d’utilisateur.';

  @override
  String get profilePhotoUploadFailed =>
      'Impossible de téléverser la photo de profil.';

  @override
  String get back => 'Retour';

  @override
  String get enterEmail => 'Saisissez une adresse e-mail';

  @override
  String get invalidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get enterPassword => 'Saisissez un mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get passwordNeedsUppercase =>
      'Le mot de passe doit contenir au moins une majuscule.';

  @override
  String get passwordNeedsLowercase =>
      'Le mot de passe doit contenir au moins une minuscule.';

  @override
  String get passwordNeedsNumber =>
      'Le mot de passe doit contenir au moins un chiffre.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'Le mot de passe doit contenir au moins un caractère spécial.';

  @override
  String get passwordRuleMinLength => '8 caractères ou plus';

  @override
  String get passwordRuleUppercase => 'Au moins une lettre majuscule';

  @override
  String get passwordRuleLowercase => 'Au moins une lettre minuscule';

  @override
  String get passwordRuleNumber => 'Au moins un chiffre';

  @override
  String get passwordRuleSpecialCharacter => 'Au moins un caractère spécial';

  @override
  String get netThisMonth => 'Solde net du mois';

  @override
  String get transactions => 'Transactions';

  @override
  String get homeWelcome => 'Bienvenue';

  @override
  String get averagePerDay => 'Moyenne / jour';

  @override
  String get expenses => 'Dépenses';

  @override
  String get income => 'Revenus';

  @override
  String get largestExpense => 'Plus grande dépense';

  @override
  String get dailySpending => 'Dépenses quotidiennes';

  @override
  String get topSpending => 'Principales dépenses';

  @override
  String get noExpensesThisMonth => 'Aucune dépense ce mois-ci';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage % de plus que le mois dernier';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage % de moins que le mois dernier';
  }

  @override
  String get addEnvelope => 'Ajouter une enveloppe';

  @override
  String get createExpenseCategoryFirst =>
      'Créez une catégorie de dépense avant d’ajouter une autre enveloppe.';

  @override
  String get monthlyEnvelopes => 'Enveloppes mensuelles';

  @override
  String get availableAcrossEnvelopes => 'Disponible dans les enveloppes';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Dépensé';

  @override
  String get newEnvelope => 'Nouvelle enveloppe';

  @override
  String get name => 'Nom';

  @override
  String get envelopeNameHint => 'ex. Courses';

  @override
  String get monthlyAmount => 'Montant mensuel';

  @override
  String get expenseCategory => 'Catégorie de dépense';

  @override
  String get saving => 'Enregistrement…';

  @override
  String get create => 'Créer';

  @override
  String get noEnvelopesYet =>
      'Faites une place à vos projets avec votre première enveloppe.';

  @override
  String get envelopeEmptyDescription =>
      'Définissez un montant mensuel pour une catégorie de dépense. Les dépenses saisies dans le chat la mettront automatiquement à jour.';

  @override
  String get deleteEnvelope => 'Supprimer l’enveloppe';

  @override
  String overBudgetBy(String amount) {
    return 'Budget dépassé de $amount';
  }

  @override
  String amountSpent(String amount) {
    return '$amount dépensés';
  }

  @override
  String ofAmount(String amount) {
    return 'sur $amount';
  }

  @override
  String get feedbackPrompt => 'Dites-nous ce que vous en pensez';

  @override
  String get feedbackHint => 'Décrivez un problème ou partagez une idée';

  @override
  String get feedbackRequired => 'Veuillez saisir votre avis';

  @override
  String get sendFeedback => 'Envoyer l’avis';

  @override
  String get feedbackSent => 'Avis envoyé. Merci !';

  @override
  String get availableBalance => 'Solde disponible';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get operations => 'Opérations';

  @override
  String get categories => 'Catégories';

  @override
  String get deleteTransactionQuestion => 'Supprimer la transaction ?';

  @override
  String get deleteTransactionDescription =>
      'Voulez-vous vraiment supprimer cette transaction ? Cette action est irréversible.';

  @override
  String get deleteBudgetQuestion => 'Supprimer le budget ?';

  @override
  String get deleteBudgetDescription =>
      'Voulez-vous vraiment supprimer ce budget ? Cette action est irréversible.';

  @override
  String get deleteGoalQuestion => 'Supprimer l’objectif ?';

  @override
  String get deleteGoalDescription =>
      'Voulez-vous vraiment supprimer cet objectif ? Cette action est irréversible.';

  @override
  String get deleteCategoryQuestion => 'Supprimer la catégorie ?';

  @override
  String get deleteCategoryDescription =>
      'Voulez-vous vraiment supprimer cette catégorie ? Cette action est irréversible.';

  @override
  String get categoryInUse =>
      'Cette catégorie ne peut pas être supprimée car elle est actuellement utilisée.';

  @override
  String get noActivitiesForDay =>
      'Une journée encore tranquille. On commence le suivi ?';

  @override
  String get editTransaction => 'Modifier la transaction';

  @override
  String get expense => 'Dépense';

  @override
  String get title => 'Titre';

  @override
  String get description => 'Description';

  @override
  String get searchCategories => 'Rechercher une catégorie';

  @override
  String get done => 'Terminé';

  @override
  String get repeatEnvelopeMonthly => 'Renouveler chaque mois';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Financer un nouveau budget depuis le même portefeuille chaque mois, dès que les fonds sont disponibles.';

  @override
  String get editEnvelope => 'Modifier l’enveloppe';

  @override
  String get aiRequestTimedOut =>
      'La requête IA a pris trop de temps. Veuillez réessayer.';

  @override
  String get setupLanguageTitle => 'Votre langue';

  @override
  String get setupLanguageBody => 'Choisissez la langue de Drala.';

  @override
  String get setupCurrencyTitle => 'Votre devise';

  @override
  String get setupCurrencyBody =>
      'Choisissez la devise d’affichage des montants.';

  @override
  String get setupCategoriesTitle => 'Vos catégories';

  @override
  String get setupCategoriesBody =>
      'Gardez celles qui vous sont utiles. Vous pourrez en ajouter plus tard.';

  @override
  String get setupWalletsTitle => 'Vos portefeuilles';

  @override
  String get setupWalletsBody =>
      'Séparez votre argent selon son usage. Le portefeuille principal est toujours inclus.';

  @override
  String get setupContinue => 'Continuer';

  @override
  String get setupFinish => 'Commencer';

  @override
  String get setupCompleteTitle => 'Tout est prêt !';

  @override
  String get setupCompleteBody => 'Bonne gestion';

  @override
  String get setupDone => 'Super';

  @override
  String get setupRetry => 'Réessayer';

  @override
  String get setupMainWallet => 'Portefeuille principal';

  @override
  String get setupCash => 'Espèces';

  @override
  String get setupBank => 'Compte bancaire';

  @override
  String get setupMobile => 'Mobile money';

  @override
  String get authSignUp => 'Créer un compte';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignUpBody => 'Quelques détails, puis un Drala à votre image.';

  @override
  String get authSignInBody => 'Retrouvez vos comptes et vos dépenses.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authConfirmEmail =>
      'Confirmez votre compte depuis votre email, puis connectez-vous pour terminer la configuration.';

  @override
  String get setupLoadError => 'Impossible de charger les choix. Réessayez.';

  @override
  String get authResetInstruction =>
      'Saisissez votre e-mail pour recevoir un code de vérification.';

  @override
  String get authResetCodeSent => 'Code de vérification envoyé';

  @override
  String get authCodeSentTo => 'Un code a été envoyé à';

  @override
  String get authVerificationCode => 'Code de vérification';

  @override
  String get authEnterSixDigitCode => 'Saisissez le code à 6 chiffres';

  @override
  String get authResetButton => 'Réinitialiser le mot de passe';

  @override
  String get authResetSuccess => 'Mot de passe réinitialisé';

  @override
  String get guestWelcomeTitle => 'Prenez le contrôle de votre argent';

  @override
  String get guestWelcomeBody =>
      'Configurez votre budget en quelques étapes. Vous pouvez commencer sans compte.';

  @override
  String get guestGetStarted => 'Commencer';

  @override
  String get guestChoiceTitle => 'Comment souhaitez-vous continuer ?';

  @override
  String get guestChoiceBody =>
      'Créez un compte pour synchroniser votre budget, ou gardez-le sur cet appareil pour le moment.';

  @override
  String get guestContinue => 'Continuer en invité';

  @override
  String get guestSyncNow => 'Synchroniser maintenant';

  @override
  String guestCurrencyRatePending(String preferred, String displayed) {
    return 'La devise $preferred est enregistrée. Les montants restent en $displayed tant que les taux de change sont indisponibles.';
  }

  @override
  String get guestCurrencyRateStillUnavailable =>
      'Les taux de change sont encore indisponibles. Réessayez une fois connecté.';

  @override
  String get deleteEnvelopeDescription =>
      'La suppression de cette enveloppe restitue le solde restant à son portefeuille. L’historique est conservé.';

  @override
  String get insufficientWalletFunds =>
      'Le portefeuille sélectionné ne dispose pas de fonds suffisants. Choisissez un portefeuille avec un solde suffisant.';

  @override
  String get envelopeAmountBelowSpent =>
      'Le montant de l’enveloppe ne peut pas être inférieur au montant déjà dépensé.';

  @override
  String get monthlyScheduleNotLatest =>
      'Seule la dernière enveloppe mensuelle peut modifier ses paramètres de renouvellement.';

  @override
  String get selectDate => 'Choisir une date';

  @override
  String get transfer => 'Transfert';

  @override
  String get fromWallet => 'Du portefeuille';

  @override
  String get toWallet => 'Vers le portefeuille';

  @override
  String get transferNeedsWallets =>
      'Ajoutez un deuxième portefeuille pour transférer de l’argent.';

  @override
  String get transferSaved => 'Transfert enregistré.';

  @override
  String get differentTransferWallets =>
      'Choisissez deux portefeuilles différents.';

  @override
  String get walletCurrencyMismatch =>
      'Les transferts nécessitent deux portefeuilles en MGA.';

  @override
  String get walletUnavailable =>
      'Un portefeuille sélectionné n’est plus disponible. Choisissez-en un autre.';

  @override
  String get transferConflict =>
      'Ce transfert a déjà été envoyé avec des détails différents. Ouvrez un nouveau transfert.';

  @override
  String get selectItems => 'Sélectionner';

  @override
  String selectedItemCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get deleteSelectedItems => 'Supprimer la sélection';

  @override
  String deleteSelectedWalletsDescription(int count) {
    return 'Supprimer les $count portefeuilles sélectionnés ? Cette action est irréversible.';
  }

  @override
  String deleteSelectedEnvelopesDescription(int count) {
    return 'Supprimer les $count enveloppes sélectionnées ? Les fonds restants retournent aux portefeuilles. L’historique est conservé.';
  }

  @override
  String get defaultWalletCannotDelete =>
      'Le portefeuille par défaut ne peut pas être supprimé. Choisissez d’abord un autre portefeuille par défaut.';

  @override
  String get envelopeUnavailable =>
      'Une enveloppe sélectionnée n’est plus disponible. Actualisez la liste.';

  @override
  String get operationInProgress =>
      'Veuillez attendre la fin de l’opération en cours.';

  @override
  String get dailyReminderNotificationTitle => 'Rappel quotidien';

  @override
  String get dailyReminderNotificationBody =>
      'Pensez à saisir vos dépenses ou revenus aujourd’hui.';

  @override
  String get categoryNameRequired => 'Saisissez un nom de catégorie.';

  @override
  String get envelopeNameRequired => 'Saisissez un nom d’enveloppe.';

  @override
  String get envelopeCategoryRequired =>
      'Choisissez une catégorie pour cette enveloppe.';

  @override
  String get fieldRequired => 'Ce champ est obligatoire.';

  @override
  String get positiveAmountRequired => 'Saisissez un montant supérieur à zéro.';

  @override
  String get nonNegativeAmountRequired =>
      'Saisissez un solde supérieur ou égal à zéro.';

  @override
  String get envelopeFundingWalletFixed =>
      'Une enveloppe existante conserve son portefeuille de financement d’origine.';

  @override
  String get envelopeFundingWalletUnavailable =>
      'Portefeuille de financement indisponible';

  @override
  String get home => 'Accueil';

  @override
  String get seeMore => 'Voir plus';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get envelopes => 'Enveloppes';

  @override
  String activityEmptyWithAction(String action) {
    return 'Une journée encore tranquille. $action pour commencer.';
  }

  @override
  String homeEmptyEnvelopeMessage(String action) {
    return 'Faites une place à vos projets avec votre $action.';
  }

  @override
  String get homeEmptyEnvelopeAction => 'première enveloppe';

  @override
  String homeEmptyTransactionMessage(String action) {
    return '$action pour commencer à suivre votre budget.';
  }

  @override
  String get homeEmptyTransactionAction => 'Ajouter une transaction';

  @override
  String get noRecentTransactions =>
      'Ajoutez une transaction pour commencer à suivre votre budget.';

  @override
  String get overviewLoadFailed => 'Actualisation impossible. Réessayer.';

  @override
  String get homeHello => 'Bonjour';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get networkUnavailable =>
      'Impossible de joindre le serveur. Vérifiez votre connexion internet et réessayez.';

  @override
  String get offlineModeToast =>
      'Connexion perdue. Le mode hors ligne est activé. Vos modifications seront synchronisées au retour de la connexion.';

  @override
  String get onlineModeToast =>
      'Connexion rétablie. Vos modifications sont synchronisées.';

  @override
  String get onlinePendingToast =>
      'Connexion rétablie. Certaines modifications nécessitent votre attention.';

  @override
  String get offlineStatus =>
      'Hors ligne · modifications enregistrées sur cet appareil';

  @override
  String get syncingStatus => 'Synchronisation de vos modifications…';

  @override
  String pendingStatus(int count) {
    return '$count modifications en attente de synchronisation';
  }

  @override
  String get offlineInitial =>
      'Connectez-vous pour télécharger vos données et les utiliser hors ligne.';

  @override
  String get offlineSetupUnavailable =>
      'Synchronisation indisponible. Vos modifications locales sont conservées sur cet appareil.';

  @override
  String get syncConflictTitle =>
      'Vérifier les modifications avant la synchronisation';

  @override
  String get syncConflictMessage =>
      'Vos données en ligne ont changé pendant votre absence. Vérifiez vos modifications avant de réessayer ou utilisez la version en ligne.';

  @override
  String get offlineRetry => 'Réessayer';

  @override
  String get offlineReview => 'Vérifier';

  @override
  String get offlineKeepCloud => 'Utiliser les données en ligne';

  @override
  String get offlineRetryChanges => 'Synchroniser ces modifications';

  @override
  String get offlineDiscardTitle =>
      'Supprimer les modifications de cet appareil ?';

  @override
  String get offlineDiscardBody =>
      'Ces modifications ne sont pas encore en ligne. Elles seront supprimées de cet appareil et remplacées par la version en ligne.';

  @override
  String get onlineRequired => 'Cette action nécessite une connexion internet.';

  @override
  String get signInSyncRequired =>
      'Reconnectez-vous pour synchroniser. Vos modifications locales sont conservées.';

  @override
  String get categoryIconFood => 'Repas et boissons';

  @override
  String get categoryIconShopping => 'Courses';

  @override
  String get categoryIconTransport => 'Transport';

  @override
  String get categoryIconHousing => 'Logement';

  @override
  String get categoryIconHealth => 'Santé';

  @override
  String get categoryIconUtilities => 'Charges';

  @override
  String get categoryIconEntertainment => 'Divertissement';

  @override
  String get categoryIconEducation => 'Éducation';

  @override
  String get categoryIconSalary => 'Salaire';

  @override
  String get categoryIconFreelance => 'Travail indépendant';

  @override
  String get categoryIconIncome => 'Revenus';

  @override
  String get categoryIconOther => 'Autre';

  @override
  String get categoryIconCoffee => 'Café';

  @override
  String get categoryIconDining => 'Restaurants';

  @override
  String get categoryIconTravel => 'Voyages';

  @override
  String get categoryIconGifts => 'Cadeaux';

  @override
  String get categoryIconPets => 'Animaux';

  @override
  String get categoryIconFamily => 'Famille';

  @override
  String get categoryIconSubscriptions => 'Abonnements';

  @override
  String get categoryIconPhone => 'Téléphone';

  @override
  String get categoryIconInternet => 'Internet';

  @override
  String get categoryIconSavings => 'Épargne';

  @override
  String get categoryIconInvestment => 'Investissements';

  @override
  String get categoryIconInsurance => 'Assurance';

  @override
  String get categoryIconTaxes => 'Impôts';

  @override
  String get categoryIconFitness => 'Sport';

  @override
  String get categoryIconBeauty => 'Soins personnels';

  @override
  String get categoryIconClothing => 'Vêtements';

  @override
  String get categoryIconRepairs => 'Réparations';

  @override
  String get categoryIconFuel => 'Carburant';

  @override
  String get categoryIconBicycle => 'Vélo';

  @override
  String get categoryIconBus => 'Transports en commun';

  @override
  String get categoryIconRain => 'Fonds d’urgence';

  @override
  String get categoryIconCharity => 'Dons';

  @override
  String get categoryIconMusic => 'Musique';

  @override
  String get categoryIconBooks => 'Livres';

  @override
  String get categoryIconTransfer => 'Virements';

  @override
  String get chooseCategoryIcon => 'Choisir une icône';

  @override
  String get searchCategoryIcons => 'Rechercher une icône';

  @override
  String get activitiesComposerHint => 'Dis-moi ce que tu as dépensé…';

  @override
  String get createEnvelope => 'Créer une enveloppe';

  @override
  String get trackYourBudget => 'Suivre mon budget';

  @override
  String get emptyCategories => 'Faites une place à ce qui compte pour vous.';

  @override
  String get emptyWallets => 'Votre argent aussi mérite un petit chez-soi.';

  @override
  String get createCategory => 'Créer une catégorie';

  @override
  String get emptyExpenses =>
      'Un petit pas pour mieux gérer votre budget : ajoutez votre première dépense.';

  @override
  String get emptyIncomes =>
      'Chaque revenu ouvre de nouvelles possibilités. Ajoutez le vôtre !';

  @override
  String get emptySearch =>
      'Essayons une autre recherche pour trouver ce que vous cherchez.';

  @override
  String get createExpense => 'Ajouter une dépense';

  @override
  String get createIncome => 'Ajouter un revenu';

  @override
  String get resetSearch => 'Réinitialiser la recherche';

  @override
  String get emptyBudgets =>
      'Donnez une direction à vos dépenses avec votre premier budget.';

  @override
  String get emptyGoals =>
      'Les grands projets commencent par un peu d’épargne. Quel est le vôtre ?';

  @override
  String get createBudget => 'Créer un budget';

  @override
  String get createGoal => 'Créer un objectif';

  @override
  String get manageNotifications => 'Gérer les notifications';

  @override
  String get envelopeRemaining => 'Restant';

  @override
  String get envelopeBudgetOf => 'sur';

  @override
  String get statsNet => 'Net';

  @override
  String get statsNetDescription => 'Revenus moins dépenses';

  @override
  String get statsNumbers => 'Les chiffres';

  @override
  String get statsCategories => 'Les catégories';

  @override
  String get statsOnAverage => 'en moyenne';

  @override
  String get statsPreviousMonth => 'vs le mois dernier';

  @override
  String get statsEmptyCategories =>
      'Ajoutez une dépense pour voir sa répartition par catégorie.';

  @override
  String statsActivityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activités',
      one: '1 activité',
    );
    return '$_temp0';
  }

  @override
  String get chooseCategoryColor => 'Choisir une couleur';

  @override
  String get settingsGuestSyncPrompt =>
      'Connectez-vous pour synchroniser votre budget.';

  @override
  String get dailyAiCreditsExhausted =>
      'Vos crédits IA du jour sont épuisés. Ils reviennent demain.';

  @override
  String get logOutConfirmation => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get offlineBannerMessage => 'Vous êtes actuellement hors ligne';

  @override
  String get dismissOfflineBanner => 'Fermer';

  @override
  String get entryAdded => 'Opération ajoutée.';

  @override
  String get entryUpdated => 'Opération modifiée.';

  @override
  String get entryDeleted => 'Opération supprimée.';

  @override
  String aiEntriesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations ajoutées.',
      one: '1 opération ajoutée.',
    );
    return '$_temp0';
  }

  @override
  String get insufficientFundsAllWallets =>
      'Fonds insuffisants dans l’ensemble de vos portefeuilles.';

  @override
  String get transactionNotCompletedInsufficientFunds =>
      'Fonds insuffisants. L’opération n’a pas été effectuée.';

  @override
  String get aiPaidTierNotice =>
      'Cette requête a utilisé une offre IA payante.';

  @override
  String get receiptImportedReady => 'Fichier importé, prêt pour l’analyse IA.';

  @override
  String get receiptScannedReady => 'Reçu scanné, prêt pour l’analyse IA.';

  @override
  String get savingsCategoryLocked =>
      'Cette catégorie est utilisée pour vos objectifs d’épargne et ne peut pas être modifiée.';

  @override
  String get plusCheckoutUnavailable =>
      'L’abonnement à Drala Plus sera disponible une fois la facturation configurée.';

  @override
  String get genericError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get serverError =>
      'Une erreur serveur est survenue. Veuillez réessayer.';

  @override
  String get signInToContinue => 'Veuillez vous connecter pour continuer.';

  @override
  String get invalidCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get emailNotConfirmed =>
      'Veuillez confirmer votre email avant de vous connecter.';

  @override
  String get accountNotFound => 'Aucun compte trouvé pour cet email.';

  @override
  String get emailAlreadyUsed => 'Cet email est déjà utilisé.';

  @override
  String get emailPasswordRequired =>
      'Veuillez renseigner l’email et le mot de passe.';

  @override
  String get weakPassword => 'Le mot de passe est trop faible.';

  @override
  String get checkRequiredFields => 'Veuillez vérifier les champs requis.';

  @override
  String get duplicateEntry => 'Une entrée identique existe déjà.';

  @override
  String get accessDenied => 'Accès refusé. Veuillez réessayer.';

  @override
  String get fileNotFound => 'Fichier introuvable.';

  @override
  String get fileProcessingFailed =>
      'Impossible de traiter le fichier. Veuillez réessayer.';

  @override
  String get noCameraAvailable =>
      'Aucun appareil photo n’est disponible sur cet appareil.';

  @override
  String get receiptFileTooLarge =>
      'Chaque fichier de reçu doit faire moins de 15 Mo.';

  @override
  String get receiptFormatUnsupported =>
      'Seuls les reçus JPG, PNG et PDF sont acceptés.';

  @override
  String get receiptScanningUnavailable =>
      'La numérisation des reçus n’est pas disponible.';

  @override
  String get receiptUnreadable => 'Ce reçu est illisible.';

  @override
  String get receiptTooLarge =>
      'Ce reçu est trop volumineux. Utilisez moins de pages ou des pages plus légères.';

  @override
  String get receiptPdfUnsupported =>
      'Les reçus PDF ne peuvent pas être lus pour le moment. Scannez ou importez plutôt des images.';

  @override
  String get receiptNotFound => 'Reçu introuvable.';

  @override
  String get aiDailyLimitReached =>
      'Vous avez utilisé tous vos crédits IA du jour. Réessayez demain.';

  @override
  String get aiRateLimited =>
      'Trop de requêtes. Patientez quelques secondes puis réessayez.';

  @override
  String get aiUnreadableResponse =>
      'L’IA n’a pas compris. Essayez de reformuler.';

  @override
  String get aiServiceUnavailable =>
      'Le service IA est indisponible pour le moment. Veuillez réessayer plus tard.';

  @override
  String get futureDateNotAllowed =>
      'Impossible d’ajouter une opération à une date future.';

  @override
  String get invalidEntryRequest =>
      'Saisissez un message et une date d’opération valides.';

  @override
  String get amountOutOfRange =>
      'Ce montant est trop petit ou trop grand pour être enregistré.';

  @override
  String get exchangeRateUnavailable =>
      'Les taux de change sont indisponibles pour le moment. Veuillez réessayer plus tard.';
}

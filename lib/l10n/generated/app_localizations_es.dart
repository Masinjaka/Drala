// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String envelopeOverBy(String amount) {
    return 'Exceso de $amount';
  }

  @override
  String get appTitle => 'Drala';

  @override
  String get settings => 'Ajustes';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get preferences => 'Preferencias';

  @override
  String get notification => 'Notificación';

  @override
  String get currency => 'Moneda';

  @override
  String get setDefaultWallet => 'Establecer cartera predeterminada';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get scannedReceipts => 'Recibos escaneados';

  @override
  String get legal => 'Información legal';

  @override
  String get termsOfService => 'Condiciones de servicio';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get adPrivacyOptions => 'Opciones de privacidad de anuncios';

  @override
  String get legalConsentPrefix => 'Acepto los ';

  @override
  String get legalConsentConnector => ' y la ';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String appVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get malagasy => 'Malgache';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get italian => 'Italiano';

  @override
  String get menu => 'Menú';

  @override
  String get collapseMenu => 'Contraer menú';

  @override
  String get expandMenu => 'Expandir menú';

  @override
  String get envelope => 'Sobre';

  @override
  String get stats => 'Estadísticas';

  @override
  String get feedback => 'Comentarios';

  @override
  String get resumeFromDate => 'Reanudar desde una fecha específica';

  @override
  String get wallets => 'Carteras';

  @override
  String get addWallet => 'Añadir cartera';

  @override
  String get walletNameLabel => 'Nombre de la cartera';

  @override
  String get walletNameHint => 'p. ej., Ahorros';

  @override
  String get currentBalanceLabel => 'Saldo actual';

  @override
  String get editWallet => 'Editar cartera';

  @override
  String get deleteWallet => 'Eliminar cartera';

  @override
  String get deleteWalletQuestion => '¿Eliminar esta cartera?';

  @override
  String get deleteWalletDescription =>
      'Esta cartera se eliminará permanentemente. Su historial de transacciones permanecerá intacto.';

  @override
  String get walletUpdated => 'Cartera actualizada.';

  @override
  String get walletDeleted => 'Cartera eliminada.';

  @override
  String get walletInUseCannotBeDeleted =>
      'Esta cartera tiene un historial de transacciones y no se puede eliminar.';

  @override
  String get allTime => 'Todo el período';

  @override
  String get showBalance => 'Mostrar saldo';

  @override
  String get hideBalance => 'Ocultar saldo';

  @override
  String get overallBalance => 'Saldo restante en carteras';

  @override
  String takenFromEnvelope(String name) {
    return 'Tomado del sobre $name';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'No hay notificaciones';

  @override
  String get noNotificationsDescription =>
      'Las alertas de presupuesto y otras novedades financieras importantes aparecerán aquí.';

  @override
  String envelopeBudgetExceeded(String name) {
    return 'Has superado el presupuesto del sobre $name.';
  }

  @override
  String envelopeBudgetAlmostReached(String name) {
    return 'El presupuesto del sobre $name está casi agotado.';
  }

  @override
  String envelopeBudgetReached(String name) {
    return 'Se ha alcanzado el presupuesto del sobre $name.';
  }

  @override
  String todayWithDate(Object date) {
    return 'Hoy, $date';
  }

  @override
  String get noEntriesForDate => 'No hay entradas para esta fecha';

  @override
  String get emptyStateWelcomeBack => '¡Te damos la bienvenida de nuevo!';

  @override
  String get emptyStateWelcomeTo => 'Te damos la bienvenida a';

  @override
  String get emptyStateIncomePrompt =>
      '¿Acabas de recibir dinero? Cuéntamelo para celebrarlo… y registrarlo.';

  @override
  String get emptyStateExpensePrompt =>
      '¿Has gastado algo? Dime cuánto y en qué… yo llevo las cuentas.';

  @override
  String get emptyStateTransferPrompt =>
      '¿Quieres mover dinero? Dime de dónde a dónde y lo haré.';

  @override
  String get firstEntryIncomePrompt =>
      'Empieza con un ingreso o un gasto. Escribe «Cobré xxx» o «Gasté xxx en comida» y lo registraré.';

  @override
  String entryCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '1 entrada',
    );
    return '$_temp0';
  }

  @override
  String expenseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos',
      one: '1 gasto',
    );
    return '$_temp0';
  }

  @override
  String incomeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingresos',
      one: '1 ingreso',
    );
    return '$_temp0';
  }

  @override
  String transferCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferencias',
      one: '1 transferencia',
    );
    return '$_temp0';
  }

  @override
  String get unlimitedAiRequests =>
      'Solicitudes de IA ilimitadas con Drala Plus';

  @override
  String aiRequestsRemaining(Object count) {
    return 'Te quedan $count solicitudes de IA hoy';
  }

  @override
  String get chatHint => 'Tus gastos…';

  @override
  String get startTyping => 'Empieza a escribir…';

  @override
  String get chatIncomeHint => 'Tus ingresos…';

  @override
  String get chatTransferHint => 'Transferir entre carteras…';

  @override
  String expenseSuggestion(Object amount) {
    return 'Gasté $amount en hamburguesas';
  }

  @override
  String incomeSuggestion(Object amount) {
    return 'Recibí $amount de mi sueldo';
  }

  @override
  String transferSuggestion(Object amount) {
    return 'Transfiere $amount de Efectivo a Ahorros';
  }

  @override
  String get addReceipt => 'Añadir recibo';

  @override
  String get manualEntry => 'Entrada manual';

  @override
  String get send => 'Enviar';

  @override
  String get enterManually => 'Introducir manualmente';

  @override
  String get importFile => 'Importar archivo';

  @override
  String get scanReceipt => 'Escanear recibo';

  @override
  String get receiptGalleryEmpty =>
      'Tus recibos escaneados e importados aparecerán aquí.';

  @override
  String get deleteReceiptQuestion => '¿Eliminar recibo?';

  @override
  String get deleteReceiptDescription =>
      'Esto eliminará todas las páginas de este recibo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get receiptDeleted => 'Recibo eliminado.';

  @override
  String get receipt => 'Recibo';

  @override
  String receiptPages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas de recibo',
      one: '1 página de recibo',
    );
    return '$_temp0';
  }

  @override
  String pageCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String get deleteReceipt => 'Eliminar recibo';

  @override
  String get save => 'Guardar';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get enterUsername => 'Introduce tu nombre de usuario';

  @override
  String get user => 'Usuario';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get enterCurrentPassword => 'Introduce tu contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get enterNewPassword => 'Introduce tu nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmNewPassword => 'Confirma tu nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las nuevas contraseñas no coinciden.';

  @override
  String get passwordMustDiffer =>
      'Elige una contraseña distinta de la actual.';

  @override
  String get passwordUpdated => 'Contraseña actualizada.';

  @override
  String get searchCurrency => 'Buscar una moneda';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get defaultWalletDescription =>
      'Los gastos y los sobres nuevos usan esta cartera de forma predeterminada.';

  @override
  String get defaultWalletUpdated => 'Cartera predeterminada actualizada.';

  @override
  String get termsIntro =>
      'Estas condiciones explican las reglas de uso de Drala.';

  @override
  String get termsDetails =>
      'Usa Drala solo para gestionar tus finanzas personales de forma legal. Eres responsable de revisar las entradas creadas por la IA antes de confiar en ellas. La disponibilidad del servicio puede cambiar a medida que evoluciona la aplicación.';

  @override
  String get privacyIntro => 'Tu información financiera te pertenece.';

  @override
  String get privacyDetails =>
      'Drala almacena datos de cuenta y transacciones para proporcionar la aplicación. Los recibos escaneados se guardan en un almacenamiento privado por usuario y se envían al proveedor de IA configurado a través del servidor para su extracción. Puedes eliminar recibos individuales desde Recibos escaneados, o eliminar todos los datos almacenados o tu cuenta completa desde Editar perfil.';

  @override
  String get legalLastUpdated => 'Última actualización: 21 de julio de 2026';

  @override
  String get allowNotifications => 'Permitir notificaciones';

  @override
  String get dailyReminders => 'Recordatorios diarios';

  @override
  String get budgetAlerts => 'Alertas de presupuesto';

  @override
  String get selectReminderTime => 'Seleccionar hora del recordatorio';

  @override
  String get preferredReminderTime => 'Hora preferida del recordatorio';

  @override
  String get reminderDeliveryTime => 'Hora de envío del recordatorio diario';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get notificationPermissionMessage =>
      'Permite las notificaciones para recibir recordatorios diarios y alertas de presupuesto.';

  @override
  String get allow => 'Permitir';

  @override
  String get deny => 'Denegar';

  @override
  String get notificationsBlocked => 'Notificaciones bloqueadas';

  @override
  String get notificationsBlockedMessage =>
      'Permite las notificaciones en los ajustes del dispositivo para recibir recordatorios y alertas.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get dangerZone => 'Zona de peligro';

  @override
  String get deleteAllData => 'Eliminar todos mis datos';

  @override
  String get deleteAllDataSummary =>
      'Elimina permanentemente todo el contenido de la aplicación.';

  @override
  String get deleteAccount => 'Eliminar mi cuenta';

  @override
  String get deleteAccountSummary =>
      'Elimina tus datos e inhabilita el inicio de sesión.';

  @override
  String get deleteAllDataQuestion => '¿Eliminar todos los datos?';

  @override
  String get deleteAllDataDetails =>
      'Se eliminarán transacciones, carteras, sobres, presupuestos, objetivos, historial de IA, preferencias y archivos. Tu cuenta y tu plan se conservarán.';

  @override
  String get deleteKeyword => 'DELETE';

  @override
  String get typeDeleteToConfirm => 'Escribe DELETE para confirmar.';

  @override
  String get allDataDeleted => 'Se han eliminado todos tus datos.';

  @override
  String get deleteAccountQuestion => '¿Eliminar la cuenta permanentemente?';

  @override
  String get deleteAccountDetails =>
      'Esto elimina tu cuenta, plan, archivos y todos tus datos. No se puede deshacer.';

  @override
  String typeValueToConfirm(Object value) {
    return 'Escribe $value para confirmar.';
  }

  @override
  String get accountDeleted => 'Tu cuenta se ha eliminado.';

  @override
  String get confirmation => 'Confirmación';

  @override
  String get chooseSource => 'Elegir una fuente';

  @override
  String get fromGallery => 'Desde la galería';

  @override
  String get takePhoto => 'Hacer una foto';

  @override
  String get mediaPermissionMessage =>
      'Necesitamos acceso a la cámara y a los archivos para continuar.';

  @override
  String get cameraDenied => 'Acceso a la cámara denegado.';

  @override
  String get mediaDenied => 'Acceso a los archivos denegado.';

  @override
  String get imageSelectionFailed => 'No se pudo seleccionar la imagen.';

  @override
  String get usernameUpdateFailed =>
      'No se pudo actualizar el nombre de usuario.';

  @override
  String get profilePhotoUploadFailed => 'No se pudo subir la foto de perfil.';

  @override
  String get back => 'Volver';

  @override
  String get enterEmail => 'Introduce una dirección de correo';

  @override
  String get invalidEmail => 'Introduce una dirección de correo válida';

  @override
  String get enterPassword => 'Introduce una contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get passwordNeedsUppercase =>
      'La contraseña debe contener al menos una letra mayúscula.';

  @override
  String get passwordNeedsLowercase =>
      'La contraseña debe contener al menos una letra minúscula.';

  @override
  String get passwordNeedsNumber =>
      'La contraseña debe contener al menos un número.';

  @override
  String get passwordNeedsSpecialCharacter =>
      'La contraseña debe contener al menos un carácter especial.';

  @override
  String get passwordRuleMinLength => 'Más de 8 caracteres';

  @override
  String get passwordRuleUppercase => 'Al menos una letra mayúscula';

  @override
  String get passwordRuleLowercase => 'Al menos una letra minúscula';

  @override
  String get passwordRuleNumber => 'Al menos un número';

  @override
  String get passwordRuleSpecialCharacter => 'Al menos un carácter especial';

  @override
  String get netThisMonth => 'Neto de este mes';

  @override
  String get transactions => 'Transacciones';

  @override
  String get homeWelcome => 'Bienvenido';

  @override
  String get averagePerDay => 'Promedio por día';

  @override
  String get expenses => 'Gastos';

  @override
  String get income => 'Ingresos';

  @override
  String get largestExpense => 'Gasto más alto';

  @override
  String get dailySpending => 'Gasto diario';

  @override
  String get topSpending => 'Mayores gastos';

  @override
  String get noExpensesThisMonth => 'No hay gastos este mes';

  @override
  String moreThanLastMonth(String percentage) {
    return '$percentage % más que el mes pasado';
  }

  @override
  String lessThanLastMonth(String percentage) {
    return '$percentage % menos que el mes pasado';
  }

  @override
  String get addEnvelope => 'Añadir sobre';

  @override
  String get createExpenseCategoryFirst =>
      'Crea una categoría de gastos antes de añadir otro sobre.';

  @override
  String get monthlyEnvelopes => 'Sobres mensuales';

  @override
  String get availableAcrossEnvelopes => 'Disponible en sobres';

  @override
  String get budget => 'Presupuesto';

  @override
  String get spent => 'Gastado';

  @override
  String get newEnvelope => 'Nuevo sobre';

  @override
  String get name => 'Nombre';

  @override
  String get envelopeNameHint => 'p. ej., Comestibles';

  @override
  String get monthlyAmount => 'Importe mensual';

  @override
  String get expenseCategory => 'Categoría de gastos';

  @override
  String get saving => 'Guardando…';

  @override
  String get create => 'Crear';

  @override
  String get noEnvelopesYet => 'Todavía no hay sobres';

  @override
  String get envelopeEmptyDescription =>
      'Establece un importe mensual para una categoría de gastos. Los gastos del chat lo actualizarán automáticamente.';

  @override
  String get deleteEnvelope => 'Eliminar sobre';

  @override
  String overBudgetBy(String amount) {
    return 'Presupuesto superado en $amount';
  }

  @override
  String amountSpent(String amount) {
    return '$amount gastados';
  }

  @override
  String ofAmount(String amount) {
    return 'de $amount';
  }

  @override
  String get feedbackPrompt => 'Cuéntanos qué opinas';

  @override
  String get feedbackHint => 'Describe un problema o comparte una idea';

  @override
  String get feedbackRequired => 'Introduce tus comentarios';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get feedbackSent => 'Comentarios enviados. ¡Gracias!';

  @override
  String get availableBalance => 'Saldo disponible';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get operations => 'Operaciones';

  @override
  String get categories => 'Categorías';

  @override
  String get deleteTransactionQuestion => '¿Eliminar transacción?';

  @override
  String get deleteTransactionDescription =>
      '¿Seguro que quieres eliminar esta transacción? Esta acción no se puede deshacer.';

  @override
  String get deleteBudgetQuestion => '¿Eliminar presupuesto?';

  @override
  String get deleteBudgetDescription =>
      '¿Seguro que quieres eliminar este presupuesto? Esta acción no se puede deshacer.';

  @override
  String get deleteGoalQuestion => '¿Eliminar objetivo?';

  @override
  String get deleteGoalDescription =>
      '¿Seguro que quieres eliminar este objetivo? Esta acción no se puede deshacer.';

  @override
  String get deleteCategoryQuestion => '¿Eliminar categoría?';

  @override
  String get deleteCategoryDescription =>
      '¿Seguro que quieres eliminar esta categoría? Esta acción no se puede deshacer.';

  @override
  String get editTransaction => 'Editar transacción';

  @override
  String get expense => 'Gasto';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descripción';

  @override
  String get searchCategories => 'Buscar una categoría';

  @override
  String get done => 'Listo';

  @override
  String get repeatEnvelopeMonthly => 'Repetir mensualmente';

  @override
  String get repeatEnvelopeMonthlyHelp =>
      'Financia un presupuesto nuevo desde la misma cartera cada mes cuando haya fondos disponibles.';

  @override
  String get editEnvelope => 'Editar sobre';

  @override
  String get aiRequestTimedOut =>
      'La solicitud de IA tardó demasiado. Inténtalo de nuevo.';

  @override
  String get setupLanguageTitle => 'Tu idioma';

  @override
  String get setupLanguageBody => 'Elige el idioma de Drala.';

  @override
  String get setupCurrencyTitle => 'Tu moneda';

  @override
  String get setupCurrencyBody => 'Elige cómo se muestran los importes.';

  @override
  String get setupCategoriesTitle => 'Tus categorías';

  @override
  String get setupCategoriesBody =>
      'Elige las categorías que necesitas. Podrás añadir más después.';

  @override
  String get setupWalletsTitle => 'Tus carteras';

  @override
  String get setupWalletsBody =>
      'Separa tu dinero según su uso. La cartera principal siempre está incluida.';

  @override
  String get setupContinue => 'Continuar';

  @override
  String get setupFinish => 'Empezar';

  @override
  String get setupCompleteTitle => '¡Todo listo!';

  @override
  String get setupCompleteBody => 'Feliz gestión';

  @override
  String get setupDone => 'Genial';

  @override
  String get setupRetry => 'Reintentar';

  @override
  String get setupMainWallet => 'Cartera principal';

  @override
  String get setupCash => 'Efectivo';

  @override
  String get setupBank => 'Cuenta bancaria';

  @override
  String get setupMobile => 'Dinero móvil';

  @override
  String get authSignUp => 'Crear una cuenta';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUpBody => 'Unos datos y Drala estará a tu medida.';

  @override
  String get authSignInBody => 'Encuentra tus cuentas y gastos.';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authForgotPassword => '¿Olvidaste la contraseña?';

  @override
  String get authConfirmEmail =>
      'Confirma tu cuenta por correo y luego inicia sesión para terminar la configuración.';

  @override
  String get setupLoadError =>
      'No se pudieron cargar las opciones. Inténtalo de nuevo.';

  @override
  String get authResetInstruction =>
      'Introduce tu correo para recibir un código de verificación.';

  @override
  String get authResetCodeSent => 'Código de verificación enviado';

  @override
  String get authCodeSentTo => 'Se envió un código a';

  @override
  String get authVerificationCode => 'Código de verificación';

  @override
  String get authEnterSixDigitCode => 'Introduce el código de 6 dígitos';

  @override
  String get authResetButton => 'Restablecer contraseña';

  @override
  String get authResetSuccess => 'Contraseña restablecida';
}

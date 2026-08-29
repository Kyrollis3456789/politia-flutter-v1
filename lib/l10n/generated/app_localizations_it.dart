// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get copticOrthodox => 'COPTA ORTODOSSA';

  @override
  String get welcomeMessage => 'Benvenuto in Politia';

  @override
  String get statusRunning => 'Motore della piattaforma operativo';

  @override
  String get changeLanguage => 'Cambia lingua';

  @override
  String get selectLanguage => 'SELEZIONA LINGUA';

  @override
  String get welcome => 'BENVENUTO';

  @override
  String get welcomeBack => 'Bentornato';

  @override
  String get signIn => 'ACCEDI';

  @override
  String get signUp => 'REGISTRATI';

  @override
  String get signInDescription =>
      'Inserisci la tua email o il tuo numero di cellulare registrato per procedere.';

  @override
  String get helloSignIn => 'Ciao\nAccedi!';

  @override
  String get createYourAccount => 'Crea il tuo\naccount';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email o nome utente';

  @override
  String get phoneOrEmail => 'Telefono o Email';

  @override
  String get emailOrMobile => 'Email o numero di cellulare';

  @override
  String get emailOrMobileHint => 'webx@gmail.com o 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Operatori egiziani supportati: 010, 011, 012, 015';

  @override
  String get continueText => 'Continua';

  @override
  String get orDivider => 'O';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get continueWithFacebook => 'Continua con Facebook';

  @override
  String get continueWithApple => 'Continua with Apple';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get fullName => 'Nome e cognome';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get dontHaveAccount => 'Non hai un account?';

  @override
  String get alreadyHaveAccount => 'Hai già un account?';

  @override
  String get invalidEmail => 'Inserisci un\'email valida';

  @override
  String get passwordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono';

  @override
  String get nameRequired => 'Il nome e cognome è obbligatorio';

  @override
  String get back => 'Indietro';

  @override
  String get enterEmailOrPhone =>
      'Inserisci la tua email o il tuo numero di telefono';

  @override
  String get invalidIdentityError =>
      'Inserisci un\'email valida o un numero egiziano valido (010, 011, 012, 015)';

  @override
  String get userNotRegistered => 'Email o numero di telefono non registrati.';

  @override
  String get enterPassword => 'Inserisci la tua password';

  @override
  String get incorrectPassword => 'Password non corretta.';

  @override
  String attemptsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativi rimanenti.',
      one: '1 tentativo rimanente.',
    );
    return '$_temp0';
  }

  @override
  String get maxAttemptsOtp =>
      'Numero massimo di tentativi raggiunto (10/10). Codice di verifica (OTP) attivato.';

  @override
  String get enterOtpCode => 'Inserisci il codice di verifica (6 cifre)';

  @override
  String get enterFullOtp => 'Inserisci il codice OTP completo di 6 cifre';

  @override
  String otpSent(String identity) {
    return 'Codice di verifica inviato a $identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Reinvia codice tra ${seconds}s';
  }

  @override
  String get resendCode => 'Reinvia codice';

  @override
  String get switchAccount => 'Cambia account';

  @override
  String get verifyAndSignIn => 'Verifica e accedi';

  @override
  String get usePasswordInstead => 'Usa la password invece';

  @override
  String get contactAdminForgot =>
      'Contatta l\'amministratore per reimpostare la password o usa l\'OTP';

  @override
  String get registeredMember => 'Membro registrato';

  @override
  String comingSoon(String provider) {
    return 'Accesso con $provider presto disponibile';
  }

  @override
  String get verseText =>
      '\"Perché dove sono due o tre riuniti nel mio nome, lì sono io in mezzo a loro.\" — Matteo 18:20';
}

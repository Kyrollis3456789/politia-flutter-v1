// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get copticOrthodox => 'KOPTISCH ORTHODOX';

  @override
  String get welcomeMessage => 'Willkommen bei Politia';

  @override
  String get statusRunning => 'Plattform-Engine betriebsbereit';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get selectLanguage => 'SPRACHE WÄHLEN';

  @override
  String get welcome => 'WILLKOMMEN';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signIn => 'ANMELDEN';

  @override
  String get signUp => 'REGISTRIEREN';

  @override
  String get signInDescription =>
      'Geben Sie Ihre registrierte E-Mail oder Handynummer ein, um fortzufahren.';

  @override
  String get helloSignIn => 'Hallo\nAnmelden!';

  @override
  String get createYourAccount => 'Erstellen Sie Ihr\nKonto';

  @override
  String get email => 'E-Mail';

  @override
  String get emailOrUsername => 'E-Mail oder Benutzername';

  @override
  String get phoneOrEmail => 'Telefon oder E-Mail';

  @override
  String get emailOrMobile => 'E-Mail oder Handynummer';

  @override
  String get emailOrMobileHint => 'webx@gmail.com oder 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Unterstützte ägyptische Anbieter: 010, 011, 012, 015';

  @override
  String get continueText => 'Weiter';

  @override
  String get orDivider => 'ODER';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get continueWithFacebook => 'Mit Facebook fortfahren';

  @override
  String get continueWithApple => 'Mit Apple fortfahren';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get dontHaveAccount => 'Haben Sie noch kein Konto?';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto vorhanden?';

  @override
  String get invalidEmail => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get nameRequired => 'Vollständiger Name ist erforderlich';

  @override
  String get back => 'Zurück';

  @override
  String get enterEmailOrPhone =>
      'Bitte geben Sie Ihre E-Mail-Adresse oder Telefonnummer ein';

  @override
  String get invalidIdentityError =>
      'Bitte geben Sie eine gültige E-Mail oder ägyptische Nummer (010, 011, 012, 015) ein';

  @override
  String get userNotRegistered =>
      'E-Mail oder Telefonnummer nicht registriert.';

  @override
  String get enterPassword => 'Bitte Passwort eingeben';

  @override
  String get incorrectPassword => 'Falsches Passwort.';

  @override
  String attemptsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Versuche verbleibend.',
      one: '1 Versuch verbleibend.',
    );
    return '$_temp0';
  }

  @override
  String get maxAttemptsOtp =>
      'Maximale Anzahl an Passwortversuchen erreicht (10/10). Bestätigungscode (OTP) aktiviert.';

  @override
  String get enterOtpCode => 'Geben Sie den 6-stelligen Bestätigungscode ein';

  @override
  String get enterFullOtp =>
      'Bitte geben Sie den vollständigen 6-stelligen Code ein';

  @override
  String otpSent(String identity) {
    return 'Bestätigungscode an $identity gesendet';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Code erneut senden in ${seconds}s';
  }

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get switchAccount => 'Konto wechseln';

  @override
  String get verifyAndSignIn => 'Bestätigen & Anmelden';

  @override
  String get usePasswordInstead => 'Stattdessen Passwort verwenden';

  @override
  String get contactAdminForgot =>
      'Bitte kontaktieren Sie die Administration, um das Passwort zurückzusetzen oder OTP zu nutzen';

  @override
  String get registeredMember => 'Registriertes Mitglied';

  @override
  String comingSoon(String provider) {
    return 'Anmeldung mit $provider bald verfügbar';
  }

  @override
  String get verseText =>
      '\"Denn wo zwei oder drei versammelt sind in meinem Namen, da bin ich mitten unter ihnen.\" — Matthäus 18:20';
}

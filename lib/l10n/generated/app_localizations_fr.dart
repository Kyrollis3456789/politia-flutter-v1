// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get copticOrthodox => 'ORTHODOXE COPTE';

  @override
  String get welcomeMessage => 'Bienvenue sur Politia';

  @override
  String get statusRunning => 'Moteur de plateforme opérationnel';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get selectLanguage => 'CHOISIR LA LANGUE';

  @override
  String get welcome => 'BIENVENUE';

  @override
  String get welcomeBack => 'Bienvenue à nouveau';

  @override
  String get signIn => 'SE CONNECTER';

  @override
  String get signUp => 'S\'INSCRIRE';

  @override
  String get signInDescription =>
      'Entrez votre e-mail ou votre numéro de mobile enregistré pour continuer.';

  @override
  String get helloSignIn => 'Bonjour\nConnectez-vous!';

  @override
  String get createYourAccount => 'Créez votre\ncompte';

  @override
  String get email => 'E-mail';

  @override
  String get emailOrUsername => 'E-mail ou nom d\'utilisateur';

  @override
  String get phoneOrEmail => 'Téléphone ou E-mail';

  @override
  String get emailOrMobile => 'E-mail ou numéro de mobile';

  @override
  String get emailOrMobileHint => 'webx@gmail.com ou 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Opérateurs égyptiens pris en charge: 010, 011, 012, 015';

  @override
  String get continueText => 'Continuer';

  @override
  String get orDivider => 'OU';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithFacebook => 'Continuer avec Facebook';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmez le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get invalidEmail => 'Veuillez saisir un e-mail valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get nameRequired => 'Le nom complet est requis';

  @override
  String get back => 'Retour';

  @override
  String get enterEmailOrPhone =>
      'Veuillez entrer votre e-mail ou numéro de téléphone';

  @override
  String get invalidIdentityError =>
      'Veuillez entrer un e-mail valide ou un numéro égyptien (010, 011, 012, 015)';

  @override
  String get userNotRegistered =>
      'E-mail ou numéro de téléphone non enregistré.';

  @override
  String get enterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get incorrectPassword => 'Mot de passe incorrect.';

  @override
  String attemptsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentatives restantes.',
      one: '1 tentative restante.',
    );
    return '$_temp0';
  }

  @override
  String get maxAttemptsOtp =>
      'Nombre maximum de tentatives atteint (10/10). Code de vérification (OTP) activé.';

  @override
  String get enterOtpCode => 'Entrez le code de vérification (6 chiffres)';

  @override
  String get enterFullOtp => 'Veuillez entrer le code OTP complet à 6 chiffres';

  @override
  String otpSent(String identity) {
    return 'Code de vérification envoyé à $identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Renvoyer le code dans ${seconds}s';
  }

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get switchAccount => 'Changer de compte';

  @override
  String get verifyAndSignIn => 'Vérifier et se connecter';

  @override
  String get usePasswordInstead => 'Utiliser le mot de passe à la place';

  @override
  String get contactAdminForgot =>
      'Veuillez contacter l\'administrateur pour réinitialiser le mot de passe ou utiliser l\'OTP';

  @override
  String get registeredMember => 'Membre inscrit';

  @override
  String comingSoon(String provider) {
    return 'Connexion avec $provider bientôt disponible';
  }

  @override
  String get verseText =>
      '\"Car là où deux ou trois sont assemblés en mon nom, je suis au milieu d\'eux.\" — Matthieu 18:20';
}

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
  String get welcomeMessage => 'Bienvenue sur Politia';

  @override
  String get statusRunning => 'Moteur de plateforme opérationnel';

  @override
  String get changeLanguage => 'Langue';

  @override
  String get welcomeBack => 'Bienvenue à nouveau';

  @override
  String get signIn => 'SE CONNECTER';

  @override
  String get signUp => 'S\'INSCRIRE';

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
}

/// The translations for French, as used in France (`fr_FR`).
class AppLocalizationsFrFr extends AppLocalizationsFr {
  AppLocalizationsFrFr() : super('fr_FR');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Bienvenue sur Politia (France)';

  @override
  String get statusRunning => 'Moteur de plateforme opérationnel (France)';

  @override
  String get changeLanguage => 'Langue';

  @override
  String get welcomeBack => 'Bienvenue à nouveau';

  @override
  String get signIn => 'SE CONNECTER';

  @override
  String get signUp => 'S\'INSCRIRE';

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
}

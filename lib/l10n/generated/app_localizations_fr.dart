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
  String get statusRunning =>
      'Moteur de plateforme et localisation opérationnels';

  @override
  String get changeLanguage => 'Langue';
}

/// The translations for French, as used in France (`fr_FR`).
class AppLocalizationsFrFr extends AppLocalizationsFr {
  AppLocalizationsFrFr() : super('fr_FR');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Bienvenue sur Politia (France)';

  @override
  String get statusRunning =>
      'Moteur de plateforme et localisation opérationnels';

  @override
  String get changeLanguage => 'Langue';
}

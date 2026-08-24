// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Welcome to Politia';

  @override
  String get statusRunning => 'Platform Engine & Localization Operational';

  @override
  String get changeLanguage => 'Language';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Welcome to Politia (UK)';

  @override
  String get statusRunning => 'Platform Engine & Localization Operational';

  @override
  String get changeLanguage => 'Language';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Welcome to Politia (US)';

  @override
  String get statusRunning => 'Platform Engine & Localization Operational';

  @override
  String get changeLanguage => 'Language';
}

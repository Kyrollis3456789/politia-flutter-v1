// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بوليتيا';

  @override
  String get welcomeMessage => 'مرحباً بك في بوليتيا';

  @override
  String get statusRunning => 'محرك المنصة والترجمة يعملان بنجاح';

  @override
  String get changeLanguage => 'اللغة';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

  @override
  String get appTitle => 'بوليتيا';

  @override
  String get welcomeMessage => 'أهلاً بك في بوليتيا (مصر)';

  @override
  String get statusRunning => 'محرك المنصة والترجمة يعملان بنجاح';

  @override
  String get changeLanguage => 'اللغة';
}

/// The translations for Arabic, as used in Saudi Arabia (`ar_SA`).
class AppLocalizationsArSa extends AppLocalizationsAr {
  AppLocalizationsArSa() : super('ar_SA');

  @override
  String get appTitle => 'بوليتيا';

  @override
  String get welcomeMessage => 'مرحباً بكم في بوليتيا (السعودية)';

  @override
  String get statusRunning => 'محرك المنصة والترجمة يعملان بنجاح';

  @override
  String get changeLanguage => 'اللغة';
}

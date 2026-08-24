// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Coptic (`cop`).
class AppLocalizationsCop extends AppLocalizations {
  AppLocalizationsCop([String locale = 'cop']) : super(locale);

  @override
  String get appTitle => 'Ⲡⲟⲗⲓⲧⲓⲁ';

  @override
  String get welcomeMessage => 'Ⲁⲙⲱⲓⲛⲓ ⲉ̀Ⲡⲟⲗⲓⲧⲓⲁ';

  @override
  String get statusRunning => 'Ⲡⲓⲙⲏⲭⲁⲛⲏ ⲛⲉⲙ ϯⲙⲉⲧⲟⲩⲁⲓ ⲥⲉⲉⲣϩⲱⲃ';

  @override
  String get changeLanguage => 'Ϯⲁⲥⲡⲓ';
}

/// The translations for Coptic, as used in Egypt (`cop_EG`).
class AppLocalizationsCopEg extends AppLocalizationsCop {
  AppLocalizationsCopEg() : super('cop_EG');

  @override
  String get appTitle => 'Ⲡⲟⲗⲓⲧⲓⲁ';

  @override
  String get welcomeMessage => 'Ⲁⲙⲱⲓⲛⲓ ⲉ̀Ⲡⲟⲗⲓⲧⲓⲁ (Ⲭⲏⲙⲓ)';

  @override
  String get statusRunning => 'Ⲡⲓⲙⲏⲭⲁⲛⲏ ⲛⲉⲙ ϯⲙⲉⲧⲟⲩⲁⲓ ⲥⲉⲉⲣϩⲱⲃ';

  @override
  String get changeLanguage => 'Ϯⲁⲥⲡⲓ';
}

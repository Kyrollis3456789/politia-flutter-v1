// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Coptic (`cop`).
class AppLocalizationsCop extends AppLocalizations {
  AppLocalizationsCop([String locale = 'cop']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Ⲛⲟϥⲣⲓ ϧⲉⲛ Politia';

  @override
  String get statusRunning => 'Platform Engine Operational';

  @override
  String get changeLanguage => 'Ϯⲁⲥⲡⲓ';

  @override
  String get welcomeBack => 'Ⲛⲟϥⲣⲓ ⲟⲛ';

  @override
  String get signIn => 'Ϣⲉ ⲉϧⲟⲩⲛ';

  @override
  String get signUp => 'Ⲑⲁⲙⲓⲟ ⲛ̀ⲟⲩϩⲩⲡⲟⲧⲁⲥⲓⲥ';

  @override
  String get helloSignIn => 'Ⲛⲟϥⲣⲓ\nϢⲉ ⲉϧⲟⲩⲛ!';

  @override
  String get createYourAccount => 'Ⲑⲁⲙⲓⲟ\nⲛ̀ⲧⲉⲕϩⲩⲡⲟⲧⲁⲥⲓⲥ';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email / Ⲣⲁⲛ';

  @override
  String get phoneOrEmail => 'Phone / Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Ⲣⲁⲛ ⲧⲏⲣϥ';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';
}

/// The translations for Coptic, as used in Egypt (`cop_EG`).
class AppLocalizationsCopEg extends AppLocalizationsCop {
  AppLocalizationsCopEg() : super('cop_EG');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Ⲛⲟϥⲣⲓ ϧⲉⲛ Politia (Ⲭⲏⲙⲓ)';

  @override
  String get statusRunning => 'Platform Engine Operational (Ⲭⲏⲙⲓ)';

  @override
  String get changeLanguage => 'Ϯⲁⲥⲡⲓ';

  @override
  String get welcomeBack => 'Ⲛⲟϥⲣⲓ ⲟⲛ';

  @override
  String get signIn => 'Ϣⲉ ⲉϧⲟⲩⲛ';

  @override
  String get signUp => 'Ⲑⲁⲙⲓⲟ ⲛ̀ⲟⲩϩⲩⲡⲟⲧⲁⲥⲓⲥ';

  @override
  String get helloSignIn => 'Ⲛⲟϥⲣⲓ\nϢⲉ ⲉϧⲟⲩⲛ!';

  @override
  String get createYourAccount => 'Ⲑⲁⲙⲓⲟ\nⲛ̀ⲧⲉⲕϩⲩⲡⲟⲧⲁⲥⲓⲥ';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email / Ⲣⲁⲛ';

  @override
  String get phoneOrEmail => 'Phone / Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Ⲣⲁⲛ ⲧⲏⲣϥ';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';
}

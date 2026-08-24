// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Classical Syriac (`syc`).
class AppLocalizationsSyc extends AppLocalizations {
  AppLocalizationsSyc([String locale = 'syc']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'ܒܫܝܢܐ ܠ Politia';

  @override
  String get statusRunning => 'Platform Engine Operational';

  @override
  String get changeLanguage => 'ܠܫܢܐ';

  @override
  String get welcomeBack => 'ܒܫܝܢܐ ܡܢ ܪܝܫ';

  @override
  String get signIn => 'ܥܘܠ';

  @override
  String get signUp => 'ܥܒܕ ܚܘܫܒܢܐ';

  @override
  String get helloSignIn => 'ܫܠܡܐ\nܥܘܠ!';

  @override
  String get createYourAccount => 'ܥܒܕ\nܚܘܫܒܢܟ';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email / ܫܡܐ';

  @override
  String get phoneOrEmail => 'Phone / Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'ܫܡܐ ܟܠܗ';

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

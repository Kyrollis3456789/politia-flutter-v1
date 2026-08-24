// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Official Aramaic (`arc`).
class AppLocalizationsArc extends AppLocalizations {
  AppLocalizationsArc([String locale = 'arc']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'שלמא ב Politia';

  @override
  String get statusRunning => 'Platform Engine Operational';

  @override
  String get changeLanguage => 'לשנא';

  @override
  String get welcomeBack => 'שלמא תו';

  @override
  String get signIn => 'עול';

  @override
  String get signUp => 'ברי חשבונא';

  @override
  String get helloSignIn => 'שלמא\nעול!';

  @override
  String get createYourAccount => 'ברי\nחשבונך';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email / שמא';

  @override
  String get phoneOrEmail => 'Phone / Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'שמא כלה';

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

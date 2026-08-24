// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Καλώς ήρθατε στο Politia';

  @override
  String get statusRunning => 'Η μηχανή πλατφόρμας λειτουργεί κανονικά';

  @override
  String get changeLanguage => 'Γλώσσα';

  @override
  String get welcomeBack => 'Καλώς ήρθατε πίσω';

  @override
  String get signIn => 'ΣΥΝΔΕΣΗ';

  @override
  String get signUp => 'ΕΓΓΡΑΦΗ';

  @override
  String get helloSignIn => 'Γεια σας!\nΣυνδεθείτε';

  @override
  String get createYourAccount => 'Δημιουργήστε τον\nλογαριασμό σας';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email ή Όνομα χρήστη';

  @override
  String get phoneOrEmail => 'Τηλέφωνο ή Email';

  @override
  String get password => 'Κωδικός πρόσβασης';

  @override
  String get confirmPassword => 'Επιβεβαίωση κωδικού';

  @override
  String get fullName => 'Ονοματεπώνυμο';

  @override
  String get forgotPassword => 'Ξεχάσατε τον κωδικό πρόσβασης;';

  @override
  String get dontHaveAccount => 'Δεν έχετε λογαριασμό;';

  @override
  String get alreadyHaveAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get invalidEmail => 'Παρακαλούμε εισάγετε ένα έγκυρο email';

  @override
  String get passwordTooShort =>
      'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες';

  @override
  String get passwordsDoNotMatch => 'Οι κωδικοί πρόσβασης δεν ταιριάζουν';

  @override
  String get nameRequired => 'Το ονοματεπώνυμο είναι απαραίτητο';
}

/// The translations for Modern Greek, as used in Greece (`el_GR`).
class AppLocalizationsElGr extends AppLocalizationsEl {
  AppLocalizationsElGr() : super('el_GR');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Καλώς ήρθατε στο Politia';

  @override
  String get statusRunning => 'Η μηχανή πλατφόρμας λειτουργεί κανονικά';

  @override
  String get changeLanguage => 'Γλώσσα';

  @override
  String get welcomeBack => 'Καλώς ήρθατε πίσω';

  @override
  String get signIn => 'ΣΥΝΔΕΣΗ';

  @override
  String get signUp => 'ΕΓΓΡΑΦΗ';

  @override
  String get helloSignIn => 'Γεια σας!\nΣυνδεθείτε';

  @override
  String get createYourAccount => 'Δημιουργήστε τον\nλογαριασμό σας';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email ή Όνομα χρήστη';

  @override
  String get phoneOrEmail => 'Τηλέφωνο ή Email';

  @override
  String get password => 'Κωδικός πρόσβασης';

  @override
  String get confirmPassword => 'Επιβεβαίωση κωδικού';

  @override
  String get fullName => 'Ονοματεπώνυμο';

  @override
  String get forgotPassword => 'Ξεχάσατε τον κωδικό πρόσβασης;';

  @override
  String get dontHaveAccount => 'Δεν έχετε λογαριασμό;';

  @override
  String get alreadyHaveAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get invalidEmail => 'Παρακαλούμε εισάγετε ένα έγκυρο email';

  @override
  String get passwordTooShort =>
      'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες';

  @override
  String get passwordsDoNotMatch => 'Οι κωδικοί πρόσβασης δεν ταιριάζουν';

  @override
  String get nameRequired => 'Το ονοματεπώνυμο είναι απαραίτητο';
}

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
  String get copticOrthodox => 'ⲚⲒⲞⲢⲐⲞⲆⲞⲜⲞⲤ Ⲛ̀ⲢⲈⲘⲚ̀ⲬⲎⲘⲒ';

  @override
  String get welcomeMessage => 'Ⲛⲟϥⲣⲓ ϧⲉⲛ Politia';

  @override
  String get statusRunning => 'Platform Engine Operational';

  @override
  String get changeLanguage => 'Ϣⲓⲃϯ ⲛ̀Ϯⲁⲥⲡⲓ';

  @override
  String get selectLanguage => 'ⲤⲰⲦⲠ Ⲛ̀ϮⲀⲤⲠⲒ';

  @override
  String get welcome => 'ⲚⲞϤⲢⲒ';

  @override
  String get welcomeBack => 'Ⲛⲟϥⲣⲓ ⲟⲛ';

  @override
  String get signIn => 'ϢⲈ ⲈϦⲞⲨⲚ';

  @override
  String get signUp => 'ⲐⲀⲘⲒⲞ Ⲛ̀ⲞⲨϨⲨⲠⲞⲦⲀⲤⲒⲤ';

  @override
  String get signInDescription => 'Ⲙⲁⲧⲥⲁⲃⲟ ⲛ̀ⲧⲉⲕ-email ⲓⲉ ⲡⲉⲕⲫⲱⲛ ⲉⲑⲃⲏⲧ ⲉ̀ⲥⲱⲧⲡ.';

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
  String get emailOrMobile => 'Email / Ⲫⲱⲛ';

  @override
  String get emailOrMobileHint => 'webx@gmail.com ⲓⲉ 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Ⲛⲓⲫⲱⲛ ⲛ̀Ⲣⲉⲙⲛ̀ⲭⲏⲙⲓ: 010, 011, 012, 015';

  @override
  String get continueText => 'Ⲙⲟϣⲓ';

  @override
  String get orDivider => 'ⲒⲈ';

  @override
  String get continueWithGoogle => 'Ϣⲉ ⲛⲉⲙ Google';

  @override
  String get continueWithFacebook => 'Ϣⲉ ⲛⲉⲙ Facebook';

  @override
  String get continueWithApple => 'Ϣⲉ ⲛⲉⲙ Apple';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Ⲣⲁⲛ ⲧⲏⲣϥ';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Ⲙⲙⲟⲛⲧⲁⲕ ϩⲩⲡⲟⲧⲁⲥⲓⲥ;';

  @override
  String get alreadyHaveAccount => 'Ⲟⲩⲟⲛⲧⲁⲕ ϩⲩⲡⲟⲧⲁⲥⲓⲥ;';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Ⲣⲁⲛ ⲉⲧⲥϧⲏⲟⲩⲧ';

  @override
  String get back => 'Ⲧⲁⲥⲑⲟ';

  @override
  String get enterEmailOrPhone => 'Ⲁⲣⲓϩⲙⲟⲧ ⲙⲁⲧⲥⲁⲃⲟ ⲛ̀ⲧⲉⲕ-email ⲓⲉ ⲡⲉⲕⲫⲱⲛ';

  @override
  String get invalidIdentityError =>
      'Please enter a valid email or Egyptian phone number';

  @override
  String get userNotRegistered => 'Email ⲓⲉ ⲫⲱⲛ ⲟⲩⲁⲧⲥϧⲁⲓ.';

  @override
  String get enterPassword => 'Ⲙⲁϯ ⲡⲉⲕ-password';

  @override
  String get incorrectPassword => 'Password ⲛ̀ⲧⲉ-ⲙⲏⲓ ⲁⲛ.';

  @override
  String attemptsRemaining(int count) {
    return 'Ⲥⲉⲥⲱϫⲡ ⲛ̀$count ⲛ̀ϫⲓⲛϭⲓⲛⲧ.';
  }

  @override
  String get maxAttemptsOtp =>
      'Max attempts reached (10/10). Verification code (OTP) activated.';

  @override
  String get enterOtpCode => 'Ⲙⲁϯ ⲡⲓ-code ⲛ̀ⲥⲟ ⲛ̀ⲁⲣⲓⲑⲙⲟⲥ';

  @override
  String get enterFullOtp => 'Please enter the full 6-digit OTP';

  @override
  String otpSent(String identity) {
    return 'Ⲁⲩⲟⲩⲱⲣⲡ ⲙ̀ⲡⲓ-code ⲉ̀$identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Ⲟⲛ ⲥⲉⲛⲁⲟⲩⲱⲣⲡ ϧⲉⲛ ${seconds}s';
  }

  @override
  String get resendCode => 'Ⲟⲩⲱⲣⲡ ⲙ̀ⲡⲓ-code ⲟⲛ';

  @override
  String get switchAccount => 'Ϣⲓⲃϯ ⲛ̀Ϯϩⲩⲡⲟⲧⲁⲥⲓⲥ';

  @override
  String get verifyAndSignIn => 'Ⲧⲁϫⲣⲟ & Ϣⲉ ⲉϧⲟⲩⲛ';

  @override
  String get usePasswordInstead => 'Ⲕⲱϯ ⲉ̀ⲡⲓ-password';

  @override
  String get contactAdminForgot =>
      'Please contact church servant to reset password or use OTP';

  @override
  String get registeredMember => 'Ⲙⲉⲗⲟⲥ ⲉⲧⲥϧⲏⲟⲩⲧ';

  @override
  String comingSoon(String provider) {
    return 'Sign in with $provider coming soon';
  }

  @override
  String get verseText =>
      '\"Ⲡⲓⲙⲁ ⲅⲁⲣ ⲉ̀ⲧⲉ ⲟⲩⲟⲛ ⲃ̅ ⲓⲉ ⲅ̅ ⲑⲟⲟⲩϯ ⲉ̀ϧⲟⲩⲛ ⲉ̀ⲡⲁⲣⲁⲛ: ϯⲭⲏ ⲙ̀ⲙⲁⲩ ϧⲉⲛ ⲧⲟⲩⲙⲏϯ.\" — Ⲙⲁⲧⲑⲉⲟⲥ ⲓ̅ⲏ̅: ⲕ̅';
}

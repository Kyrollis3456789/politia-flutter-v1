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
  String get copticOrthodox => 'COPTIC ORTHODOX';

  @override
  String get welcomeMessage => 'Welcome to Politia';

  @override
  String get statusRunning => 'Platform Engine & Localization Operational';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get selectLanguage => 'SELECT LANGUAGE';

  @override
  String get welcome => 'WELCOME';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get signUp => 'SIGN UP';

  @override
  String get signInDescription =>
      'Enter your registered email or mobile number to proceed.';

  @override
  String get helloSignIn => 'Hello\nSign in!';

  @override
  String get createYourAccount => 'Create Your\nAccount';

  @override
  String get email => 'Email';

  @override
  String get emailOrUsername => 'Email or Username';

  @override
  String get phoneOrEmail => 'Phone or Email';

  @override
  String get emailOrMobile => 'Email or Mobile Number';

  @override
  String get emailOrMobileHint => 'webx@gmail.com or 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Supported Egyptian carriers: 010, 011, 012, 015';

  @override
  String get continueText => 'Continue';

  @override
  String get orDivider => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

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
  String get nameRequired => 'Full name is required';

  @override
  String get back => 'Back';

  @override
  String get enterEmailOrPhone => 'Please enter your email or phone number';

  @override
  String get invalidIdentityError =>
      'Please enter a valid email or Egyptian phone number (010, 011, 012, 015)';

  @override
  String get userNotRegistered => 'Email or phone number not registered.';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get incorrectPassword => 'Incorrect password.';

  @override
  String attemptsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attempts remaining.',
      one: '1 attempt remaining.',
    );
    return '$_temp0';
  }

  @override
  String get maxAttemptsOtp =>
      'Maximum password attempts reached (10/10). Verification code (OTP) activated.';

  @override
  String get enterOtpCode => 'Enter 6-Digit Verification Code';

  @override
  String get enterFullOtp => 'Please enter the full 6-digit OTP';

  @override
  String otpSent(String identity) {
    return 'Verification code sent to $identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String get verifyAndSignIn => 'Verify & Sign In';

  @override
  String get usePasswordInstead => 'Use Password instead';

  @override
  String get contactAdminForgot =>
      'Please contact parish admin to reset password or use OTP login';

  @override
  String get registeredMember => 'Registered Member';

  @override
  String comingSoon(String provider) {
    return 'Sign in with $provider coming soon';
  }

  @override
  String get verseText =>
      '\"For where two or three are gathered together in my name, there am I in the midst of them.\" — Matthew 18:20';
}

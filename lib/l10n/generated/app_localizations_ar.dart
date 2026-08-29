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
  String get copticOrthodox => 'الأرثوذكسية القبطية';

  @override
  String get welcomeMessage => 'مرحبًا بك في بوليتيا';

  @override
  String get statusRunning => 'محرك المنصة ونظام التعريب يعملان بكفاءة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get welcome => 'مرحباً بك';

  @override
  String get welcomeBack => 'مرحبًا بك مجددًا';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signInDescription =>
      'أدخل بريدك الإلكتروني أو رقم هاتفك المسجل للمتابعة.';

  @override
  String get helloSignIn => 'أهلاً بك\nسجل الدخول!';

  @override
  String get createYourAccount => 'أنشئ\nحسابك الجديد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailOrUsername => 'البريد الإلكتروني أو اسم المستخدم';

  @override
  String get phoneOrEmail => 'رقم الهاتف أو البريد الإلكتروني';

  @override
  String get emailOrMobile => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get emailOrMobileHint => 'webx@gmail.com أو 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'أرقام الهواتف المصرية المدعومة: 010, 011, 012, 015';

  @override
  String get continueText => 'المتابعة';

  @override
  String get orDivider => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get continueWithFacebook => 'المتابعة باستخدام Facebook';

  @override
  String get continueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'كلمة المرور يجب أن لا تقل عن 6 أحرف';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get nameRequired => 'الاسم الكامل مطلوب';

  @override
  String get back => 'رجوع';

  @override
  String get enterEmailOrPhone => 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';

  @override
  String get invalidIdentityError =>
      'يرجى إدخال بريد إلكتروني صحيح أو رقم هاتف مصري صالح (010, 011, 012, 015)';

  @override
  String get userNotRegistered => 'البريد الإلكتروني أو رقم الهاتف غير مسجل.';

  @override
  String get enterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get incorrectPassword => 'كلمة المرور غير صحيحة.';

  @override
  String attemptsRemaining(int count) {
    return 'متبقي $count محاولات.';
  }

  @override
  String get maxAttemptsOtp =>
      'تجاوزت الحد الأقصى لمحاولات كلمة المرور (10/10). تم تفعيل التحقق برمز OTP.';

  @override
  String get enterOtpCode => 'أدخل رمز التحقق (6 أرقام)';

  @override
  String get enterFullOtp => 'يرجى إدخال رمز التحقق المكون من 6 أرقام';

  @override
  String otpSent(String identity) {
    return 'تم إرسال رمز التحقق إلى $identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'إعادة الإرسال خلال $seconds ثانية';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get switchAccount => 'تغيير الحساب';

  @override
  String get verifyAndSignIn => 'تأكيد الرمز';

  @override
  String get usePasswordInstead => 'الرجوع لاستخدام كلمة المرور';

  @override
  String get contactAdminForgot =>
      'يرجى التواصل مع خادم الكنيسة لإعادة تعيين كلمة المرور أو استخدام رمز OTP';

  @override
  String get registeredMember => 'عضو مسجل';

  @override
  String comingSoon(String provider) {
    return 'تسجيل الدخول عبر $provider قيد التطوير';
  }

  @override
  String get verseText =>
      '\"لأَنَّهُ حَيْثُمَا اجْتَمَعَ اثْنَانِ أَوْ ثَلاَثَةٌ بِاسْمِي فَهُنَاكَ أَكُونُ فِي وَسْطِهِمْ.\" — متى ١٨: ٢٠';
}

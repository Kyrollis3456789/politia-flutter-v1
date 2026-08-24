// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Politia에 오신 것을 환영합니다';

  @override
  String get statusRunning => '플랫폼 엔진 및 현지화 정상 작동 중';

  @override
  String get changeLanguage => '언어';

  @override
  String get welcomeBack => '다시 오신 것을 환영합니다';

  @override
  String get signIn => '로그인';

  @override
  String get signUp => '회원가입';

  @override
  String get helloSignIn => '안녕하세요!\n로그인하세요';

  @override
  String get createYourAccount => '계정을\n생성하세요';

  @override
  String get email => '이메일';

  @override
  String get emailOrUsername => '이메일 또는 사용자 이름';

  @override
  String get phoneOrEmail => '전화번호 또는 이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get fullName => '성명';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get dontHaveAccount => '계정이 없으신가요?';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get invalidEmail => '올바른 이메일을 입력하세요';

  @override
  String get passwordTooShort => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get nameRequired => '성명을 입력해야 합니다';
}

/// The translations for Korean, as used in Republic of Korea (`ko_KR`).
class AppLocalizationsKoKr extends AppLocalizationsKo {
  AppLocalizationsKoKr() : super('ko_KR');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Politia에 오신 것을 환영합니다';

  @override
  String get statusRunning => '플랫폼 엔진 및 현지화 정상 작동 중';

  @override
  String get changeLanguage => '언어';

  @override
  String get welcomeBack => '다시 오신 것을 환영합니다';

  @override
  String get signIn => '로그인';

  @override
  String get signUp => '회원가입';

  @override
  String get helloSignIn => '안녕하세요!\n로그인하세요';

  @override
  String get createYourAccount => '계정을\n생성하세요';

  @override
  String get email => '이메일';

  @override
  String get emailOrUsername => '이메일 또는 사용자 이름';

  @override
  String get phoneOrEmail => '전화번호 또는 이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get fullName => '성명';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get dontHaveAccount => '계정이 없으신가요?';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get invalidEmail => '올바른 이메일을 입력하세요';

  @override
  String get passwordTooShort => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get nameRequired => '성명을 입력해야 합니다';
}

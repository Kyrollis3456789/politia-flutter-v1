// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Politia へようこそ';

  @override
  String get statusRunning => 'プラットフォームエンジンとローカリゼーションが稼働中';

  @override
  String get changeLanguage => '言語';

  @override
  String get welcomeBack => 'お帰りなさい';

  @override
  String get signIn => 'サインイン';

  @override
  String get signUp => '新規登録';

  @override
  String get helloSignIn => 'こんにちは！\nサインイン';

  @override
  String get createYourAccount => 'アカウントを\n作成する';

  @override
  String get email => 'メールアドレス';

  @override
  String get emailOrUsername => 'メールアドレスまたはユーザー名';

  @override
  String get phoneOrEmail => '電話番号またはメールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワードの確認';

  @override
  String get fullName => '氏名';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get invalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get nameRequired => '氏名を入力してください';
}

/// The translations for Japanese, as used in Japan (`ja_JP`).
class AppLocalizationsJaJp extends AppLocalizationsJa {
  AppLocalizationsJaJp() : super('ja_JP');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Politia へようこそ';

  @override
  String get statusRunning => 'プラットフォームエンジンとローカリゼーションが稼働中';

  @override
  String get changeLanguage => '言語';

  @override
  String get welcomeBack => 'お帰りなさい';

  @override
  String get signIn => 'サインイン';

  @override
  String get signUp => '新規登録';

  @override
  String get helloSignIn => 'こんにちは！\nサインイン';

  @override
  String get createYourAccount => 'アカウントを\n作成する';

  @override
  String get email => 'メールアドレス';

  @override
  String get emailOrUsername => 'メールアドレスまたはユーザー名';

  @override
  String get phoneOrEmail => '電話番号またはメールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワードの確認';

  @override
  String get fullName => '氏名';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get invalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get nameRequired => '氏名を入力してください';
}

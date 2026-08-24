// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Добро пожаловать в Politia';

  @override
  String get statusRunning => 'Платформа и локализация работают стабильно';

  @override
  String get changeLanguage => 'Язык';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signIn => 'ВОЙТИ';

  @override
  String get signUp => 'РЕГИСТРАЦИЯ';

  @override
  String get helloSignIn => 'Привет!\nВойдите в аккаунт';

  @override
  String get createYourAccount => 'Создайте свой\nаккаунт';

  @override
  String get email => 'Эл. почта';

  @override
  String get emailOrUsername => 'Эл. почта или имя пользователя';

  @override
  String get phoneOrEmail => 'Телефон или эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get invalidEmail => 'Введите корректный адрес эл. почты';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get nameRequired => 'Требуется указать полное имя';
}

/// The translations for Russian, as used in Russian Federation (`ru_RU`).
class AppLocalizationsRuRu extends AppLocalizationsRu {
  AppLocalizationsRuRu() : super('ru_RU');

  @override
  String get appTitle => 'Politia';

  @override
  String get welcomeMessage => 'Добро пожаловать в Politia';

  @override
  String get statusRunning => 'Платформа и локализация работают стабильно';

  @override
  String get changeLanguage => 'Язык';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signIn => 'ВОЙТИ';

  @override
  String get signUp => 'РЕГИСТРАЦИЯ';

  @override
  String get helloSignIn => 'Привет!\nВойдите в аккаунт';

  @override
  String get createYourAccount => 'Создайте свой\nаккаунт';

  @override
  String get email => 'Эл. почта';

  @override
  String get emailOrUsername => 'Эл. почта или имя пользователя';

  @override
  String get phoneOrEmail => 'Телефон или эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get invalidEmail => 'Введите корректный адрес эл. почты';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get nameRequired => 'Требуется указать полное имя';
}

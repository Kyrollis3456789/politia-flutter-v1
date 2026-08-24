import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_arc.dart';
import 'app_localizations_az.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cop.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_my.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_syc.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('af', 'ZA'),
    Locale('am'),
    Locale('am', 'ET'),
    Locale('ar'),
    Locale('ar', 'AE'),
    Locale('ar', 'BH'),
    Locale('ar', 'DZ'),
    Locale('ar', 'EG'),
    Locale('ar', 'IQ'),
    Locale('ar', 'JO'),
    Locale('ar', 'KW'),
    Locale('ar', 'LB'),
    Locale('ar', 'LY'),
    Locale('ar', 'MA'),
    Locale('ar', 'OM'),
    Locale('ar', 'QA'),
    Locale('ar', 'SA'),
    Locale('ar', 'SY'),
    Locale('ar', 'TN'),
    Locale('ar', 'YE'),
    Locale('arc'),
    Locale('az'),
    Locale('az', 'AZ'),
    Locale('be'),
    Locale('be', 'BY'),
    Locale('bg'),
    Locale('bg', 'BG'),
    Locale('bn'),
    Locale('bn', 'BD'),
    Locale('bn', 'IN'),
    Locale('bs'),
    Locale('bs', 'BA'),
    Locale('ca'),
    Locale('ca', 'ES'),
    Locale('cop'),
    Locale('cop', 'EG'),
    Locale('cs'),
    Locale('cs', 'CZ'),
    Locale('cy'),
    Locale('cy', 'GB'),
    Locale('da'),
    Locale('da', 'DK'),
    Locale('de'),
    Locale('de', 'AT'),
    Locale('de', 'CH'),
    Locale('de', 'DE'),
    Locale('el'),
    Locale('el', 'GR'),
    Locale('en'),
    Locale('en', 'AU'),
    Locale('en', 'CA'),
    Locale('en', 'GB'),
    Locale('en', 'IE'),
    Locale('en', 'IN'),
    Locale('en', 'NZ'),
    Locale('en', 'SG'),
    Locale('en', 'US'),
    Locale('en', 'ZA'),
    Locale('es'),
    Locale('es', 'AR'),
    Locale('es', 'BO'),
    Locale('es', 'CL'),
    Locale('es', 'CO'),
    Locale('es', 'CR'),
    Locale('es', 'DO'),
    Locale('es', 'EC'),
    Locale('es', 'ES'),
    Locale('es', 'GT'),
    Locale('es', 'HN'),
    Locale('es', 'MX'),
    Locale('es', 'NI'),
    Locale('es', 'PA'),
    Locale('es', 'PE'),
    Locale('es', 'PR'),
    Locale('es', 'PY'),
    Locale('es', 'SV'),
    Locale('es', 'US'),
    Locale('es', 'UY'),
    Locale('es', 'VE'),
    Locale('et'),
    Locale('et', 'EE'),
    Locale('eu'),
    Locale('eu', 'ES'),
    Locale('fa'),
    Locale('fa', 'IR'),
    Locale('fi'),
    Locale('fi', 'FI'),
    Locale('fil'),
    Locale('fil', 'PH'),
    Locale('fr'),
    Locale('fr', 'BE'),
    Locale('fr', 'CA'),
    Locale('fr', 'CH'),
    Locale('fr', 'FR'),
    Locale('fr', 'LU'),
    Locale('gl'),
    Locale('gl', 'ES'),
    Locale('gu'),
    Locale('gu', 'IN'),
    Locale('he'),
    Locale('he', 'IL'),
    Locale('hi'),
    Locale('hi', 'IN'),
    Locale('hr'),
    Locale('hr', 'HR'),
    Locale('hu'),
    Locale('hu', 'HU'),
    Locale('hy'),
    Locale('hy', 'AM'),
    Locale('id'),
    Locale('id', 'ID'),
    Locale('is'),
    Locale('is', 'IS'),
    Locale('it'),
    Locale('it', 'CH'),
    Locale('it', 'IT'),
    Locale('ja'),
    Locale('ja', 'JP'),
    Locale('ka'),
    Locale('ka', 'GE'),
    Locale('kk'),
    Locale('kk', 'KZ'),
    Locale('km'),
    Locale('km', 'KH'),
    Locale('kn'),
    Locale('kn', 'IN'),
    Locale('ko'),
    Locale('ko', 'KR'),
    Locale('lo'),
    Locale('lo', 'LA'),
    Locale('lt'),
    Locale('lt', 'LT'),
    Locale('lv'),
    Locale('lv', 'LV'),
    Locale('mk'),
    Locale('mk', 'MK'),
    Locale('ml'),
    Locale('ml', 'IN'),
    Locale('mn'),
    Locale('mn', 'MN'),
    Locale('mr'),
    Locale('mr', 'IN'),
    Locale('ms'),
    Locale('ms', 'MY'),
    Locale('my'),
    Locale('my', 'MM'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('ne'),
    Locale('ne', 'NP'),
    Locale('nl'),
    Locale('nl', 'BE'),
    Locale('nl', 'NL'),
    Locale('pa'),
    Locale('pa', 'IN'),
    Locale('pl'),
    Locale('pl', 'PL'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ro', 'RO'),
    Locale('ru'),
    Locale('ru', 'RU'),
    Locale('si'),
    Locale('si', 'LK'),
    Locale('sk'),
    Locale('sk', 'SK'),
    Locale('sl'),
    Locale('sl', 'SI'),
    Locale('sq'),
    Locale('sq', 'AL'),
    Locale('sr'),
    Locale('sr', 'RS'),
    Locale('sv'),
    Locale('sv', 'SE'),
    Locale('sw'),
    Locale('sw', 'KE'),
    Locale('syc'),
    Locale('ta'),
    Locale('ta', 'IN'),
    Locale('ta', 'LK'),
    Locale('te'),
    Locale('te', 'IN'),
    Locale('th'),
    Locale('th', 'TH'),
    Locale('tr'),
    Locale('tr', 'TR'),
    Locale('uk'),
    Locale('uk', 'UA'),
    Locale('ur'),
    Locale('ur', 'PK'),
    Locale('uz'),
    Locale('uz', 'UZ'),
    Locale('vi'),
    Locale('vi', 'VN'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'HK'),
    Locale('zh', 'SG'),
    Locale('zh', 'TW')
  ];

  /// Localization for appTitle
  ///
  /// In en, this message translates to:
  /// **'Politia'**
  String get appTitle;

  /// Localization for welcomeMessage
  ///
  /// In en, this message translates to:
  /// **'Welcome to Politia'**
  String get welcomeMessage;

  /// Localization for statusRunning
  ///
  /// In en, this message translates to:
  /// **'Platform Engine & Localization Operational'**
  String get statusRunning;

  /// Localization for changeLanguage
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguage;

  /// Localization for welcomeBack
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Localization for signIn
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// Localization for signUp
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUp;

  /// Localization for helloSignIn
  ///
  /// In en, this message translates to:
  /// **'Hello\nSign in!'**
  String get helloSignIn;

  /// Localization for createYourAccount
  ///
  /// In en, this message translates to:
  /// **'Create Your\nAccount'**
  String get createYourAccount;

  /// Localization for email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Localization for emailOrUsername
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get emailOrUsername;

  /// Localization for phoneOrEmail
  ///
  /// In en, this message translates to:
  /// **'Phone or Email'**
  String get phoneOrEmail;

  /// Localization for password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Localization for confirmPassword
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Localization for fullName
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Localization for forgotPassword
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Localization for dontHaveAccount
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Localization for alreadyHaveAccount
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Localization for invalidEmail
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Localization for passwordTooShort
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Localization for passwordsDoNotMatch
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Localization for nameRequired
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get nameRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'af',
        'am',
        'ar',
        'arc',
        'az',
        'be',
        'bg',
        'bn',
        'bs',
        'ca',
        'cop',
        'cs',
        'cy',
        'da',
        'de',
        'el',
        'en',
        'es',
        'et',
        'eu',
        'fa',
        'fi',
        'fil',
        'fr',
        'gl',
        'gu',
        'he',
        'hi',
        'hr',
        'hu',
        'hy',
        'id',
        'is',
        'it',
        'ja',
        'ka',
        'kk',
        'km',
        'kn',
        'ko',
        'lo',
        'lt',
        'lv',
        'mk',
        'ml',
        'mn',
        'mr',
        'ms',
        'my',
        'nb',
        'ne',
        'nl',
        'pa',
        'pl',
        'pt',
        'ro',
        'ru',
        'si',
        'sk',
        'sl',
        'sq',
        'sr',
        'sv',
        'sw',
        'syc',
        'ta',
        'te',
        'th',
        'tr',
        'uk',
        'ur',
        'uz',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'af':
      {
        switch (locale.countryCode) {
          case 'ZA':
            return AppLocalizationsAfZa();
        }
        break;
      }
    case 'am':
      {
        switch (locale.countryCode) {
          case 'ET':
            return AppLocalizationsAmEt();
        }
        break;
      }
    case 'ar':
      {
        switch (locale.countryCode) {
          case 'AE':
            return AppLocalizationsArAe();
          case 'BH':
            return AppLocalizationsArBh();
          case 'DZ':
            return AppLocalizationsArDz();
          case 'EG':
            return AppLocalizationsArEg();
          case 'IQ':
            return AppLocalizationsArIq();
          case 'JO':
            return AppLocalizationsArJo();
          case 'KW':
            return AppLocalizationsArKw();
          case 'LB':
            return AppLocalizationsArLb();
          case 'LY':
            return AppLocalizationsArLy();
          case 'MA':
            return AppLocalizationsArMa();
          case 'OM':
            return AppLocalizationsArOm();
          case 'QA':
            return AppLocalizationsArQa();
          case 'SA':
            return AppLocalizationsArSa();
          case 'SY':
            return AppLocalizationsArSy();
          case 'TN':
            return AppLocalizationsArTn();
          case 'YE':
            return AppLocalizationsArYe();
        }
        break;
      }
    case 'az':
      {
        switch (locale.countryCode) {
          case 'AZ':
            return AppLocalizationsAzAz();
        }
        break;
      }
    case 'be':
      {
        switch (locale.countryCode) {
          case 'BY':
            return AppLocalizationsBeBy();
        }
        break;
      }
    case 'bg':
      {
        switch (locale.countryCode) {
          case 'BG':
            return AppLocalizationsBgBg();
        }
        break;
      }
    case 'bn':
      {
        switch (locale.countryCode) {
          case 'BD':
            return AppLocalizationsBnBd();
          case 'IN':
            return AppLocalizationsBnIn();
        }
        break;
      }
    case 'bs':
      {
        switch (locale.countryCode) {
          case 'BA':
            return AppLocalizationsBsBa();
        }
        break;
      }
    case 'ca':
      {
        switch (locale.countryCode) {
          case 'ES':
            return AppLocalizationsCaEs();
        }
        break;
      }
    case 'cop':
      {
        switch (locale.countryCode) {
          case 'EG':
            return AppLocalizationsCopEg();
        }
        break;
      }
    case 'cs':
      {
        switch (locale.countryCode) {
          case 'CZ':
            return AppLocalizationsCsCz();
        }
        break;
      }
    case 'cy':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsCyGb();
        }
        break;
      }
    case 'da':
      {
        switch (locale.countryCode) {
          case 'DK':
            return AppLocalizationsDaDk();
        }
        break;
      }
    case 'de':
      {
        switch (locale.countryCode) {
          case 'AT':
            return AppLocalizationsDeAt();
          case 'CH':
            return AppLocalizationsDeCh();
          case 'DE':
            return AppLocalizationsDeDe();
        }
        break;
      }
    case 'el':
      {
        switch (locale.countryCode) {
          case 'GR':
            return AppLocalizationsElGr();
        }
        break;
      }
    case 'en':
      {
        switch (locale.countryCode) {
          case 'AU':
            return AppLocalizationsEnAu();
          case 'CA':
            return AppLocalizationsEnCa();
          case 'GB':
            return AppLocalizationsEnGb();
          case 'IE':
            return AppLocalizationsEnIe();
          case 'IN':
            return AppLocalizationsEnIn();
          case 'NZ':
            return AppLocalizationsEnNz();
          case 'SG':
            return AppLocalizationsEnSg();
          case 'US':
            return AppLocalizationsEnUs();
          case 'ZA':
            return AppLocalizationsEnZa();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case 'AR':
            return AppLocalizationsEsAr();
          case 'BO':
            return AppLocalizationsEsBo();
          case 'CL':
            return AppLocalizationsEsCl();
          case 'CO':
            return AppLocalizationsEsCo();
          case 'CR':
            return AppLocalizationsEsCr();
          case 'DO':
            return AppLocalizationsEsDo();
          case 'EC':
            return AppLocalizationsEsEc();
          case 'ES':
            return AppLocalizationsEsEs();
          case 'GT':
            return AppLocalizationsEsGt();
          case 'HN':
            return AppLocalizationsEsHn();
          case 'MX':
            return AppLocalizationsEsMx();
          case 'NI':
            return AppLocalizationsEsNi();
          case 'PA':
            return AppLocalizationsEsPa();
          case 'PE':
            return AppLocalizationsEsPe();
          case 'PR':
            return AppLocalizationsEsPr();
          case 'PY':
            return AppLocalizationsEsPy();
          case 'SV':
            return AppLocalizationsEsSv();
          case 'US':
            return AppLocalizationsEsUs();
          case 'UY':
            return AppLocalizationsEsUy();
          case 'VE':
            return AppLocalizationsEsVe();
        }
        break;
      }
    case 'et':
      {
        switch (locale.countryCode) {
          case 'EE':
            return AppLocalizationsEtEe();
        }
        break;
      }
    case 'eu':
      {
        switch (locale.countryCode) {
          case 'ES':
            return AppLocalizationsEuEs();
        }
        break;
      }
    case 'fa':
      {
        switch (locale.countryCode) {
          case 'IR':
            return AppLocalizationsFaIr();
        }
        break;
      }
    case 'fi':
      {
        switch (locale.countryCode) {
          case 'FI':
            return AppLocalizationsFiFi();
        }
        break;
      }
    case 'fil':
      {
        switch (locale.countryCode) {
          case 'PH':
            return AppLocalizationsFilPh();
        }
        break;
      }
    case 'fr':
      {
        switch (locale.countryCode) {
          case 'BE':
            return AppLocalizationsFrBe();
          case 'CA':
            return AppLocalizationsFrCa();
          case 'CH':
            return AppLocalizationsFrCh();
          case 'FR':
            return AppLocalizationsFrFr();
          case 'LU':
            return AppLocalizationsFrLu();
        }
        break;
      }
    case 'gl':
      {
        switch (locale.countryCode) {
          case 'ES':
            return AppLocalizationsGlEs();
        }
        break;
      }
    case 'gu':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsGuIn();
        }
        break;
      }
    case 'he':
      {
        switch (locale.countryCode) {
          case 'IL':
            return AppLocalizationsHeIl();
        }
        break;
      }
    case 'hi':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsHiIn();
        }
        break;
      }
    case 'hr':
      {
        switch (locale.countryCode) {
          case 'HR':
            return AppLocalizationsHrHr();
        }
        break;
      }
    case 'hu':
      {
        switch (locale.countryCode) {
          case 'HU':
            return AppLocalizationsHuHu();
        }
        break;
      }
    case 'hy':
      {
        switch (locale.countryCode) {
          case 'AM':
            return AppLocalizationsHyAm();
        }
        break;
      }
    case 'id':
      {
        switch (locale.countryCode) {
          case 'ID':
            return AppLocalizationsIdId();
        }
        break;
      }
    case 'is':
      {
        switch (locale.countryCode) {
          case 'IS':
            return AppLocalizationsIsIs();
        }
        break;
      }
    case 'it':
      {
        switch (locale.countryCode) {
          case 'CH':
            return AppLocalizationsItCh();
          case 'IT':
            return AppLocalizationsItIt();
        }
        break;
      }
    case 'ja':
      {
        switch (locale.countryCode) {
          case 'JP':
            return AppLocalizationsJaJp();
        }
        break;
      }
    case 'ka':
      {
        switch (locale.countryCode) {
          case 'GE':
            return AppLocalizationsKaGe();
        }
        break;
      }
    case 'kk':
      {
        switch (locale.countryCode) {
          case 'KZ':
            return AppLocalizationsKkKz();
        }
        break;
      }
    case 'km':
      {
        switch (locale.countryCode) {
          case 'KH':
            return AppLocalizationsKmKh();
        }
        break;
      }
    case 'kn':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsKnIn();
        }
        break;
      }
    case 'ko':
      {
        switch (locale.countryCode) {
          case 'KR':
            return AppLocalizationsKoKr();
        }
        break;
      }
    case 'lo':
      {
        switch (locale.countryCode) {
          case 'LA':
            return AppLocalizationsLoLa();
        }
        break;
      }
    case 'lt':
      {
        switch (locale.countryCode) {
          case 'LT':
            return AppLocalizationsLtLt();
        }
        break;
      }
    case 'lv':
      {
        switch (locale.countryCode) {
          case 'LV':
            return AppLocalizationsLvLv();
        }
        break;
      }
    case 'mk':
      {
        switch (locale.countryCode) {
          case 'MK':
            return AppLocalizationsMkMk();
        }
        break;
      }
    case 'ml':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsMlIn();
        }
        break;
      }
    case 'mn':
      {
        switch (locale.countryCode) {
          case 'MN':
            return AppLocalizationsMnMn();
        }
        break;
      }
    case 'mr':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsMrIn();
        }
        break;
      }
    case 'ms':
      {
        switch (locale.countryCode) {
          case 'MY':
            return AppLocalizationsMsMy();
        }
        break;
      }
    case 'my':
      {
        switch (locale.countryCode) {
          case 'MM':
            return AppLocalizationsMyMm();
        }
        break;
      }
    case 'nb':
      {
        switch (locale.countryCode) {
          case 'NO':
            return AppLocalizationsNbNo();
        }
        break;
      }
    case 'ne':
      {
        switch (locale.countryCode) {
          case 'NP':
            return AppLocalizationsNeNp();
        }
        break;
      }
    case 'nl':
      {
        switch (locale.countryCode) {
          case 'BE':
            return AppLocalizationsNlBe();
          case 'NL':
            return AppLocalizationsNlNl();
        }
        break;
      }
    case 'pa':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsPaIn();
        }
        break;
      }
    case 'pl':
      {
        switch (locale.countryCode) {
          case 'PL':
            return AppLocalizationsPlPl();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
    case 'ro':
      {
        switch (locale.countryCode) {
          case 'RO':
            return AppLocalizationsRoRo();
        }
        break;
      }
    case 'ru':
      {
        switch (locale.countryCode) {
          case 'RU':
            return AppLocalizationsRuRu();
        }
        break;
      }
    case 'si':
      {
        switch (locale.countryCode) {
          case 'LK':
            return AppLocalizationsSiLk();
        }
        break;
      }
    case 'sk':
      {
        switch (locale.countryCode) {
          case 'SK':
            return AppLocalizationsSkSk();
        }
        break;
      }
    case 'sl':
      {
        switch (locale.countryCode) {
          case 'SI':
            return AppLocalizationsSlSi();
        }
        break;
      }
    case 'sq':
      {
        switch (locale.countryCode) {
          case 'AL':
            return AppLocalizationsSqAl();
        }
        break;
      }
    case 'sr':
      {
        switch (locale.countryCode) {
          case 'RS':
            return AppLocalizationsSrRs();
        }
        break;
      }
    case 'sv':
      {
        switch (locale.countryCode) {
          case 'SE':
            return AppLocalizationsSvSe();
        }
        break;
      }
    case 'sw':
      {
        switch (locale.countryCode) {
          case 'KE':
            return AppLocalizationsSwKe();
        }
        break;
      }
    case 'ta':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsTaIn();
          case 'LK':
            return AppLocalizationsTaLk();
        }
        break;
      }
    case 'te':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsTeIn();
        }
        break;
      }
    case 'th':
      {
        switch (locale.countryCode) {
          case 'TH':
            return AppLocalizationsThTh();
        }
        break;
      }
    case 'tr':
      {
        switch (locale.countryCode) {
          case 'TR':
            return AppLocalizationsTrTr();
        }
        break;
      }
    case 'uk':
      {
        switch (locale.countryCode) {
          case 'UA':
            return AppLocalizationsUkUa();
        }
        break;
      }
    case 'ur':
      {
        switch (locale.countryCode) {
          case 'PK':
            return AppLocalizationsUrPk();
        }
        break;
      }
    case 'uz':
      {
        switch (locale.countryCode) {
          case 'UZ':
            return AppLocalizationsUzUz();
        }
        break;
      }
    case 'vi':
      {
        switch (locale.countryCode) {
          case 'VN':
            return AppLocalizationsViVn();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'HK':
            return AppLocalizationsZhHk();
          case 'SG':
            return AppLocalizationsZhSg();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'arc':
      return AppLocalizationsArc();
    case 'az':
      return AppLocalizationsAz();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'ca':
      return AppLocalizationsCa();
    case 'cop':
      return AppLocalizationsCop();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'gl':
      return AppLocalizationsGl();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'lo':
      return AppLocalizationsLo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mk':
      return AppLocalizationsMk();
    case 'ml':
      return AppLocalizationsMl();
    case 'mn':
      return AppLocalizationsMn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'my':
      return AppLocalizationsMy();
    case 'nb':
      return AppLocalizationsNb();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'syc':
      return AppLocalizationsSyc();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

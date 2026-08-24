import 'package:flutter/material.dart';

/// Central application constants including the full 131+ locale registry.
class AppConstants {
  AppConstants._();

  static const String appName = 'Politia';

  // ===========================================================================
  // 131+ Supported Locales Architecture Registry
  // ===========================================================================

  /// Liturgical & Heritage Languages (4)
  static const List<Locale> liturgicalLocales = [
    Locale('arc'), // Aramaic
    Locale.fromSubtags(
      languageCode: 'cop',
      countryCode: 'EG',
      scriptCode: 'Bohair',
    ), // Coptic (Bohairic)
    Locale.fromSubtags(
      languageCode: 'cop',
      countryCode: 'EG',
      scriptCode: 'Sahid',
    ), // Coptic (Sahidic)
    Locale('syc'), // Classical Syriac
  ];

  /// Arabic Variants - RTL (16)
  static const List<Locale> arabicLocales = [
    Locale('ar', 'AE'), // United Arab Emirates
    Locale('ar', 'BH'), // Bahrain
    Locale('ar', 'DZ'), // Algeria
    Locale('ar', 'EG'), // Egypt
    Locale('ar', 'IQ'), // Iraq
    Locale('ar', 'JO'), // Jordan
    Locale('ar', 'KW'), // Kuwait
    Locale('ar', 'LB'), // Lebanon
    Locale('ar', 'LY'), // Libya
    Locale('ar', 'MA'), // Morocco
    Locale('ar', 'OM'), // Oman
    Locale('ar', 'QA'), // Qatar
    Locale('ar', 'SA'), // Saudi Arabia
    Locale('ar', 'SY'), // Syria
    Locale('ar', 'TN'), // Tunisia
    Locale('ar', 'YE'), // Yemen
  ];

  /// English Variants (9)
  static const List<Locale> englishLocales = [
    Locale('en', 'AU'), // Australia
    Locale('en', 'CA'), // Canada
    Locale('en', 'GB'), // United Kingdom
    Locale('en', 'IE'), // Ireland
    Locale('en', 'IN'), // India
    Locale('en', 'NZ'), // New Zealand
    Locale('en', 'SG'), // Singapore
    Locale('en', 'US'), // United States
    Locale('en', 'ZA'), // South Africa
  ];

  /// Spanish Variants (20)
  static const List<Locale> spanishLocales = [
    Locale('es', 'AR'), // Argentina
    Locale('es', 'BO'), // Bolivia
    Locale('es', 'CL'), // Chile
    Locale('es', 'CO'), // Colombia
    Locale('es', 'CR'), // Costa Rica
    Locale('es', 'DO'), // Dominican Republic
    Locale('es', 'EC'), // Ecuador
    Locale('es', 'ES'), // Spain
    Locale('es', 'GT'), // Guatemala
    Locale('es', 'HN'), // Honduras
    Locale('es', 'MX'), // Mexico
    Locale('es', 'NI'), // Nicaragua
    Locale('es', 'PA'), // Panama
    Locale('es', 'PE'), // Peru
    Locale('es', 'PR'), // Puerto Rico
    Locale('es', 'PY'), // Paraguay
    Locale('es', 'SV'), // El Salvador
    Locale('es', 'US'), // United States (Spanish)
    Locale('es', 'UY'), // Uruguay
    Locale('es', 'VE'), // Venezuela
  ];

  /// French Variants (5)
  static const List<Locale> frenchLocales = [
    Locale('fr', 'BE'), // Belgium
    Locale('fr', 'CA'), // Canada
    Locale('fr', 'CH'), // Switzerland
    Locale('fr', 'FR'), // France
    Locale('fr', 'LU'), // Luxembourg
  ];

  /// German Variants (3)
  static const List<Locale> germanLocales = [
    Locale('de', 'AT'), // Austria
    Locale('de', 'CH'), // Switzerland
    Locale('de', 'DE'), // Germany
  ];

  /// Portuguese Variants (2)
  static const List<Locale> portugueseLocales = [
    Locale('pt', 'BR'), // Brazil
    Locale('pt', 'PT'), // Portugal
  ];

  /// Italian Variants (2)
  static const List<Locale> italianLocales = [
    Locale('it', 'CH'), // Switzerland
    Locale('it', 'IT'), // Italy
  ];

  /// Dutch Variants (2)
  static const List<Locale> dutchLocales = [
    Locale('nl', 'BE'), // Belgium
    Locale('nl', 'NL'), // Netherlands
  ];

  /// Chinese Scripts & Regions (4)
  static const List<Locale> chineseLocales = [
    Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'CN',
    ), // Simplified (China)
    Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'SG',
    ), // Simplified (Singapore)
    Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'TW',
    ), // Traditional (Taiwan)
    Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'HK',
    ), // Traditional (Hong Kong)
  ];

  /// Bengali & Tamil (4)
  static const List<Locale> bengaliTamilLocales = [
    Locale('bn', 'BD'), // Bengali (Bangladesh)
    Locale('bn', 'IN'), // Bengali (India)
    Locale('ta', 'IN'), // Tamil (India)
    Locale('ta', 'LK'), // Tamil (Sri Lanka)
  ];

  /// European Languages (34)
  static const List<Locale> europeanLocales = [
    Locale('sq', 'AL'), // Albanian
    Locale('hy', 'AM'), // Armenian
    Locale('az', 'AZ'), // Azerbaijani
    Locale('eu', 'ES'), // Basque
    Locale('be', 'BY'), // Belarusian
    Locale('bs', 'BA'), // Bosnian
    Locale('bg', 'BG'), // Bulgarian
    Locale('ca', 'ES'), // Catalan
    Locale('hr', 'HR'), // Croatian
    Locale('cs', 'CZ'), // Czech
    Locale('da', 'DK'), // Danish
    Locale('et', 'EE'), // Estonian
    Locale('fi', 'FI'), // Finnish
    Locale('gl', 'ES'), // Galician
    Locale('ka', 'GE'), // Georgian
    Locale('el', 'GR'), // Greek
    Locale('hu', 'HU'), // Hungarian
    Locale('is', 'IS'), // Icelandic
    Locale('ga', 'IE'), // Irish
    Locale('lv', 'LV'), // Latvian
    Locale('lt', 'LT'), // Lithuanian
    Locale('mk', 'MK'), // Macedonian
    Locale('mt', 'MT'), // Maltese
    Locale('no', 'NO'), // Norwegian
    Locale('pl', 'PL'), // Polish
    Locale('ro', 'RO'), // Romanian
    Locale('ru', 'RU'), // Russian
    Locale('sr', 'RS'), // Serbian
    Locale('sk', 'SK'), // Slovak
    Locale('sl', 'SI'), // Slovenian
    Locale('sv', 'SE'), // Swedish
    Locale('tr', 'TR'), // Turkish
    Locale('uk', 'UA'), // Ukrainian
    Locale('cy', 'GB'), // Welsh
  ];

  /// Regional Asian & African Languages (32)
  static const List<Locale> regionalAsianAfricanLocales = [
    Locale('af', 'ZA'), // Afrikaans
    Locale('am', 'ET'), // Amharic
    Locale('as', 'IN'), // Assamese
    Locale('my', 'MM'), // Burmese
    Locale('fil', 'PH'), // Filipino
    Locale('gu', 'IN'), // Gujarati
    Locale('ha', 'NG'), // Hausa
    Locale('he', 'IL'), // Hebrew (RTL)
    Locale('hi', 'IN'), // Hindi
    Locale('id', 'ID'), // Indonesian
    Locale('ja', 'JP'), // Japanese
    Locale('jv', 'ID'), // Javanese
    Locale('kn', 'IN'), // Kannada
    Locale('kk', 'KZ'), // Kazakh
    Locale('km', 'KH'), // Khmer
    Locale('ko', 'KR'), // Korean
    Locale('lo', 'LA'), // Lao
    Locale('ms', 'MY'), // Malay
    Locale('ml', 'IN'), // Malayalam
    Locale('mr', 'IN'), // Marathi
    Locale('mn', 'MN'), // Mongolian
    Locale('ne', 'NP'), // Nepali
    Locale('or', 'IN'), // Odia
    Locale('pa', 'IN'), // Punjabi
    Locale('si', 'LK'), // Sinhala
    Locale('sw', 'KE'), // Swahili
    Locale('te', 'IN'), // Telugu
    Locale('th', 'TH'), // Thai
    Locale('ur', 'PK'), // Urdu (RTL)
    Locale('uz', 'UZ'), // Uzbek
    Locale('vi', 'VN'), // Vietnamese
    Locale('zu', 'ZA'), // Zulu
  ];

  /// Complete list of 131+ supported locales
  static const List<Locale> allSupportedLocales = [
    ...liturgicalLocales,
    ...arabicLocales,
    ...englishLocales,
    ...spanishLocales,
    ...frenchLocales,
    ...germanLocales,
    ...portugueseLocales,
    ...italianLocales,
    ...dutchLocales,
    ...chineseLocales,
    ...bengaliTamilLocales,
    ...europeanLocales,
    ...regionalAsianAfricanLocales,
  ];
}

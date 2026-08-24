import 'package:flutter/material.dart';

enum LocaleCategory {
  liturgical('Liturgical & Biblical', 'اللغات الليتورجية والكتابية'),
  global('Multi-Regional Global', 'اللغات العالمية متعددة الأقاليم'),
  european('European & Regional', 'اللغات الأوروبية والإقليمية'),
  asianAfrican('Asian, Middle Eastern & African', 'اللغات الآسيوية والشرق أوسطية والإفريقية');

  final String englishLabel;
  final String arabicLabel;
  const LocaleCategory(this.englishLabel, this.arabicLabel);
}

class PolitiaLocaleMetadata {
  final String tag;
  final String languageCode;
  final String? countryCode;
  final String? scriptCode;
  final String englishName;
  final String nativeName;
  final LocaleCategory category;
  final bool isRtl;

  const PolitiaLocaleMetadata({
    required this.tag,
    required this.languageCode,
    this.countryCode,
    this.scriptCode,
    required this.englishName,
    required this.nativeName,
    required this.category,
    this.isRtl = false,
  });

  Locale toLocale() {
    return Locale.fromSubtags(
      languageCode: languageCode,
      countryCode: countryCode,
      scriptCode: scriptCode,
    );
  }
}

class PolitiaLocales {
  static const List<PolitiaLocaleMetadata> all = [
    // 1. Liturgical & Biblical Languages (4)
    PolitiaLocaleMetadata(
      tag: 'arc',
      languageCode: 'arc',
      englishName: 'Aramaic (Imperial / Biblical)',
      nativeName: 'ܐܪܡܝܐ / ארמית',
      category: LocaleCategory.liturgical,
      isRtl: true,
    ),
    PolitiaLocaleMetadata(
      tag: 'cop-EG-bohair',
      languageCode: 'cop',
      countryCode: 'EG',
      scriptCode: 'Bohair',
      englishName: 'Coptic (Bohairic Dialect, Egypt)',
      nativeName: 'Ϯⲁⲥⲡⲓ ⲛ̀ⲣⲉⲙⲛ̀ⲭⲏⲙⲓ (Ⲃⲟϩⲁⲓⲣⲓ)',
      category: LocaleCategory.liturgical,
      isRtl: false,
    ),
    PolitiaLocaleMetadata(
      tag: 'cop-EG-sahid',
      languageCode: 'cop',
      countryCode: 'EG',
      scriptCode: 'Sahid',
      englishName: 'Coptic (Sahidic Dialect, Egypt)',
      nativeName: 'Ⲧⲁⲥⲡⲉ ⲛ̄ⲣⲙ̄ⲛ̄ⲕⲏⲙⲉ (Ⲥⲁϩⲓⲇⲓ)',
      category: LocaleCategory.liturgical,
      isRtl: false,
    ),
    PolitiaLocaleMetadata(
      tag: 'syc',
      languageCode: 'syc',
      englishName: 'Classical Syriac',
      nativeName: 'ܣܘܪܝܝܐ ܟܠܣܝܟܝܐ',
      category: LocaleCategory.liturgical,
      isRtl: true,
    ),

    // 2. Multi-Regional Global Languages (65)
    // Arabic (16 Locales)
    PolitiaLocaleMetadata(tag: 'ar-AE', languageCode: 'ar', countryCode: 'AE', englishName: 'Arabic (United Arab Emirates)', nativeName: 'العربية (الإمارات)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-BH', languageCode: 'ar', countryCode: 'BH', englishName: 'Arabic (Bahrain)', nativeName: 'العربية (البحرين)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-DZ', languageCode: 'ar', countryCode: 'DZ', englishName: 'Arabic (Algeria)', nativeName: 'العربية (الجزائر)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-EG', languageCode: 'ar', countryCode: 'EG', englishName: 'Arabic (Egypt)', nativeName: 'العربية (مصر)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-IQ', languageCode: 'ar', countryCode: 'IQ', englishName: 'Arabic (Iraq)', nativeName: 'العربية (العراق)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-JO', languageCode: 'ar', countryCode: 'JO', englishName: 'Arabic (Jordan)', nativeName: 'العربية (الأردن)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-KW', languageCode: 'ar', countryCode: 'KW', englishName: 'Arabic (Kuwait)', nativeName: 'العربية (الكويت)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-LB', languageCode: 'ar', countryCode: 'LB', englishName: 'Arabic (Lebanon)', nativeName: 'العربية (لبنان)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-LY', languageCode: 'ar', countryCode: 'LY', englishName: 'Arabic (Libya)', nativeName: 'العربية (ليبيا)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-MA', languageCode: 'ar', countryCode: 'MA', englishName: 'Arabic (Morocco)', nativeName: 'العربية (المغرب)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-OM', languageCode: 'ar', countryCode: 'OM', englishName: 'Arabic (Oman)', nativeName: 'العربية (عُمان)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-QA', languageCode: 'ar', countryCode: 'QA', englishName: 'Arabic (Qatar)', nativeName: 'العربية (قطر)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-SA', languageCode: 'ar', countryCode: 'SA', englishName: 'Arabic (Saudi Arabia)', nativeName: 'العربية (السعودية)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-SY', languageCode: 'ar', countryCode: 'SY', englishName: 'Arabic (Syria)', nativeName: 'العربية (سوريا)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-TN', languageCode: 'ar', countryCode: 'TN', englishName: 'Arabic (Tunisia)', nativeName: 'العربية (تونس)', category: LocaleCategory.global, isRtl: true),
    PolitiaLocaleMetadata(tag: 'ar-YE', languageCode: 'ar', countryCode: 'YE', englishName: 'Arabic (Yemen)', nativeName: 'العربية (اليمن)', category: LocaleCategory.global, isRtl: true),

    // Spanish (20 Locales)
    PolitiaLocaleMetadata(tag: 'es-AR', languageCode: 'es', countryCode: 'AR', englishName: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-BO', languageCode: 'es', countryCode: 'BO', englishName: 'Spanish (Bolivia)', nativeName: 'Español (Bolivia)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-CL', languageCode: 'es', countryCode: 'CL', englishName: 'Spanish (Chile)', nativeName: 'Español (Chile)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-CO', languageCode: 'es', countryCode: 'CO', englishName: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-CR', languageCode: 'es', countryCode: 'CR', englishName: 'Spanish (Costa Rica)', nativeName: 'Español (Costa Rica)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-DO', languageCode: 'es', countryCode: 'DO', englishName: 'Spanish (Dominican Republic)', nativeName: 'Español (República Dominicana)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-EC', languageCode: 'es', countryCode: 'EC', englishName: 'Spanish (Ecuador)', nativeName: 'Español (Ecuador)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-ES', languageCode: 'es', countryCode: 'ES', englishName: 'Spanish (Spain)', nativeName: 'Español (España)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-GT', languageCode: 'es', countryCode: 'GT', englishName: 'Spanish (Guatemala)', nativeName: 'Español (Guatemala)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-HN', languageCode: 'es', countryCode: 'HN', englishName: 'Spanish (Honduras)', nativeName: 'Español (Honduras)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-MX', languageCode: 'es', countryCode: 'MX', englishName: 'Spanish (Mexico)', nativeName: 'Español (México)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-NI', languageCode: 'es', countryCode: 'NI', englishName: 'Spanish (Nicaragua)', nativeName: 'Español (Nicaragua)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-PA', languageCode: 'es', countryCode: 'PA', englishName: 'Spanish (Panama)', nativeName: 'Español (Panamá)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-PE', languageCode: 'es', countryCode: 'PE', englishName: 'Spanish (Peru)', nativeName: 'Español (Perú)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-PR', languageCode: 'es', countryCode: 'PR', englishName: 'Spanish (Puerto Rico)', nativeName: 'Español (Puerto Rico)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-PY', languageCode: 'es', countryCode: 'PY', englishName: 'Spanish (Paraguay)', nativeName: 'Español (Paraguay)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-SV', languageCode: 'es', countryCode: 'SV', englishName: 'Spanish (El Salvador)', nativeName: 'Español (El Salvador)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-US', languageCode: 'es', countryCode: 'US', englishName: 'Spanish (United States)', nativeName: 'Español (Estados Unidos)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-UY', languageCode: 'es', countryCode: 'UY', englishName: 'Spanish (Uruguay)', nativeName: 'Español (Uruguay)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'es-VE', languageCode: 'es', countryCode: 'VE', englishName: 'Spanish (Venezuela)', nativeName: 'Español (Venezuela)', category: LocaleCategory.global),

    // English (9 Locales)
    PolitiaLocaleMetadata(tag: 'en-AU', languageCode: 'en', countryCode: 'AU', englishName: 'English (Australia)', nativeName: 'English (Australia)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-CA', languageCode: 'en', countryCode: 'CA', englishName: 'English (Canada)', nativeName: 'English (Canada)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-GB', languageCode: 'en', countryCode: 'GB', englishName: 'English (United Kingdom)', nativeName: 'English (UK)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-IE', languageCode: 'en', countryCode: 'IE', englishName: 'English (Ireland)', nativeName: 'English (Ireland)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-IN', languageCode: 'en', countryCode: 'IN', englishName: 'English (India)', nativeName: 'English (India)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-NZ', languageCode: 'en', countryCode: 'NZ', englishName: 'English (New Zealand)', nativeName: 'English (New Zealand)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-SG', languageCode: 'en', countryCode: 'SG', englishName: 'English (Singapore)', nativeName: 'English (Singapore)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-US', languageCode: 'en', countryCode: 'US', englishName: 'English (United States)', nativeName: 'English (US)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'en-ZA', languageCode: 'en', countryCode: 'ZA', englishName: 'English (South Africa)', nativeName: 'English (South Africa)', category: LocaleCategory.global),

    // French (5 Locales)
    PolitiaLocaleMetadata(tag: 'fr-BE', languageCode: 'fr', countryCode: 'BE', englishName: 'French (Belgium)', nativeName: 'Français (Belgique)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'fr-CA', languageCode: 'fr', countryCode: 'CA', englishName: 'French (Canada)', nativeName: 'Français (Canada)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'fr-CH', languageCode: 'fr', countryCode: 'CH', englishName: 'French (Switzerland)', nativeName: 'Français (Suisse)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'fr-FR', languageCode: 'fr', countryCode: 'FR', englishName: 'French (France)', nativeName: 'Français (France)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'fr-LU', languageCode: 'fr', countryCode: 'LU', englishName: 'French (Luxembourg)', nativeName: 'Français (Luxembourg)', category: LocaleCategory.global),

    // Chinese (4 Locales)
    PolitiaLocaleMetadata(tag: 'zh-CN', languageCode: 'zh', countryCode: 'CN', scriptCode: 'Hans', englishName: 'Chinese (Simplified, China)', nativeName: '简体中文 (中国)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'zh-HK', languageCode: 'zh', countryCode: 'HK', scriptCode: 'Hant', englishName: 'Chinese (Traditional, Hong Kong)', nativeName: '繁體中文 (香港)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'zh-SG', languageCode: 'zh', countryCode: 'SG', scriptCode: 'Hans', englishName: 'Chinese (Simplified, Singapore)', nativeName: '简体中文 (新加坡)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'zh-TW', languageCode: 'zh', countryCode: 'TW', scriptCode: 'Hant', englishName: 'Chinese (Traditional, Taiwan)', nativeName: '繁體中文 (台灣)', category: LocaleCategory.global),

    // German (3 Locales)
    PolitiaLocaleMetadata(tag: 'de-AT', languageCode: 'de', countryCode: 'AT', englishName: 'German (Austria)', nativeName: 'Deutsch (Österreich)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'de-CH', languageCode: 'de', countryCode: 'CH', englishName: 'German (Switzerland)', nativeName: 'Deutsch (Schweiz)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'de-DE', languageCode: 'de', countryCode: 'DE', englishName: 'German (Germany)', nativeName: 'Deutsch (Deutschland)', category: LocaleCategory.global),

    // Portuguese (2 Locales)
    PolitiaLocaleMetadata(tag: 'pt-BR', languageCode: 'pt', countryCode: 'BR', englishName: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'pt-PT', languageCode: 'pt', countryCode: 'PT', englishName: 'Portuguese (Portugal)', nativeName: 'Português (Portugal)', category: LocaleCategory.global),

    // Italian (2 Locales)
    PolitiaLocaleMetadata(tag: 'it-CH', languageCode: 'it', countryCode: 'CH', englishName: 'Italian (Switzerland)', nativeName: 'Italiano (Svizzera)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'it-IT', languageCode: 'it', countryCode: 'IT', englishName: 'Italian (Italy)', nativeName: 'Italiano (Italia)', category: LocaleCategory.global),

    // Dutch (2 Locales)
    PolitiaLocaleMetadata(tag: 'nl-BE', languageCode: 'nl', countryCode: 'BE', englishName: 'Dutch (Belgium)', nativeName: 'Nederlands (België)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'nl-NL', languageCode: 'nl', countryCode: 'NL', englishName: 'Dutch (Netherlands)', nativeName: 'Nederlands (Nederland)', category: LocaleCategory.global),

    // Bengali & Tamil (4 Locales)
    PolitiaLocaleMetadata(tag: 'bn-BD', languageCode: 'bn', countryCode: 'BD', englishName: 'Bengali (Bangladesh)', nativeName: 'বাংলা (বাংলাদেশ)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'bn-IN', languageCode: 'bn', countryCode: 'IN', englishName: 'Bengali (India)', nativeName: 'বাংলা (ভারত)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'ta-IN', languageCode: 'ta', countryCode: 'IN', englishName: 'Tamil (India)', nativeName: 'தமிழ் (இந்தியா)', category: LocaleCategory.global),
    PolitiaLocaleMetadata(tag: 'ta-LK', languageCode: 'ta', countryCode: 'LK', englishName: 'Tamil (Sri Lanka)', nativeName: 'தமிழ் (இலங்கை)', category: LocaleCategory.global),

    // 3. European & Regional Locales (34)
    PolitiaLocaleMetadata(tag: 'af-ZA', languageCode: 'af', countryCode: 'ZA', englishName: 'Afrikaans (South Africa)', nativeName: 'Afrikaans (Suid-Afrika)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'sq-AL', languageCode: 'sq', countryCode: 'AL', englishName: 'Albanian (Albania)', nativeName: 'Shqip (Shqipëri)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'hy-AM', languageCode: 'hy', countryCode: 'AM', englishName: 'Armenian (Armenia)', nativeName: 'Հայերեն (Հայաստան)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'az-AZ', languageCode: 'az', countryCode: 'AZ', englishName: 'Azerbaijani (Azerbaijan)', nativeName: 'Azərbaycan (Azərbaycan)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'eu-ES', languageCode: 'eu', countryCode: 'ES', englishName: 'Basque (Spain)', nativeName: 'Euskara (Espainia)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'be-BY', languageCode: 'be', countryCode: 'BY', englishName: 'Belarusian (Belarus)', nativeName: 'Беларуская (Беларусь)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'bs-BA', languageCode: 'bs', countryCode: 'BA', englishName: 'Bosnian (Bosnia & Herzegovina)', nativeName: 'Bosanski (Bosna i Hercegovina)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'bg-BG', languageCode: 'bg', countryCode: 'BG', englishName: 'Bulgarian (Bulgaria)', nativeName: 'Български (България)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'ca-ES', languageCode: 'ca', countryCode: 'ES', englishName: 'Catalan (Spain)', nativeName: 'Català (Espanya)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'hr-HR', languageCode: 'hr', countryCode: 'HR', englishName: 'Croatian (Croatia)', nativeName: 'Hrvatski (Hrvatska)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'cs-CZ', languageCode: 'cs', countryCode: 'CZ', englishName: 'Czech (Czechia)', nativeName: 'Čeština (Česko)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'da-DK', languageCode: 'da', countryCode: 'DK', englishName: 'Danish (Denmark)', nativeName: 'Dansk (Danmark)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'et-EE', languageCode: 'et', countryCode: 'EE', englishName: 'Estonian (Estonia)', nativeName: 'Eesti (Eesti)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'fi-FI', languageCode: 'fi', countryCode: 'FI', englishName: 'Finnish (Finland)', nativeName: 'Suomi (Suomi)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'gl-ES', languageCode: 'gl', countryCode: 'ES', englishName: 'Galician (Spain)', nativeName: 'Galego (España)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'ka-GE', languageCode: 'ka', countryCode: 'GE', englishName: 'Georgian (Georgia)', nativeName: 'ქართული (საქართველო)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'el-GR', languageCode: 'el', countryCode: 'GR', englishName: 'Greek (Greece)', nativeName: 'Ελληνικά (Ελλάδα)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'hu-HU', languageCode: 'hu', countryCode: 'HU', englishName: 'Hungarian (Hungary)', nativeName: 'Magyar (Magyarország)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'is-IS', languageCode: 'is', countryCode: 'IS', englishName: 'Icelandic (Iceland)', nativeName: 'Íslenska (Ísland)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'lv-LV', languageCode: 'lv', countryCode: 'LV', englishName: 'Latvian (Latvia)', nativeName: 'Latviešu (Latvija)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'lt-LT', languageCode: 'lt', countryCode: 'LT', englishName: 'Lithuanian (Lithuania)', nativeName: 'Lietuvių (Lietuva)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'mk-MK', languageCode: 'mk', countryCode: 'MK', englishName: 'Macedonian (North Macedonia)', nativeName: 'Македонски (Северна Македонија)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'nb-NO', languageCode: 'nb', countryCode: 'NO', englishName: 'Norwegian Bokmål (Norway)', nativeName: 'Norsk bokmål (Norge)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'pl-PL', languageCode: 'pl', countryCode: 'PL', englishName: 'Polish (Poland)', nativeName: 'Polski (Polska)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'ro-RO', languageCode: 'ro', countryCode: 'RO', englishName: 'Romanian (Romania)', nativeName: 'Română (România)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'ru-RU', languageCode: 'ru', countryCode: 'RU', englishName: 'Russian (Russia)', nativeName: 'Русский (Россия)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'sr-RS', languageCode: 'sr', countryCode: 'RS', englishName: 'Serbian (Serbia)', nativeName: 'Српски (Србија)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'sk-SK', languageCode: 'sk', countryCode: 'SK', englishName: 'Slovak (Slovakia)', nativeName: 'Slovenčina (Slovensko)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'sl-SI', languageCode: 'sl', countryCode: 'SI', englishName: 'Slovenian (Slovenia)', nativeName: 'Slovenščina (Slovenija)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'sv-SE', languageCode: 'sv', countryCode: 'SE', englishName: 'Swedish (Sweden)', nativeName: 'Svenska (Sverige)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'tr-TR', languageCode: 'tr', countryCode: 'TR', englishName: 'Turkish (Turkey)', nativeName: 'Türkçe (Türkiye)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'uk-UA', languageCode: 'uk', countryCode: 'UA', englishName: 'Ukrainian (Ukraine)', nativeName: 'Українська (Україна)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'uz-UZ', languageCode: 'uz', countryCode: 'UZ', englishName: 'Uzbek (Uzbekistan)', nativeName: 'Oʻzbekcha (Oʻzbekiston)', category: LocaleCategory.european),
    PolitiaLocaleMetadata(tag: 'cy-GB', languageCode: 'cy', countryCode: 'GB', englishName: 'Welsh (United Kingdom)', nativeName: 'Cymraeg (Y Deyrnas Unedig)', category: LocaleCategory.european),

    // 4. Asian, Middle Eastern & African Locales (28)
    PolitiaLocaleMetadata(tag: 'am-ET', languageCode: 'am', countryCode: 'ET', englishName: 'Amharic (Ethiopia)', nativeName: 'አማርኛ (ኢትዮጵያ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'my-MM', languageCode: 'my', countryCode: 'MM', englishName: 'Burmese (Myanmar)', nativeName: 'မြန်မာ (မြန်မာ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'fil-PH', languageCode: 'fil', countryCode: 'PH', englishName: 'Filipino (Philippines)', nativeName: 'Filipino (Pilipinas)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'gu-IN', languageCode: 'gu', countryCode: 'IN', englishName: 'Gujarati (India)', nativeName: 'ગુજરાતી (ભારત)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'he-IL', languageCode: 'he', countryCode: 'IL', englishName: 'Hebrew (Israel)', nativeName: 'עברית (ישראל)', category: LocaleCategory.asianAfrican, isRtl: true),
    PolitiaLocaleMetadata(tag: 'hi-IN', languageCode: 'hi', countryCode: 'IN', englishName: 'Hindi (India)', nativeName: 'हिन्दी (भारत)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'id-ID', languageCode: 'id', countryCode: 'ID', englishName: 'Indonesian (Indonesia)', nativeName: 'Bahasa Indonesia (Indonesia)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ja-JP', languageCode: 'ja', countryCode: 'JP', englishName: 'Japanese (Japan)', nativeName: '日本語 (日本)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'kn-IN', languageCode: 'kn', countryCode: 'IN', englishName: 'Kannada (India)', nativeName: 'ಕನ್ನಡ (ಭಾರತ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'kk-KZ', languageCode: 'kk', countryCode: 'KZ', englishName: 'Kazakh (Kazakhstan)', nativeName: 'Қазақ тілі (Қазақстан)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'km-KH', languageCode: 'km', countryCode: 'KH', englishName: 'Khmer (Cambodia)', nativeName: 'ភាសាខ្មែរ (កម្ពុជា)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ko-KR', languageCode: 'ko', countryCode: 'KR', englishName: 'Korean (South Korea)', nativeName: '한국어 (대한민국)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'lo-LA', languageCode: 'lo', countryCode: 'LA', englishName: 'Lao (Laos)', nativeName: 'ລາວ (ລາວ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ms-MY', languageCode: 'ms', countryCode: 'MY', englishName: 'Malay (Malaysia)', nativeName: 'Bahasa Melayu (Malaysia)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ml-IN', languageCode: 'ml', countryCode: 'IN', englishName: 'Malayalam (India)', nativeName: 'മലയാളം (ഇന്ത്യ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'mr-IN', languageCode: 'mr', countryCode: 'IN', englishName: 'Marathi (India)', nativeName: 'मराठी (भारत)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'mn-MN', languageCode: 'mn', countryCode: 'MN', englishName: 'Mongolian (Mongolia)', nativeName: 'Монгол (Монгол)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ne-NP', languageCode: 'ne', countryCode: 'NP', englishName: 'Nepali (Nepal)', nativeName: 'नेपाली (नेपाल)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'fa-IR', languageCode: 'fa', countryCode: 'IR', englishName: 'Persian (Iran)', nativeName: 'فارسی (ایران)', category: LocaleCategory.asianAfrican, isRtl: true),
    PolitiaLocaleMetadata(tag: 'pa-IN', languageCode: 'pa', countryCode: 'IN', englishName: 'Punjabi (India)', nativeName: 'ਪੰਜਾਬੀ (ਭਾਰਤ)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'si-LK', languageCode: 'si', countryCode: 'LK', englishName: 'Sinhala (Sri Lanka)', nativeName: 'සිංහල (ශ්‍රී ලංකාව)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'sw-KE', languageCode: 'sw', countryCode: 'KE', englishName: 'Swahili (Kenya)', nativeName: 'Kiswahili (Kenya)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'te-IN', languageCode: 'te', countryCode: 'IN', englishName: 'Telugu (India)', nativeName: 'తెలుగు (భారతదేశം)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'th-TH', languageCode: 'th', countryCode: 'TH', englishName: 'Thai (Thailand)', nativeName: 'ไทย (ไทย)', category: LocaleCategory.asianAfrican),
    PolitiaLocaleMetadata(tag: 'ur-PK', languageCode: 'ur', countryCode: 'PK', englishName: 'Urdu (Pakistan)', nativeName: 'اردو (پاکستان)', category: LocaleCategory.asianAfrican, isRtl: true),
    PolitiaLocaleMetadata(tag: 'vi-VN', languageCode: 'vi', countryCode: 'VN', englishName: 'Vietnamese (Vietnam)', nativeName: 'Tiếng Việt (Việt Nam)', category: LocaleCategory.asianAfrican),
  ];

  static PolitiaLocaleMetadata? findByTag(String tag) {
    for (final loc in all) {
      if (loc.tag.toLowerCase() == tag.toLowerCase() ||
          loc.tag.replaceAll('-', '_').toLowerCase() == tag.replaceAll('-', '_').toLowerCase()) {
        return loc;
      }
    }
    return null;
  }

  static PolitiaLocaleMetadata? findByLocale(Locale? locale) {
    if (locale == null) return null;
    for (final loc in all) {
      if (loc.languageCode == locale.languageCode) {
        if (loc.countryCode != null && loc.countryCode != locale.countryCode) {
          continue;
        }
        if (loc.scriptCode != null && loc.scriptCode != locale.scriptCode) {
          continue;
        }
        return loc;
      }
    }
    return null;
  }
}

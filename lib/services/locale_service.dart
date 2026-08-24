import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dynamic locale service managing application locale state, fallback resolution, and persistence.
class LocaleService extends ChangeNotifier {
  LocaleService._internal();
  static final LocaleService instance = LocaleService._internal();

  static const String _prefKeyLanguageCode = 'politia_selected_language_code';
  static const String _prefKeyCountryCode = 'politia_selected_country_code';
  static const String _prefKeyScriptCode = 'politia_selected_script_code';

  Locale? _currentLocale;

  /// Current active user-selected locale. If null, the app falls back to the system locale.
  Locale? get currentLocale => _currentLocale;

  /// List of RTL language codes
  static const Set<String> rtlLanguageCodes = {
    'ar', // Arabic
    'fa', // Persian
    'he', // Hebrew
    'ur', // Urdu
    'ps', // Pashto
    'sd', // Sindhi
    'ug', // Uyghur
    'yi', // Yiddish
    'syc', // Classical Syriac
    'arc', // Aramaic
  };

  /// Whether the active locale uses Right-to-Left (RTL) text direction.
  bool isRtl(BuildContext context) {
    final activeLocale = _currentLocale ?? Localizations.localeOf(context);
    return rtlLanguageCodes.contains(activeLocale.languageCode.toLowerCase());
  }

  /// Resolves the effective locale with multi-tiered fallback:
  /// 1. Exact match (Language + Country + Script)
  /// 2. Language + Script match
  /// 3. Language only match (Generic base)
  /// 4. Fallback to English (en)
  Locale resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return const Locale('en');

    // 1. Exact match
    for (final supported in supportedLocales) {
      if (supported == locale) {
        return supported;
      }
    }

    // 2. Language + Script match
    if (locale.scriptCode != null) {
      for (final supported in supportedLocales) {
        if (supported.languageCode == locale.languageCode &&
            supported.scriptCode == locale.scriptCode) {
          return supported;
        }
      }
    }

    // 3. Base language match (Generic fallback e.g. ar_EG -> ar)
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode &&
          supported.countryCode == null &&
          supported.scriptCode == null) {
        return supported;
      }
    }

    // 4. Any dialect with same base language
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }

    // 5. Ultimate fallback
    return const Locale('en');
  }

  /// Loads the persisted locale from [SharedPreferences].
  Future<void> loadPersistedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_prefKeyLanguageCode);
      final countryCode = prefs.getString(_prefKeyCountryCode);
      final scriptCode = prefs.getString(_prefKeyScriptCode);

      if (languageCode != null && languageCode.isNotEmpty) {
        _currentLocale = Locale.fromSubtags(
          languageCode: languageCode,
          countryCode: (countryCode != null && countryCode.isNotEmpty) ? countryCode : null,
          scriptCode: (scriptCode != null && scriptCode.isNotEmpty) ? scriptCode : null,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[LocaleService] Error loading persisted locale: $e');
    }
  }

  /// Sets a new locale and persists it in [SharedPreferences].
  Future<void> setLocale(Locale? locale) async {
    _currentLocale = locale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_prefKeyLanguageCode);
        await prefs.remove(_prefKeyCountryCode);
        await prefs.remove(_prefKeyScriptCode);
      } else {
        await prefs.setString(_prefKeyLanguageCode, locale.languageCode);
        if (locale.countryCode != null) {
          await prefs.setString(_prefKeyCountryCode, locale.countryCode!);
        } else {
          await prefs.remove(_prefKeyCountryCode);
        }
        if (locale.scriptCode != null) {
          await prefs.setString(_prefKeyScriptCode, locale.scriptCode!);
        } else {
          await prefs.remove(_prefKeyScriptCode);
        }
      }
    } catch (e) {
      debugPrint('[LocaleService] Error persisting locale: $e');
    }
  }
}

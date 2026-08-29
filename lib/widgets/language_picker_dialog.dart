import 'package:flutter/material.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/services/locale_service.dart';

class _LanguageOption {
  final String flag;
  final String title;
  final String subtitle;
  final Locale locale;
  final String code;

  const _LanguageOption({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.code,
  });
}

/// Clean scrollable language selection bottom sheet with 7 curated languages.
class LanguageSelectionSheet extends StatelessWidget {
  const LanguageSelectionSheet({super.key});

  static const List<_LanguageOption> _languages = [
    _LanguageOption(
      flag: '🇬🇧',
      title: 'English',
      subtitle: 'English',
      locale: Locale('en'),
      code: 'en',
    ),
    _LanguageOption(
      flag: '🇪🇬',
      title: 'العربية',
      subtitle: 'Arabic',
      locale: Locale('ar'),
      code: 'ar',
    ),
    _LanguageOption(
      flag: '🇫🇷',
      title: 'Français',
      subtitle: 'French',
      locale: Locale('fr'),
      code: 'fr',
    ),
    _LanguageOption(
      flag: '🇮🇹',
      title: 'Italiano',
      subtitle: 'Italian',
      locale: Locale('it'),
      code: 'it',
    ),
    _LanguageOption(
      flag: '🇩🇪',
      title: 'Deutsch',
      subtitle: 'German',
      locale: Locale('de'),
      code: 'de',
    ),
    _LanguageOption(
      flag: '🇪🇸',
      title: 'Español',
      subtitle: 'Spanish',
      locale: Locale('es'),
      code: 'es',
    ),
    _LanguageOption(
      flag: '☦️',
      title: 'Ⲕⲟⲡⲧⲓ',
      subtitle: 'Coptic',
      locale: Locale('cop'),
      code: 'cop',
    ),
  ];

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguageSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentCode = LocaleService.instance.currentLocale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.70,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161513) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF2A2722) : colors.border,
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Header: Drag Handle & Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle at top
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3A3732)
                          : Colors.grey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title: Localized "SELECT LANGUAGE"
                  Text(
                    AppLocalizations.of(context).selectLanguage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable List of Language Option Cards
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _languages.map((lang) {
                    final isSelected = currentCode == lang.code;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildLanguageCard(
                        context: context,
                        flag: lang.flag,
                        title: lang.title,
                        subtitle: lang.subtitle,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () {
                          LocaleService.instance.setLocale(lang.locale);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String flag,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    const goldColor = Color(0xFFB8960C);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? goldColor.withValues(alpha: isDark ? 0.12 : 0.08)
                : (isDark ? const Color(0xFF1C1A17) : const Color(0xFFFAFAFA)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? goldColor
                  : (isDark ? const Color(0xFF2A2722) : const Color(0xFFE5E0D8)),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Flag Emoji / Symbol
              Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? goldColor : colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Gold checkmark if selected
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: goldColor,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

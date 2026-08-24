import 'package:flutter/material.dart';
import 'package:politia/services/locale_service.dart';

/// Reusable Language Picker button for Authentication Screens.
class AuthLanguagePicker extends StatelessWidget {
  const AuthLanguagePicker({super.key});

  bool _isSelected(Locale? itemLocale) {
    final currentLocale = LocaleService.instance.currentLocale;
    if (currentLocale == null && itemLocale == null) return true;
    if (currentLocale == null || itemLocale == null) return false;
    return currentLocale.languageCode == itemLocale.languageCode &&
        currentLocale.countryCode == itemLocale.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<Locale?>(
        icon: Icon(
          Icons.more_horiz_rounded,
          color: isDark ? Colors.white70 : const Color(0xFF1F2937),
          size: 24,
        ),
        tooltip: 'Change Language / إعدادات اللغة',
        initialValue: LocaleService.instance.currentLocale,
        onSelected: (Locale? locale) {
          LocaleService.instance.setLocale(locale);
        },
        itemBuilder: (BuildContext context) => [
          // System Default
          _buildMenuItem(
            null,
            'إعدادات النظام / System Default',
          ),

          // English Variants
          _buildMenuItem(
            const Locale('en'),
            'English (Base)',
          ),
          _buildMenuItem(
            const Locale('en', 'US'),
            'English (US)',
          ),
          _buildMenuItem(
            const Locale('en', 'GB'),
            'English (UK)',
          ),

          // Arabic Variants
          _buildMenuItem(
            const Locale('ar'),
            'العربية (عام)',
          ),
          _buildMenuItem(
            const Locale('ar', 'EG'),
            'العربية (مصر)',
          ),
          _buildMenuItem(
            const Locale('ar', 'SA'),
            'العربية (السعودية)',
          ),

          // French Variants
          _buildMenuItem(
            const Locale('fr'),
            'Français',
          ),
          _buildMenuItem(
            const Locale('fr', 'FR'),
            'Français (France)',
          ),

          // Coptic Variants
          _buildMenuItem(
            const Locale('cop'),
            'Ϯⲁⲥⲡⲓ ⲛ̀ⲣⲉⲙⲛ̀ⲭⲏⲙⲓ',
          ),
          _buildMenuItem(
            const Locale('cop', 'EG'),
            'Ϯⲁⲥⲡⲓ ⲛ̀ⲣⲉⲙⲛ̀ⲭⲏⲙⲓ (Ⲭⲏⲙⲓ)',
          ),
        ],
      ),
    );
  }

  PopupMenuItem<Locale?> _buildMenuItem(
    Locale? locale,
    String label,
  ) {
    final active = _isSelected(locale);

    return PopupMenuItem<Locale?>(
      value: locale,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? const Color(0xFFB45309) : null,
              ),
            ),
          ),
          if (active)
            const Icon(
              Icons.check_rounded,
              size: 18,
              color: Color(0xFFB45309),
            ),
        ],
      ),
    );
  }
}

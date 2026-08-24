import 'package:flutter/material.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'services/locale_service.dart';

/// Single minimal screen for Politia confirming cross-platform engine and localization.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Evaluates whether the given [itemLocale] is the single active user selection.
  bool _isSelected(Locale? itemLocale) {
    final currentLocale = LocaleService.instance.currentLocale;
    if (currentLocale == null && itemLocale == null) return true;
    if (currentLocale == null || itemLocale == null) return false;
    return currentLocale.languageCode == itemLocale.languageCode &&
        currentLocale.countryCode == itemLocale.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale?>(
            icon: const Icon(Icons.language),
            tooltip: l10n.changeLanguage,
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
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeMessage,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.statusRunning,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                color: active ? Colors.blueAccent : null,
              ),
            ),
          ),
          if (active)
            const Icon(
              Icons.check,
              size: 18,
              color: Colors.blueAccent,
            ),
        ],
      ),
    );
  }
}

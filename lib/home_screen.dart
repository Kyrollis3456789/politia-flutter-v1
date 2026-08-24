import 'package:flutter/material.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'services/locale_service.dart';

/// Single minimal screen for Politia confirming cross-platform engine and localization.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeLocale = LocaleService.instance.currentLocale ??
        Localizations.localeOf(context);

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
              const PopupMenuItem<Locale?>(
                value: null,
                child: Text('🌐 System Default'),
              ),
              const PopupMenuDivider(),

              // English Group
              _buildLocaleItem(
                const Locale('en'),
                'English (Generic / LTR)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('en', 'US'),
                'English (United States)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('en', 'GB'),
                'English (United Kingdom)',
                activeLocale,
              ),
              const PopupMenuDivider(),

              // Arabic Group (RTL)
              _buildLocaleItem(
                const Locale('ar'),
                'العربية (Generic / RTL)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('ar', 'EG'),
                'العربية (مصر / Egypt)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('ar', 'SA'),
                'العربية (السعودية / Saudi)',
                activeLocale,
              ),
              const PopupMenuDivider(),

              // French Group
              _buildLocaleItem(
                const Locale('fr'),
                'Français (Generic / LTR)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('fr', 'FR'),
                'Français (France)',
                activeLocale,
              ),
              const PopupMenuDivider(),

              // Coptic Group
              _buildLocaleItem(
                const Locale('cop'),
                'Ϯⲁⲥⲡⲓ ⲛ̀Ⲣⲉⲙⲛ̀Ⲭⲏⲙⲓ (Coptic Generic)',
                activeLocale,
              ),
              _buildLocaleItem(
                const Locale('cop', 'EG'),
                'Ϯⲁⲥⲡⲓ ⲛ̀Ⲣⲉⲙⲛ̀Ⲭⲏⲙⲓ (Ⲭⲏⲙⲓ / Egypt)',
                activeLocale,
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

  PopupMenuItem<Locale?> _buildLocaleItem(
    Locale locale,
    String label,
    Locale activeLocale,
  ) {
    final isSelected = activeLocale.languageCode == locale.languageCode &&
        (locale.countryCode == null || activeLocale.countryCode == locale.countryCode);

    return PopupMenuItem<Locale?>(
      value: locale,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (isSelected)
            const Icon(Icons.check, size: 18, color: Colors.blueAccent),
        ],
      ),
    );
  }
}

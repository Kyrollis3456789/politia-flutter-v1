import 'package:flutter/material.dart';
import 'package:politia/core/services/init_service.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/widgets/app_scaffold_wrapper.dart';
import 'package:politia/widgets/language_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dashboard screen for Politia showcasing semantic Antique Crimson & Gold theming,
/// Coptic background texture integration, auth state, and multi-language support.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);
    final user = SupabaseService.instance.currentUser;
    final userEmail = user?.email ?? 'Logged In User';

    return AppScaffoldWrapper(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language Switcher Modal Trigger
          IconButton(
            icon: Icon(Icons.language_rounded, color: colors.textPrimary),
            tooltip: l10n.changeLanguage,
            onPressed: () {
              LanguageSelectionSheet.show(context);
            },
          ),

          // Logout Action
          IconButton(
            icon: Icon(Icons.logout_rounded, color: colors.textPrimary),
            tooltip: 'Sign Out',
            onPressed: () async {
              await SupabaseService.instance.signOut();
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove(InitializationService.prefKeyUuid);
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.appTitle,
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome, $userEmail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeMessage,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colors.border,
                    width: 1.2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF16A34A),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l10n.statusRunning,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await SupabaseService.instance.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove(InitializationService.prefKeyUuid);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

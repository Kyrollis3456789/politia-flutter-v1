import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/features/auth/sign_in_screen.dart';
import 'package:politia/features/auth/sign_up_screen.dart';
import 'package:politia/features/splash/splash_screen.dart';
import 'package:politia/home_screen.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables safely
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('[Main] Note: .env file not found or failed to load, falling back to environment defaults: $e');
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
      const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://athyhvrbkonrekwzixyo.supabase.co',
      );

  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ??
      const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'sb_publishable_E_ITpADkkP-EgnQ5GsWqjA_dcEWozhH',
      );

  // Initialize Supabase backend service
  await SupabaseService.instance.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Load persisted user locale (or fallback to system locale)
  await LocaleService.instance.loadPersistedLocale();

  runApp(const PolitiaApp());
}

/// Root application widget for Politia.
class PolitiaApp extends StatelessWidget {
  const PolitiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Politia',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFFB45309),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFFB45309),
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system,

          // Dynamic Locale & Official Localization Wiring
          locale: LocaleService.instance.currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return LocaleService.instance.resolveLocale(deviceLocale, supportedLocales);
          },

          // Route Configuration
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/dashboard': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}

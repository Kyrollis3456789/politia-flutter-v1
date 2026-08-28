import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:politia/core/theme/app_themes.dart';
import 'package:politia/core/services/connectivity_service.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/features/auth/registration/multi_step_registration_screen.dart';
import 'package:politia/features/auth/sign_in_screen.dart';
import 'package:politia/features/splash/splash_screen.dart';
import 'package:politia/home_screen.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/widgets/network_status_banner_wrapper.dart';
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

  // Initialize global real-time connectivity & internet health service
  await ConnectivityService.instance.initialize();

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
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,

          // Dynamic Locale & Official Localization Wiring
          locale: LocaleService.instance.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            _FallbackMaterialLocalizationsDelegate(),
            _FallbackCupertinoLocalizationsDelegate(),
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return LocaleService.instance.resolveLocale(deviceLocale, supportedLocales);
          },

          // Global Overlay / Builder wrapping all routes with Network Status Banner
          builder: (context, child) {
            return NetworkStatusBannerWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },

          // Route Configuration
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const SignInScreen(),
            '/signup': (context) => const MultiStepRegistrationScreen(),
            '/dashboard': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}

/// Fallback localizations delegate ensuring languages not directly supported by Flutter's built-in
/// GlobalMaterialLocalizations (such as Coptic, Syriac, Aramaic) fallback cleanly to DefaultMaterialLocalizations
/// so TextFields and Material components never throw 'No MaterialLocalizations found'.
class _FallbackMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

/// Fallback Cupertino localizations delegate.
class _FallbackCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return const DefaultCupertinoLocalizations();
  }

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}



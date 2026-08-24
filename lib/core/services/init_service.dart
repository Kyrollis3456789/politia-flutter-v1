import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/services/locale_service.dart';

/// Core service executing the Politia app bootstrap and decision tree flow.
class InitializationService {
  InitializationService._internal();
  static final InitializationService instance = InitializationService._internal();

  static const String prefKeyUuid = 'uuid';
  static const String prefKeyThemeMode = 'politia_theme_mode';
  static const int minSplashDurationMs = 4000;

  /// Executes initialization with a minimum 4-second gatekeeper timer.
  /// Resolves to the appropriate route string: '/dashboard' or '/welcome'.
  Future<String> resolveInitialization([BuildContext? context]) async {
    final stopwatch = Stopwatch()..start();

    String targetRoute = '/welcome';

    try {
      final results = await Future.wait([
        _executeDecisionTree(),
        Future.delayed(const Duration(milliseconds: minSplashDurationMs)),
      ]);
      targetRoute = results.first as String;
    } catch (e) {
      debugPrint('[InitializationService] Error during bootstrap: $e');
      targetRoute = '/welcome';
    } finally {
      stopwatch.stop();
      debugPrint('[InitializationService] Initialization completed in ${stopwatch.elapsedMilliseconds}ms -> Route: $targetRoute');
    }

    return targetRoute;
  }

  /// Core Decision Tree implementation based on PolitiaInitializationFlow.
  Future<String> _executeDecisionTree() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUuid = prefs.getString(prefKeyUuid);

    // Ensure persisted locale is loaded into LocaleService
    await LocaleService.instance.loadPersistedLocale();

    // -------------------------------------------------------------------------
    // BRANCH A: Guest / Unauthenticated Flow (uuid == null)
    // -------------------------------------------------------------------------
    if (storedUuid == null || storedUuid.trim().isEmpty) {
      debugPrint('[InitializationService] Branch A: No UUID found. Initializing device defaults.');
      
      // If no custom locale was set, fallback to platform system locale
      if (LocaleService.instance.currentLocale == null) {
        final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
        debugPrint('[InitializationService] System locale detected: $systemLocale');
      }

      return '/welcome';
    }

    // -------------------------------------------------------------------------
    // BRANCH B: Existing User Flow (uuid != null)
    // -------------------------------------------------------------------------
    debugPrint('[InitializationService] Branch B: Verifying UUID: $storedUuid');

    try {
      // 1. Verify user profile in Supabase
      final response = await SupabaseService.instance.client
          .from('profiles')
          .select('id, full_name, role, preferred_language')
          .eq('id', storedUuid)
          .maybeSingle();

      if (response == null) {
        debugPrint('[InitializationService] Branch B: Profile not found in database. Resetting credentials.');
        await prefs.remove(prefKeyUuid);
        return '/welcome';
      }

      // 2. Profile verified - synchronize preferences if present
      final preferredLang = response['preferred_language'] as String?;
      if (preferredLang != null && preferredLang.isNotEmpty) {
        await LocaleService.instance.setLocale(Locale(preferredLang));
      }

      debugPrint('[InitializationService] Branch B: Verification successful for user: ${response['full_name'] ?? storedUuid}');
      return '/dashboard';
    } catch (e) {
      debugPrint('[InitializationService] Branch B: Supabase verification error ($e). Checking offline cache.');

      // In case of network error, check if local active session exists
      final currentSession = SupabaseService.instance.currentSession;
      if (currentSession != null && currentSession.user.id == storedUuid) {
        debugPrint('[InitializationService] Branch B: Active local session exists. Permitting offline dashboard access.');
        return '/dashboard';
      }

      // If cannot verify and no session, fallback safely
      return '/welcome';
    }
  }
}

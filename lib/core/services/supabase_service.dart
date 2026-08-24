import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton service responsible for initializing and wrapping Supabase operations.
class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService instance = SupabaseService._internal();

  /// Access to the underlying [SupabaseClient].
  SupabaseClient get client => Supabase.instance.client;

  /// Initializes Supabase client with given URL and publishable anon key.
  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    try {
      await Supabase.initialize(
        url: url,
        // ignore: deprecated_member_use
        anonKey: anonKey,
        debug: kDebugMode,
      );
      debugPrint('[SupabaseService] Initialized successfully for $url');
    } catch (e) {
      debugPrint('[SupabaseService] Initialization warning/error: $e');
    }
  }

  /// Convenience getter for the currently logged-in [User].
  User? get currentUser => client.auth.currentUser;

  /// Convenience getter for current active [Session].
  Session? get currentSession => client.auth.currentSession;

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// Signs in a user using Email and Password.
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Signs up a new user using Email and Password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Signs out the current user session.
  Future<void> signOut() async {
    await client.auth.signOut();
  }
}

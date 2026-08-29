import 'package:flutter/foundation.dart';
import 'package:politia/utils/input_detector.dart';
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

  /// Queries the `profiles` table to check if a user with the given [identity]
  /// (email, primary phone, secondary phone, or member ID) exists.
  Future<bool> checkUserExists(String identity) async {
    final cleanIdentity = identity.trim();
    if (cleanIdentity.isEmpty) return false;

    try {
      // 1. Check if input is a Member ID (^00\d{9}$)
      if (InputDetector.detect(cleanIdentity) == InputType.memberId) {
        final res = await client
            .from('profiles')
            .select('id')
            .eq('member_id', cleanIdentity)
            .maybeSingle();
        return res != null;
      }

      // 2. First attempt RPC if available
      final rpcRes = await client.rpc('lookup_profile_by_identity', params: {
        'identity_input': cleanIdentity,
      });

      if (rpcRes != null) return true;

      // 3. Fallback query directly against profiles table
      final isEmail = cleanIdentity.contains('@');
      var query = client.from('profiles').select('id');

      if (isEmail) {
        final res = await query.ilike('email', cleanIdentity).maybeSingle();
        return res != null;
      } else {
        // Strip country code or normalize leading zero for phone lookup
        final rawDigits = cleanIdentity.replaceAll(RegExp(r'\D'), '');
        final withPlus = rawDigits.startsWith('20') ? '+$rawDigits' : '+20$rawDigits';
        final localFormat = rawDigits.startsWith('20') ? '0${rawDigits.substring(2)}' : (rawDigits.startsWith('0') ? rawDigits : '0$rawDigits');

        final res = await client
            .from('profiles')
            .select('id')
            .or('phone_number_primary.eq.$withPlus,phone_number_primary.eq.$localFormat,phone_number_secondary.eq.$withPlus,phone_number_secondary.eq.$localFormat,phone.eq.$withPlus,phone.eq.$localFormat')
            .maybeSingle();

        return res != null;
      }
    } catch (e) {
      debugPrint('[SupabaseService] checkUserExists error: $e');
      return false;
    }
  }

  /// Retrieves user profile data for [identity] to display in the profile preview card.
  Future<Map<String, dynamic>?> fetchProfileData(String identity) async {
    final cleanIdentity = identity.trim();
    if (cleanIdentity.isEmpty) return null;

    try {
      // 1. Check if input is a Member ID
      if (InputDetector.detect(cleanIdentity) == InputType.memberId) {
        final res = await client
            .from('profiles')
            .select('id, full_name, full_name_en, full_name_ar, avatar_url, profile_picture_url, phone_number_primary, phone, email, member_id')
            .eq('member_id', cleanIdentity)
            .maybeSingle();
        return res != null ? Map<String, dynamic>.from(res) : null;
      }

      // 2. First attempt RPC
      final rpcRes = await client.rpc('lookup_profile_by_identity', params: {
        'identity_input': cleanIdentity,
      });

      if (rpcRes != null && rpcRes is Map) {
        return Map<String, dynamic>.from(rpcRes);
      }

      // 3. Fallback query
      final isEmail = cleanIdentity.contains('@');
      if (isEmail) {
        final res = await client
            .from('profiles')
            .select('id, full_name, full_name_en, full_name_ar, avatar_url, profile_picture_url, phone_number_primary, phone, email, member_id')
            .ilike('email', cleanIdentity)
            .maybeSingle();
        return res != null ? Map<String, dynamic>.from(res) : null;
      } else {
        final rawDigits = cleanIdentity.replaceAll(RegExp(r'\D'), '');
        final withPlus = rawDigits.startsWith('20') ? '+$rawDigits' : '+20$rawDigits';
        final localFormat = rawDigits.startsWith('20') ? '0${rawDigits.substring(2)}' : (rawDigits.startsWith('0') ? rawDigits : '0$rawDigits');

        final res = await client
            .from('profiles')
            .select('id, full_name, full_name_en, full_name_ar, avatar_url, profile_picture_url, phone_number_primary, phone, email, member_id')
            .or('phone_number_primary.eq.$withPlus,phone_number_primary.eq.$localFormat,phone_number_secondary.eq.$withPlus,phone_number_secondary.eq.$localFormat,phone.eq.$withPlus,phone.eq.$localFormat')
            .maybeSingle();

        return res != null ? Map<String, dynamic>.from(res) : null;
      }
    } catch (e) {
      debugPrint('[SupabaseService] fetchProfileData error: $e');
      return null;
    }
  }

  /// Sends a one-time passcode (OTP) to [identity] (Email or SMS phone number).
  Future<void> sendOtp(String identity) async {
    final clean = identity.trim();
    if (clean.contains('@')) {
      await client.auth.signInWithOtp(email: clean);
    } else {
      final rawDigits = clean.replaceAll(RegExp(r'\D'), '');
      final formattedPhone = rawDigits.startsWith('20') ? '+$rawDigits' : '+20$rawDigits';
      await client.auth.signInWithOtp(phone: formattedPhone);
    }
  }

  /// Verifies a 6-digit OTP token and signs in the user.
  Future<AuthResponse> verifyOtp({
    required String identity,
    required String token,
    OtpType? type,
  }) async {
    final clean = identity.trim();
    final isEmail = clean.contains('@');

    if (isEmail) {
      return await client.auth.verifyOTP(
        email: clean,
        token: token.trim(),
        type: type ?? OtpType.email,
      );
    } else {
      final rawDigits = clean.replaceAll(RegExp(r'\D'), '');
      final formattedPhone = rawDigits.startsWith('20') ? '+$rawDigits' : '+20$rawDigits';
      return await client.auth.verifyOTP(
        phone: formattedPhone,
        token: token.trim(),
        type: type ?? OtpType.sms,
      );
    }
  }

  /// Uploads avatar image bytes to the avatars bucket and returns public URL.
  Future<String?> uploadAvatar({
    required String userId,
    required Uint8List imageBytes,
  }) async {
    try {
      final fileName = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage.from('avatars').uploadBinary(
        fileName,
        imageBytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
      );
      final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      debugPrint("Storage Upload Error: $e");
      return null;
    }
  }
}

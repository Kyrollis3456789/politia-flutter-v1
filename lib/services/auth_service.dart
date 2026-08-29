import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:politia/models/auth_result.dart';
import 'package:politia/utils/input_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized authentication service managing credential logins (Email, Phone, Member ID)
/// and OAuth social logins (Google, Facebook, Apple) with Supabase.
class AuthService {
  final SupabaseClient _supabase;

  AuthService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  static const String _prefKeyUuid = 'uuid';
  static const String _prefApplePrefix = 'apple_auth_cache_';

  // =========================================================================
  // 1. UNIFIED SIGN IN WITH CREDENTIALS (Email, Phone, Member ID)
  // =========================================================================
  /// Automatically detects input type and authenticates via Email, Phone, or Member ID.
  Future<AuthResult> signInWithCredentials({
    required String input,
    required String password,
  }) async {
    final clean = input.trim();
    if (clean.isEmpty) {
      return AuthResult.error('Please enter a valid email or phone number.');
    }

    final inputType = InputDetector.detect(clean);

    switch (inputType) {
      case InputType.email:
        return await signInWithEmail(email: clean, password: password);

      case InputType.phone:
        return await signInWithPhone(phone: clean, password: password);

      case InputType.memberId:
        return await signInWithMemberId(memberId: clean, password: password);

      case InputType.unrecognized:
        return AuthResult.error('Please enter a valid email or phone number.');
    }
  }

  // =========================================================================
  // 2. EMAIL AUTHENTICATION
  // =========================================================================
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final response = await _supabase.auth.signInWithPassword(
        email: cleanEmail,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return AuthResult.error('No account found with this email.');
      }

      await _persistUserSession(user.id);
      return AuthResult.success(user);
    } on AuthException catch (e) {
      debugPrint('[AuthService] Email Sign-In AuthException: ${e.message}');
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid credentials') ||
          msg.contains('wrong password')) {
        return AuthResult.error('Incorrect password. Please try again.');
      }
      if (msg.contains('user not found') || msg.contains('no user')) {
        return AuthResult.error('No account found with this email.');
      }
      return AuthResult.error('Incorrect password. Please try again.');
    } catch (e) {
      debugPrint('[AuthService] Email Sign-In Network/System Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // 3. PHONE AUTHENTICATION
  // =========================================================================
  Future<AuthResult> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      final normalizedPhone = InputDetector.normalizePhone(phone);
      final response = await _supabase.auth.signInWithPassword(
        phone: normalizedPhone,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return AuthResult.error('No account found with this phone number.');
      }

      await _persistUserSession(user.id);
      return AuthResult.success(user);
    } on AuthException catch (e) {
      debugPrint('[AuthService] Phone Sign-In AuthException: ${e.message}');
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid credentials') ||
          msg.contains('wrong password')) {
        return AuthResult.error('Incorrect password. Please try again.');
      }
      if (msg.contains('user not found') || msg.contains('no user')) {
        return AuthResult.error('No account found with this phone number.');
      }
      return AuthResult.error('Incorrect password. Please try again.');
    } catch (e) {
      debugPrint('[AuthService] Phone Sign-In Network/System Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // 4. MEMBER ID AUTHENTICATION
  // =========================================================================
  Future<AuthResult> signInWithMemberId({
    required String memberId,
    required String password,
  }) async {
    try {
      final cleanMemberId = memberId.trim();

      // Step C: Query profiles table for member_id
      final profile = await _supabase
          .from('profiles')
          .select('id, email, phone, phone_number_primary')
          .eq('member_id', cleanMemberId)
          .maybeSingle();

      if (profile == null) {
        return AuthResult.error('Member ID not found. Please check and retry.');
      }

      final String? email = profile['email']?.toString();
      final String? phone = (profile['phone'] ?? profile['phone_number_primary'])?.toString();

      // Authenticate with resolved email or phone
      if (email != null && email.isNotEmpty) {
        return await signInWithEmail(email: email, password: password);
      } else if (phone != null && phone.isNotEmpty) {
        return await signInWithPhone(phone: phone, password: password);
      } else {
        return AuthResult.error('Member ID not found. Please check and retry.');
      }
    } catch (e) {
      debugPrint('[AuthService] Member ID Sign-In Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // 5. GOOGLE OAUTH SIGN IN
  // =========================================================================
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.error('Google sign-in was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return AuthResult.error('Failed to obtain Google ID token.');
      }

      final String? email = googleUser.email.isNotEmpty ? googleUser.email : null;
      const String? phone = null;
      final String providerUserId = googleUser.id;
      final String? fullName = googleUser.displayName;

      final conflictResult = await _checkDuplicateBeforeAuth(
        provider: 'google',
        providerUserId: providerUserId,
        email: email,
        phone: phone,
      );
      if (conflictResult != null) {
        return conflictResult;
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final User? user = response.user;
      if (user == null) {
        return AuthResult.error('Failed to authenticate with Supabase.');
      }

      await _upsertProfilesAndProviders(
        userId: user.id,
        email: email,
        phone: phone,
        fullName: fullName,
        provider: 'google',
        providerId: providerUserId,
      );

      await _persistUserSession(user.id);
      return AuthResult.success(user);
    } catch (e) {
      debugPrint('[AuthService] Google Sign-In Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // 6. FACEBOOK OAUTH SIGN IN
  // =========================================================================
  Future<AuthResult> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        return AuthResult.error('Facebook sign-in was cancelled.');
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        return AuthResult.error(result.message ?? 'Facebook sign-in failed.');
      }

      final String accessToken = result.accessToken!.tokenString;
      final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();
      final accessTokenObj = result.accessToken;
      String tokenUserId = '';
      if (accessTokenObj is ClassicToken) {
        tokenUserId = accessTokenObj.userId;
      } else if (accessTokenObj is LimitedToken) {
        tokenUserId = accessTokenObj.userId;
      }
      final String providerUserId = userData['id']?.toString() ?? tokenUserId;
      final String? email = userData['email']?.toString();
      const String? phone = null;
      final String? fullName = userData['name']?.toString();

      final conflictResult = await _checkDuplicateBeforeAuth(
        provider: 'facebook',
        providerUserId: providerUserId,
        email: email,
        phone: phone,
      );
      if (conflictResult != null) {
        return conflictResult;
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.facebook,
        idToken: accessToken,
        accessToken: accessToken,
      );

      final User? user = response.user;
      if (user == null) {
        return AuthResult.error('Failed to authenticate with Supabase.');
      }

      await _upsertProfilesAndProviders(
        userId: user.id,
        email: email,
        phone: phone,
        fullName: fullName,
        provider: 'facebook',
        providerId: providerUserId,
      );

      await _persistUserSession(user.id);
      return AuthResult.success(user);
    } catch (e) {
      debugPrint('[AuthService] Facebook Sign-In Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // 7. APPLE OAUTH SIGN IN
  // =========================================================================
  Future<AuthResult> signInWithApple() async {
    try {
      final String rawNonce = _supabase.auth.generateRawNonce();
      final String hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final String? idToken = credential.identityToken;
      if (idToken == null) {
        return AuthResult.error('Failed to obtain Apple ID token.');
      }

      final String providerUserId = credential.userIdentifier ?? '';
      String? email = credential.email;
      String? fullName = [credential.givenName, credential.familyName]
          .where((s) => s != null && s.isNotEmpty)
          .join(' ')
          .trim();
      if (fullName.isEmpty) fullName = null;

      if (providerUserId.isNotEmpty) {
        await _cacheAppleCredentials(
          userIdentifier: providerUserId,
          email: email,
          fullName: fullName,
        );
        if (email == null || fullName == null) {
          final cached = await _getCachedAppleCredentials(providerUserId);
          email ??= cached.email;
          fullName ??= cached.fullName;
        }
      }

      const String? phone = null;

      final conflictResult = await _checkDuplicateBeforeAuth(
        provider: 'apple',
        providerUserId: providerUserId,
        email: email,
        phone: phone,
      );
      if (conflictResult != null) {
        return conflictResult;
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      final User? user = response.user;
      if (user == null) {
        return AuthResult.error('Failed to authenticate with Supabase.');
      }

      await _upsertProfilesAndProviders(
        userId: user.id,
        email: email,
        phone: phone,
        fullName: fullName,
        provider: 'apple',
        providerId: providerUserId,
      );

      await _persistUserSession(user.id);
      return AuthResult.success(user);
    } catch (e) {
      debugPrint('[AuthService] Apple Sign-In Error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // HELPER: DUPLICATE CHECK BEFORE CALLING SUPABASE AUTH
  // =========================================================================
  Future<AuthResult?> _checkDuplicateBeforeAuth({
    required String provider,
    required String providerUserId,
    required String? email,
    required String? phone,
  }) async {
    try {
      final existingProvider = await _supabase
          .from('user_providers')
          .select('user_id')
          .eq('provider', provider)
          .eq('provider_id', providerUserId)
          .maybeSingle();

      if (existingProvider != null) {
        return null;
      }

      if (email != null && email.isNotEmpty) {
        final existingEmail = await _supabase
            .from('profiles')
            .select('id')
            .eq('email', email)
            .maybeSingle();

        if (existingEmail != null) {
          return AuthResult.conflict(
            'An account with this email already exists. Please sign in with your original method or link your accounts in Settings.',
          );
        }
      }

      if (phone != null && phone.isNotEmpty) {
        final existingPhone = await _supabase
            .from('profiles')
            .select('id')
            .eq('phone', phone)
            .maybeSingle();

        if (existingPhone != null) {
          return AuthResult.conflict(
            'This phone number is already linked to another account. Please use your original sign-in method.',
          );
        }
      }

      return null;
    } catch (e) {
      debugPrint('[AuthService] Duplicate check error: $e');
      return AuthResult.error('Something went wrong. Please try again.');
    }
  }

  // =========================================================================
  // HELPER: UPSERT PROFILES AND USER_PROVIDERS
  // =========================================================================
  Future<void> _upsertProfilesAndProviders({
    required String userId,
    required String? email,
    required String? phone,
    required String? fullName,
    required String provider,
    required String providerId,
  }) async {
    try {
      final profilePayload = <String, dynamic>{
        'id': userId,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (fullName != null && fullName.isNotEmpty) ...{
          'full_name': fullName,
          'full_name_en': fullName,
        },
      };

      await _supabase.from('profiles').upsert(
        profilePayload,
        onConflict: 'id',
        ignoreDuplicates: true,
      );

      await _supabase.from('user_providers').upsert(
        {
          'user_id': userId,
          'provider': provider,
          'provider_id': providerId,
        },
        onConflict: 'provider,provider_id',
        ignoreDuplicates: true,
      );
    } catch (e) {
      debugPrint('[AuthService] Upsert profiles/user_providers error: $e');
    }
  }

  // =========================================================================
  // HELPER: SAVE UUID TO SHAREDPREFERENCES
  // =========================================================================
  Future<void> _persistUserSession(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyUuid, userId);
    } catch (e) {
      debugPrint('[AuthService] Error persisting UUID session: $e');
    }
  }

  // =========================================================================
  // HELPER: APPLE CREDENTIAL CACHING
  // =========================================================================
  Future<void> _cacheAppleCredentials({
    required String userIdentifier,
    required String? email,
    required String? fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (email != null && email.isNotEmpty) {
      await prefs.setString('${_prefApplePrefix}email_$userIdentifier', email);
    }
    if (fullName != null && fullName.isNotEmpty) {
      await prefs.setString('${_prefApplePrefix}name_$userIdentifier', fullName);
    }
  }

  Future<({String? email, String? fullName})> _getCachedAppleCredentials(
      String userIdentifier) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('${_prefApplePrefix}email_$userIdentifier');
    final fullName = prefs.getString('${_prefApplePrefix}name_$userIdentifier');
    return (email: email, fullName: fullName);
  }
}

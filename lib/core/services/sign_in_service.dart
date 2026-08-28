import 'package:shared_preferences/shared_preferences.dart';

/// User profile data model used for profile preview on Sign-In Step 2.
class UserProfilePreview {
  final String? id;
  final String fullNameEn;
  final String fullNameAr;
  final String? avatarUrl;
  final String? phoneNumberPrimary;
  final String? email;

  const UserProfilePreview({
    this.id,
    required this.fullNameEn,
    required this.fullNameAr,
    this.avatarUrl,
    this.phoneNumberPrimary,
    this.email,
  });

  factory UserProfilePreview.fromMap(Map<String, dynamic> map) {
    return UserProfilePreview(
      id: map['id']?.toString(),
      fullNameEn: (map['full_name_en'] ?? map['full_name'] ?? '').toString().trim(),
      fullNameAr: (map['full_name_ar'] ?? '').toString().trim(),
      avatarUrl: (map['profile_picture_url'] ?? map['avatar_url'])?.toString(),
      phoneNumberPrimary: map['phone_number_primary']?.toString(),
      email: map['email']?.toString(),
    );
  }

  /// Returns the formatted Egyptian phone number (e.g. `+20 10 1234 5678`).
  String get formattedPhoneNumber {
    final raw = (phoneNumberPrimary ?? '').replaceAll(RegExp(r'\D'), '');
    if (raw.isEmpty) return '';

    // If starts with 20 and has 12 digits (201XXXXXXXXX)
    if (raw.startsWith('20') && raw.length == 12) {
      final prefix = raw.substring(0, 2); // 20
      final code = raw.substring(2, 4);   // 10, 11, 12, 15
      final part1 = raw.substring(4, 8);  // 1234
      final part2 = raw.substring(8);     // 5678
      return '+$prefix $code $part1 $part2';
    }

    // If starts with 01 and has 11 digits (01XXXXXXXXX)
    if (raw.startsWith('01') && raw.length == 11) {
      final code = raw.substring(0, 3);   // 010, 011, 012, 015
      final part1 = raw.substring(3, 7);  // 1234
      final part2 = raw.substring(7);     // 5678
      return '+20 ${code.substring(1)} $part1 $part2';
    }

    // Fallback: prepend + if missing
    return phoneNumberPrimary!.startsWith('+') ? phoneNumberPrimary! : '+$phoneNumberPrimary';
  }

  /// Primary display name
  String get displayName {
    if (fullNameEn.isNotEmpty && fullNameAr.isNotEmpty) {
      return fullNameEn;
    }
    if (fullNameEn.isNotEmpty) return fullNameEn;
    if (fullNameAr.isNotEmpty) return fullNameAr;
    return email ?? 'Registered Member';
  }

  /// Secondary display name (Arabic or English translation)
  String? get secondaryDisplayName {
    if (fullNameEn.isNotEmpty && fullNameAr.isNotEmpty) {
      return fullNameAr;
    }
    return null;
  }
}

/// Security and attempt tracking engine for the Politia Sign-In flow.
class SignInService {
  SignInService._internal();
  static final SignInService instance = SignInService._internal();

  /// Key in SharedPreferences for recording consecutive wrong password attempts.
  static const String prefKeyFailedAttempts = 'failed_login_attempts_count';

  /// Maximum allowed consecutive wrong password attempts before locking and requiring OTP.
  static const int maxAllowedFailedAttempts = 10;

  /// Retrieves the current failed attempts count.
  Future<int> getFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(prefKeyFailedAttempts) ?? 0;
  }

  /// Increments and persists the failed login attempts counter.
  Future<int> incrementFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(prefKeyFailedAttempts) ?? 0;
    final updated = current + 1;
    await prefs.setInt(prefKeyFailedAttempts, updated);
    return updated;
  }

  /// Resets the failed login attempts counter to 0.
  Future<void> resetFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefKeyFailedAttempts, 0);
  }

  /// Whether failed attempts exceed the allowed threshold, requiring OTP verification.
  Future<bool> isOtpRequired() async {
    final attempts = await getFailedAttempts();
    return attempts >= maxAllowedFailedAttempts;
  }

  /// Number of remaining password attempts before OTP lockout.
  Future<int> getRemainingAttempts() async {
    final attempts = await getFailedAttempts();
    final remaining = maxAllowedFailedAttempts - attempts;
    return remaining > 0 ? remaining : 0;
  }

  /// Validates whether the user input is a valid Email or Egyptian Mobile Number.
  bool isValidIdentity(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return false;

    // Check Email format
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(clean)) return true;

    // Check Egyptian Phone format (010, 011, 012, 015 or +2010...)
    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('01') && digits.length == 11) {
      final prefix = digits.substring(0, 3);
      if (['010', '011', '012', '015'].contains(prefix)) return true;
    }

    if (digits.startsWith('201') && digits.length == 12) {
      final prefix = digits.substring(2, 4);
      if (['10', '11', '12', '15'].contains(prefix)) return true;
    }

    return false;
  }

  /// Normalizes an Egyptian phone number or email to a standardized query identity.
  String normalizeIdentity(String input) {
    final clean = input.trim();
    if (clean.contains('@')) return clean.toLowerCase();

    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('01') && digits.length == 11) {
      return '+20${digits.substring(1)}';
    }
    if (digits.startsWith('201') && digits.length == 12) {
      return '+$digits';
    }
    return clean;
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { success, conflict, error }

class AuthResult {
  final AuthStatus status;
  final String? message; // shown to user on conflict or error
  final User? user; // Supabase user on success

  const AuthResult({required this.status, this.message, this.user});

  factory AuthResult.success(User user) =>
      AuthResult(status: AuthStatus.success, user: user);

  factory AuthResult.conflict(String message) =>
      AuthResult(status: AuthStatus.conflict, message: message);

  factory AuthResult.error(String message) =>
      AuthResult(status: AuthStatus.error, message: message);
}

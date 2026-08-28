import 'dart:io';
import 'package:flutter/material.dart';
import 'package:politia/core/services/init_service.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/features/auth/registration/widgets/password_strength_meter.dart';
import 'package:politia/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Milestone 8: Password Creation & Final Account Dispatch
class Step8PasswordFinal extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onBack;

  const Step8PasswordFinal({
    super.key,
    required this.notifier,
    required this.onBack,
  });

  @override
  State<Step8PasswordFinal> createState() => _Step8PasswordFinalState();
}

class _Step8PasswordFinalState extends State<Step8PasswordFinal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _passwordController = TextEditingController(text: draft.password);
    _confirmPasswordController = TextEditingController(text: draft.confirmPassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleFinalDispatch() async {
    if (!_formKey.currentState!.validate()) return;

    final draft = widget.notifier.draft;
    draft.password = _passwordController.text.trim();
    draft.confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _errorMessage = null;
    });
    widget.notifier.setLoading(true);

    try {
      // 1. Dispatch Create User to Supabase Auth
      final response = await SupabaseService.instance.signUp(
        email: draft.email.isNotEmpty ? draft.email : '${draft.primaryPhone}@politia.app',
        password: draft.password,
      );

      final userId = response.user?.id;
      if (userId != null) {
        // 2. Persist local active UUID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(InitializationService.prefKeyUuid, userId);

        // 3. Upload avatar if selected
        String? avatarUrl;
        if (draft.avatarPath != null) {
          final bytes = await File(draft.avatarPath!).readAsBytes();
          avatarUrl = await SupabaseService.instance.uploadAvatar(
            userId: userId,
            imageBytes: bytes,
          );
        }

        // 4. Insert into the new profiles table
        await SupabaseService.instance.client.from('profiles').insert({
          'id': userId,
          'email': draft.email.isNotEmpty ? draft.email : '${draft.primaryPhone}@politia.app',
          'phone_number_primary': draft.primaryPhone,
          'phone_number_secondary': draft.secondaryPhones.isNotEmpty ? draft.secondaryPhones.first : null,
          'full_name_en': draft.fullNameEn,
          'full_name_ar': draft.fullNameAr,
          'nickname': draft.nickname,
          'national_id': draft.nationalId,
          'birth_date': draft.dateOfBirth?.toIso8601String(),
          'age': draft.calculatedAge,
          'gender': draft.gender,
          'birth_location': draft.birthLocation,
          'avatar_url': avatarUrl,
          'profile_picture_url': avatarUrl,
          'skip_avatar_until': draft.skipAvatarUntil?.toIso8601String(),
        });
      }

      // 5. Clear draft cache upon success
      widget.notifier.clearDraft();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration completed successfully! Welcome to Politia.')),
      );
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) {
        widget.notifier.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = colors.primary;
    final draft = widget.notifier.draft;
    final isLoading = widget.notifier.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security & Final Setup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                      fontSize: 22,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create your secure master password to complete account registration.',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Error Message Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Password Field
                  CustomAuthTextField(
                    label: 'Master Password / كلمة المرور',
                    controller: _passwordController,
                    hintText: '••••••••••',
                    isPassword: true,
                    onChanged: (_) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Live Password Strength Meter
                  PasswordStrengthMeter(password: _passwordController.text),
                  const SizedBox(height: 18),

                  // Confirm Password Field
                  CustomAuthTextField(
                    label: 'Confirm Password / تأكيد كلمة المرور',
                    controller: _confirmPasswordController,
                    hintText: '••••••••••',
                    isPassword: true,
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Summary Overview Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assignment_turned_in_rounded, color: primary, size: 20),
                            const SizedBox(width: 8),
                            const Text('Account Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const Divider(height: 16),
                        _buildSummaryRow('Full Name (EN):', draft.fullNameEn.isNotEmpty ? draft.fullNameEn : 'Provided'),
                        _buildSummaryRow('Full Name (AR):', draft.fullNameAr.isNotEmpty ? draft.fullNameAr : 'Provided'),
                        _buildSummaryRow('Contact Mobile:', draft.primaryPhone.isNotEmpty ? draft.primaryPhone : 'Provided'),
                        _buildSummaryRow('Parish & Diocese:', '${draft.primaryChurch} (${draft.diocese ?? draft.governorate})'),
                        _buildSummaryRow('Location:', '${draft.city}, ${draft.governorate}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Action Buttons
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: isLoading ? null : widget.onBack,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleFinalDispatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

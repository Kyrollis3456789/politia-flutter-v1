import 'package:flutter/material.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/widgets/auth_language_picker.dart';
import 'package:politia/widgets/custom_text_field.dart';
import 'package:politia/widgets/politia_branded_background.dart';

/// Sign In Screen matching the left screen mockup with responsive Desktop/PC & Mobile compatibility.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await SupabaseService.instance.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 600;

    return Scaffold(
      body: PolitiaBrandedBackground(
        child: SafeArea(
          bottom: false,
          child: isDesktop
              ? _buildDesktopLayout(context, l10n, isDark)
              : _buildMobileLayout(context, l10n, isDark),
        ),
      ),
    );
  }

  /// Desktop / PC Centered Floating Card Layout
  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Stack(
      children: [
        const Positioned(
          top: 20,
          right: 24,
          child: AuthLanguagePicker(),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: 12,
                shadowColor: Colors.black.withValues(alpha: 0.25),
                color: isDark ? const Color(0xFF131D2A) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.helloSignIn,
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              height: 1.2,
                              color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111827),
                            ),
                          ),
                          Hero(
                            tag: 'app_logo_hero',
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.webp',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildFormContent(context, l10n, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Mobile Fluid Header + Bottom Sheet Layout
  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n, bool isDark) {
    final canPop = Navigator.of(context).canPop();

    return Column(
      children: [
        // Top Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (canPop)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark ? Colors.white70 : const Color(0xFF1F2937),
                        size: 20,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const AuthLanguagePicker(),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.helloSignIn,
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  height: 1.2,
                  color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // Bottom Form Card
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131D2A) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
              child: _buildFormContent(context, l10n, isDark),
            ),
          ),
        ),
      ],
    );
  }

  /// Shared Form Content
  Widget _buildFormContent(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            const SizedBox(height: 20),
          ],

          // Email Field
          CustomAuthTextField(
            label: l10n.email,
            controller: _emailController,
            hintText: 'webx@gmail.com',
            keyboardType: TextInputType.emailAddress,
            isValid: _emailController.text.contains('@'),
            validator: (value) {
              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Password Field
          CustomAuthTextField(
            label: l10n.password,
            controller: _passwordController,
            hintText: '••••••••••',
            isPassword: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.passwordTooShort;
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // Forgot Password
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.forgotPassword)),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.forgotPassword,
                style: TextStyle(
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // SIGN IN Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45309), // Amber 700
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.signIn,
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Switch to Sign Up
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.dontHaveAccount,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/signup');
                  },
                  child: Text(
                    l10n.signUp,
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

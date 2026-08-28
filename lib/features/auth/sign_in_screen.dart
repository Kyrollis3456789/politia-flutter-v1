import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/services/init_service.dart';
import 'package:politia/core/services/sign_in_service.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/widgets/auth_language_picker.dart';
import 'package:politia/widgets/custom_text_field.dart';
import 'package:politia/widgets/politia_branded_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Comprehensive Sign-In Screen with 2-step progressive authentication,
/// profile preview (Avatar, Full Name, Resolved Egyptian Phone),
/// security attempt engine, and dynamic 6-digit OTP fallback.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Step state: 1 = Identify (Email/Phone), 2 = Authenticate (Password/OTP)
  int _currentStep = 1;

  // Controllers
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // Profile data & Security state
  UserProfilePreview? _profilePreview;
  bool _isOtpMode = false;
  int _failedAttempts = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // OTP Resend Timer
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _loadSecurityState();
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSecurityState() async {
    final attempts = await SignInService.instance.getFailedAttempts();
    if (mounted) {
      setState(() {
        _failedAttempts = attempts;
        if (attempts >= SignInService.maxAllowedFailedAttempts) {
          _isOtpMode = true;
        }
      });
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendCountdown = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  // =========================================================================
  // STEP 1: IDENTITY LOOKUP
  // =========================================================================
  Future<void> _handleStep1Continue() async {
    final rawInput = _identityController.text.trim();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (rawInput.isEmpty) {
      setState(() {
        _errorMessage = isArabic
            ? 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف'
            : 'Please enter your email or phone number';
      });
      return;
    }

    if (!SignInService.instance.isValidIdentity(rawInput)) {
      setState(() {
        _errorMessage = isArabic
            ? 'يرجى إدخال بريد إلكتروني صحيح أو رقم هاتف مصري صالح (010, 011, 012, 015)'
            : 'Please enter a valid email or Egyptian phone number (010, 011, 012, 015)';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final exists = await SupabaseService.instance.checkUserExists(rawInput);
      if (!exists) {
        if (!mounted) return;
        setState(() {
          _errorMessage = isArabic
              ? 'البريد الإلكتروني أو رقم الهاتف غير مسجل.'
              : 'Email or phone number not registered.';
        });
        return;
      }

      // Fetch profile data
      final profileMap = await SupabaseService.instance.fetchProfileData(rawInput);
      if (profileMap != null) {
        _profilePreview = UserProfilePreview.fromMap(profileMap);
      } else {
        _profilePreview = UserProfilePreview(
          fullNameEn: rawInput,
          fullNameAr: '',
          email: rawInput.contains('@') ? rawInput : null,
          phoneNumberPrimary: !rawInput.contains('@') ? rawInput : null,
        );
      }

      final attempts = await SignInService.instance.getFailedAttempts();
      _failedAttempts = attempts;
      if (attempts >= SignInService.maxAllowedFailedAttempts) {
        _isOtpMode = true;
        _sendOtpCode();
      }

      if (!mounted) return;
      setState(() {
        _currentStep = 2;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================================
  // STEP 2: PASSWORD AUTHENTICATION
  // =========================================================================
  Future<void> _handlePasswordSignIn() async {
    final password = _passwordController.text.trim();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (password.isEmpty) {
      setState(() {
        _errorMessage = isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final emailToAuth = _profilePreview?.email ??
          (_identityController.text.contains('@')
              ? _identityController.text.trim()
              : '${_identityController.text.replaceAll(RegExp(r'\D'), '')}@politia.app');

      final response = await SupabaseService.instance.signInWithPassword(
        email: emailToAuth,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        // Success: Reset attempt counter
        await SignInService.instance.resetFailedAttempts();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(InitializationService.prefKeyUuid, user.id);

        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } on AuthException {
      final updatedAttempts = await SignInService.instance.incrementFailedAttempts();
      final remaining = (SignInService.maxAllowedFailedAttempts - updatedAttempts).clamp(0, SignInService.maxAllowedFailedAttempts);

      if (!mounted) return;
      setState(() {
        _failedAttempts = updatedAttempts;
        if (updatedAttempts >= SignInService.maxAllowedFailedAttempts) {
          _isOtpMode = true;
          _errorMessage = isArabic
              ? 'تجاوزت الحد الأقصى لمحاولات كلمة المرور (10/10). تم تفعيل التحقق برمز OTP.'
              : 'Maximum password attempts reached (10/10). Verification code (OTP) activated.';
          _sendOtpCode();
        } else {
          _errorMessage = isArabic
              ? 'كلمة المرور غير صحيحة. متبقي $remaining محاولات.'
              : 'Incorrect password. $remaining attempts remaining.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================================
  // STEP 2: OTP VERIFICATION
  // =========================================================================
  Future<void> _sendOtpCode() async {
    final identity = _profilePreview?.phoneNumberPrimary ?? _identityController.text.trim();
    try {
      await SupabaseService.instance.sendOtp(identity);
      _startResendTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'تم إرسال رمز التحقق إلى $identity'
                : 'Verification code sent to $identity',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to send OTP: $e';
      });
    }
  }

  Future<void> _handleOtpVerification() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final token = _otpControllers.map((c) => c.text).join().trim();

    if (token.length < 6) {
      setState(() {
        _errorMessage = isArabic ? 'يرجى إدخال رمز التحقق المكون من 6 أرقام' : 'Please enter the full 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final identity = _profilePreview?.phoneNumberPrimary ??
          _profilePreview?.email ??
          _identityController.text.trim();

      final response = await SupabaseService.instance.verifyOtp(
        identity: identity,
        token: token,
      );

      final user = response.user;
      if (user != null) {
        // Success: Reset attempt counter
        await SignInService.instance.resetFailedAttempts();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(InitializationService.prefKeyUuid, user.id);

        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================================
  // BUILD METHOD & RESPONSIVE CONTAINER
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.background,
      body: PolitiaBrandedBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      children: [
                        // Top Header Bar (Back, Language, Logo)
                        _buildTopHeaderBar(context),
                        const SizedBox(height: 16),

                        // Form Card Body (Scrollable with Pinned Action Buttons)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF161513) : colors.surface,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isDark ? const Color(0xFF2A2722) : colors.border,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.10),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: _currentStep == 1
                                  ? _buildStep1Identify(context, l10n, isDark)
                                  : _buildStep2Authenticate(context, l10n, isDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // HEADER BAR
  // =========================================================================
  Widget _buildTopHeaderBar(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep == 2)
          IconButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
                _errorMessage = null;
                _passwordController.clear();
              });
            },
            icon: Icon(
              isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
              color: colors.textPrimary,
              size: 20,
            ),
            tooltip: isArabic ? 'رجوع' : 'Back',
          )
        else
          const SizedBox(width: 40),

        // App Logo
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary.withValues(alpha: 0.15),
            border: Border.all(color: const Color(0xFFE5B842).withValues(alpha: 0.4)),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.webp',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.church_rounded, color: colors.primary, size: 20),
            ),
          ),
        ),

        const AuthLanguagePicker(),
      ],
    );
  }

  // =========================================================================
  // STEP 1: IDENTIFY WIDGET (Email or Egyptian Phone)
  // =========================================================================
  Widget _buildStep1Identify(BuildContext context, AppLocalizations l10n, bool isDark) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Typography
                Text(
                  isArabic ? 'مرحباً بك' : 'WELCOME',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 13,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? 'تسجيل الدخول' : 'SIGN IN',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'أدخل بريدك الإلكتروني أو رقم هاتفك المسجل للمتابعة.'
                      : 'Enter your registered email or mobile number to proceed.',
                  style: TextStyle(fontSize: 13, color: colors.textMuted),
                ),
                const SizedBox(height: 24),

                // Error Banner
                if (_errorMessage != null) ...[
                  _buildErrorBanner(_errorMessage!),
                  const SizedBox(height: 18),
                ],

                // Identity TextField
                CustomAuthTextField(
                  label: isArabic ? 'البريد الإلكتروني أو رقم الهاتف' : 'Email or Mobile Number',
                  controller: _identityController,
                  hintText: isArabic ? 'webx@gmail.com أو 010XXXXXXXX' : 'webx@gmail.com or 010XXXXXXXX',
                  prefixIcon: Icon(Icons.perm_identity_rounded, color: colors.textMuted, size: 20),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleStep1Continue(),
                  onChanged: (_) {
                    if (_errorMessage != null) setState(() => _errorMessage = null);
                  },
                ),
                const SizedBox(height: 12),

                // Helper note
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: const Color(0xFFE5B842).withValues(alpha: 0.9)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'أرقام الهواتف المصرية المدعومة: 010, 011, 012, 015'
                            : 'Supported Egyptian carriers: 010, 011, 012, 015',
                        style: TextStyle(fontSize: 11.5, color: colors.textMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Action Buttons
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleStep1Continue,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    isArabic ? 'المتابعة' : 'Continue',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        ),
        const SizedBox(height: 16),

        // Switch to Sign Up
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.dontHaveAccount,
                style: TextStyle(color: colors.textSecondary, fontSize: 13),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  minimumSize: const Size(48, 40),
                ),
                child: Text(
                  l10n.signUp,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // STEP 2: PROFILE PREVIEW & AUTHENTICATION WIDGET
  // =========================================================================
  Widget _buildStep2Authenticate(BuildContext context, AppLocalizations l10n, bool isDark) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final profile = _profilePreview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. PROFILE CARD PREVIEW
                _buildProfilePreviewCard(profile, colors, isDark),
                const SizedBox(height: 20),

                // Error / Warning Banner
                if (_errorMessage != null) ...[
                  _buildErrorBanner(_errorMessage!),
                  const SizedBox(height: 16),
                ],

                // Dynamic Mode: OTP vs Password
                if (_isOtpMode)
                  _buildOtpInputSection(isArabic, colors)
                else
                  _buildPasswordInputSection(isArabic, colors),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Pinned Bottom Action Bar
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _currentStep = 1;
                            _errorMessage = null;
                            _passwordController.clear();
                          });
                        },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isArabic ? 'تغيير الحساب' : 'Switch'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : (_isOtpMode ? _handleOtpVerification : _handlePasswordSignIn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isOtpMode
                              ? (isArabic ? 'تأكيد الرمز' : 'Verify & Sign In')
                              : (isArabic ? 'تسجيل الدخول' : 'Sign In'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // PROFILE PREVIEW CARD (Avatar, Full Name, Resolved Phone Number)
  // =========================================================================
  Widget _buildProfilePreviewCard(UserProfilePreview? profile, dynamic colors, bool isDark) {
    final avatarUrl = profile?.avatarUrl;
    final phone = profile?.formattedPhoneNumber ?? '';
    final hasPhone = phone.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1C19) : const Color(0xFFFBF8F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5B842).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          // Circular Avatar with Gold Hairline Ring
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5B842), width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE5B842).withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: isDark ? const Color(0xFF2A2722) : const Color(0xFFE5E0D8),
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? const Icon(Icons.person_rounded, size: 38, color: Color(0xFFE5B842))
                  : null,
            ),
          ),
          const SizedBox(height: 12),

          // User Full Name (Bold Serif Typography)
          Text(
            profile?.displayName ?? 'Registered Member',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colors.textPrimary,
            ),
          ),

          // Secondary Name (if available)
          if (profile?.secondaryDisplayName != null) ...[
            const SizedBox(height: 2),
            Text(
              profile!.secondaryDisplayName!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 6),

          // Resolved Phone Number Badge
          if (hasPhone)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5B842).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5B842).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 14, color: Color(0xFFE5B842)),
                  const SizedBox(width: 6),
                  Text(
                    phone,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: Color(0xFFE5B842),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // PASSWORD INPUT SECTION
  // =========================================================================
  Widget _buildPasswordInputSection(bool isArabic, dynamic colors) {
    final remaining = (SignInService.maxAllowedFailedAttempts - _failedAttempts).clamp(0, SignInService.maxAllowedFailedAttempts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAuthTextField(
          label: isArabic ? 'كلمة المرور' : 'Password',
          controller: _passwordController,
          hintText: '••••••••••',
          isPassword: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handlePasswordSignIn(),
        ),

        const SizedBox(height: 8),

        // Forgot password & Attempt counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_failedAttempts > 0)
              Text(
                isArabic ? 'متبقي $remaining محاولات' : '$remaining attempts left',
                style: const TextStyle(fontSize: 12, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
              )
            else
              const SizedBox.shrink(),

            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'يرجى التواصل مع خادم الكنيسة لإعادة تعيين كلمة المرور أو استخدام رمز OTP'
                          : 'Please contact parish admin to reset password or use OTP login',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 36),
                foregroundColor: colors.textSecondary,
              ),
              child: Text(
                isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Alternate: Toggle OTP Login
        Center(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _isOtpMode = true;
                _errorMessage = null;
              });
              _sendOtpCode();
            },
            icon: const Icon(Icons.sms_outlined, size: 16),
            label: Text(
              isArabic ? 'أو تسجيل الدخول برمز OTP' : 'Or sign in with 6-digit OTP',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE5B842),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 6-DIGIT OTP INPUT SECTION
  // =========================================================================
  Widget _buildOtpInputSection(bool isArabic, dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_failedAttempts >= SignInService.maxAllowedFailedAttempts)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'تنبيه أمان: تم تجاوز عدد محاولات كلمة المرور. يرجى إدخال رمز التحقق (OTP).'
                        : 'Security Notice: Max password attempts reached. Please verify with 6-digit OTP.',
                    style: const TextStyle(fontSize: 12.5, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),

        Text(
          isArabic ? 'أدخل رمز التحقق (6 أرقام)' : 'Enter 6-Digit Verification Code',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
        const SizedBox(height: 16),

        // 6 OTP Box Inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 44,
              height: 52,
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: colors.background,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5B842), width: 2),
                  ),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < 5) {
                    _otpFocusNodes[index + 1].requestFocus();
                  } else if (val.isEmpty && index > 0) {
                    _otpFocusNodes[index - 1].requestFocus();
                  }
                  if (_otpControllers.every((c) => c.text.isNotEmpty)) {
                    _handleOtpVerification();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Resend Timer / Action
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_resendCountdown > 0)
              Text(
                isArabic
                    ? 'إعادة الإرسال خلال $_resendCountdown ثانية'
                    : 'Resend code in ${_resendCountdown}s',
                style: TextStyle(fontSize: 12.5, color: colors.textMuted),
              )
            else
              TextButton.icon(
                onPressed: _sendOtpCode,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  isArabic ? 'إعادة إرسال الرمز' : 'Resend Code',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFE5B842)),
              ),
          ],
        ),

        if (_failedAttempts < SignInService.maxAllowedFailedAttempts) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _isOtpMode = false;
                _errorMessage = null;
              });
            },
            child: Text(
              isArabic ? 'الرجوع لاستخدام كلمة المرور' : 'Use Password instead',
              style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

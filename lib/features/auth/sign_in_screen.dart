import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/services/init_service.dart';
import 'package:politia/core/services/sign_in_service.dart';
import 'package:politia/core/services/supabase_service.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/models/auth_result.dart';
import 'package:politia/services/auth_service.dart';
import 'package:politia/services/locale_service.dart';
import 'package:politia/utils/input_detector.dart';
import 'package:politia/widgets/custom_text_field.dart';
import 'package:politia/widgets/language_picker_dialog.dart';
import 'package:politia/widgets/politia_branded_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Validation rule error types for the Step 1 email/mobile field.
enum _SignInValidationError {
  emptyField,
  invalidEmail,
  invalidMobile,
  mobileTooShort,
  notFound,
}

/// Modern Full-Screen Card Sign-In Screen with 2-step progressive authentication,
/// social authentication buttons (Google, Facebook, Apple), smooth slide-up entry animation,
/// full 7-locale internationalization (RTL/LTR dynamic), profile preview, and 6-digit OTP fallback.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  // Slide-up + Fade-in Animation Controller
  late final AnimationController _cardAnimationController;
  late final Animation<Offset> _cardSlideAnimation;
  late final Animation<double> _cardFadeAnimation;

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
  String? _fieldError;

  // OTP Resend Timer
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _loadSecurityState();

    // 700ms EaseOutCubic Slide-up (starts OFF screen below bottom) + Fade-in
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _cardFadeAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    );

    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
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
  // MULTI-LANGUAGE VALIDATION ERROR RESOLUTION (7 LANGUAGES)
  // =========================================================================
  String _getLocalizedValidationError(_SignInValidationError error, String langCode) {
    switch (error) {
      case _SignInValidationError.emptyField:
        switch (langCode) {
          case 'ar':
            return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
          case 'fr':
            return 'Veuillez entrer votre email ou numéro de téléphone';
          case 'it':
            return 'Inserisci la tua email o numero di telefono';
          case 'de':
            return 'Bitte E-Mail oder Handynummer eingeben';
          case 'es':
            return 'Por favor ingresa tu email o número de teléfono';
          case 'cop':
            return 'Ⲉⲛⲧⲁⲗ ⲡⲉⲕⲓⲙⲉⲓⲗ ⲏ ⲛⲟⲙⲉⲣⲟ';
          case 'en':
          default:
            return 'Please enter your email or mobile number';
        }

      case _SignInValidationError.invalidEmail:
        switch (langCode) {
          case 'ar':
            return 'يرجى إدخال بريد إلكتروني صحيح';
          case 'fr':
            return 'Veuillez entrer une adresse email valide';
          case 'it':
            return 'Inserisci un indirizzo email valido';
          case 'de':
            return 'Bitte eine gültige E-Mail-Adresse eingeben';
          case 'es':
            return 'Por favor ingresa un email válido';
          case 'cop':
            return 'Ⲉⲛⲧⲁⲗ ⲟⲩⲓⲙⲉⲓⲗ ⲉⲧϣⲟⲡ';
          case 'en':
          default:
            return 'Please enter a valid email address';
        }

      case _SignInValidationError.invalidMobile:
        switch (langCode) {
          case 'ar':
            return 'يرجى إدخال رقم هاتف مصري صحيح';
          case 'fr':
            return 'Veuillez entrer un numéro de téléphone égyptien valide';
          case 'it':
            return 'Inserisci un numero di telefono egiziano valido';
          case 'de':
            return 'Bitte eine gültige ägyptische Handynummer eingeben';
          case 'es':
            return 'Por favor ingresa un número de teléfono egipcio válido';
          case 'cop':
            return 'Ⲉⲛⲧⲁⲗ ⲟⲩⲛⲟⲙⲉⲣⲟ ⲛ̀ⲣⲉⲙⲛⲭⲏⲙⲓ';
          case 'en':
          default:
            return 'Please enter a valid Egyptian mobile number';
        }

      case _SignInValidationError.mobileTooShort:
        switch (langCode) {
          case 'ar':
            return 'رقم الهاتف يجب أن يكون 11 رقماً';
          case 'fr':
            return 'Le numéro de téléphone doit contenir 11 chiffres';
          case 'it':
            return 'Il numero di telefono deve essere di 11 cifre';
          case 'de':
            return 'Handynummer muss 11 Ziffern haben';
          case 'es':
            return 'El número de teléfono debe tener 11 dígitos';
          case 'cop':
            return 'Ⲡⲛⲟⲙⲉⲣⲟ ⲟϥⲉ ⲛ̀11 ⲛ̀ⲛⲟⲙⲉⲣⲟ';
          case 'en':
          default:
            return 'Mobile number must be 11 digits';
        }

      case _SignInValidationError.notFound:
        switch (langCode) {
          case 'ar':
            return 'لا يوجد حساب بهذا البريد أو الرقم. يرجى التسجيل أولاً.';
          case 'fr':
            return 'Aucun compte trouvé. Veuillez vous inscrire d\'abord.';
          case 'it':
            return 'Nessun account trovato. Per favore registrati prima.';
          case 'de':
            return 'Kein Konto gefunden. Bitte zuerst registrieren.';
          case 'es':
            return 'No se encontró cuenta. Por favor regístrate primero.';
          case 'cop':
            return 'Ⲙⲉⲛ ⲗⲟⲅⲁⲣⲓⲁⲥⲙⲟⲥ. Ⲉⲛⲧⲁⲗ ⲛ̀ⲥⲱⲧⲡ ⲛ̀ϣⲟⲣⲡ.';
          case 'en':
          default:
            return 'No account found. Please sign up first.';
        }
    }
  }

  // =========================================================================
  // STEP 1: IDENTITY LOOKUP & VALIDATION
  // =========================================================================
  Future<void> _handleStep1Continue() async {
    final rawInput = _identityController.text.trim();
    final langCode = (LocaleService.instance.currentLocale?.languageCode ??
            Localizations.localeOf(context).languageCode)
        .toLowerCase();

    // 1. EMPTY FIELD VALIDATION
    if (rawInput.isEmpty) {
      setState(() {
        _fieldError = _getLocalizedValidationError(_SignInValidationError.emptyField, langCode);
        _errorMessage = null;
      });
      return;
    }

    // 2. INPUT TYPE DETECTION & VALIDATION
    final inputType = InputDetector.detect(rawInput);

    if (inputType == InputType.unrecognized) {
      final bool hasAlpha = RegExp(r'[a-zA-Z]').hasMatch(rawInput);
      final bool hasAt = rawInput.contains('@');
      if (hasAt || hasAlpha) {
        setState(() {
          _fieldError = _getLocalizedValidationError(_SignInValidationError.invalidEmail, langCode);
          _errorMessage = null;
        });
      } else {
        final digits = rawInput.replaceAll(RegExp(r'\D'), '');
        if (digits.startsWith('01') && digits.length < 11) {
          setState(() {
            _fieldError = _getLocalizedValidationError(_SignInValidationError.mobileTooShort, langCode);
            _errorMessage = null;
          });
        } else {
          setState(() {
            _fieldError = _getLocalizedValidationError(_SignInValidationError.invalidMobile, langCode);
            _errorMessage = null;
          });
        }
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _fieldError = null;
      _errorMessage = null;
    });

    try {
      final exists = await SupabaseService.instance.checkUserExists(rawInput);
      if (!exists) {
        if (!mounted) return;
        setState(() {
          if (inputType == InputType.memberId) {
            _fieldError = 'Member ID not found. Please check and retry.';
          } else {
            _fieldError = _getLocalizedValidationError(_SignInValidationError.notFound, langCode);
          }
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
        _fieldError = null;
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
  // STEP 2: PASSWORD AUTHENTICATION (Email, Phone, Member ID)
  // =========================================================================
  Future<void> _handlePasswordSignIn() async {
    final password = _passwordController.text.trim();
    final l10n = AppLocalizations.of(context);

    if (password.isEmpty) {
      setState(() {
        _errorMessage = l10n.enterPassword;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final identityInput = _identityController.text.trim();
      final authResult = await AuthService().signInWithCredentials(
        input: identityInput,
        password: password,
      );

      if (authResult.status == AuthStatus.success) {
        final user = authResult.user;
        if (user != null) {
          await SignInService.instance.resetFailedAttempts();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(InitializationService.prefKeyUuid, user.id);
        }

        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        final updatedAttempts = await SignInService.instance.incrementFailedAttempts();
        final remaining = (SignInService.maxAllowedFailedAttempts - updatedAttempts)
            .clamp(0, SignInService.maxAllowedFailedAttempts);

        if (!mounted) return;
        setState(() {
          _failedAttempts = updatedAttempts;
          if (updatedAttempts >= SignInService.maxAllowedFailedAttempts) {
            _isOtpMode = true;
            _errorMessage = l10n.maxAttemptsOtp;
            _sendOtpCode();
          } else {
            _errorMessage = authResult.message ??
                '${l10n.incorrectPassword} ${l10n.attemptsRemaining(remaining)}';
          }
        });
      }
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
    final l10n = AppLocalizations.of(context);
    try {
      await SupabaseService.instance.sendOtp(identity);
      _startResendTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.otpSent(identity)),
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
    final l10n = AppLocalizations.of(context);
    final token = _otpControllers.map((c) => c.text).join().trim();

    if (token.length < 6) {
      setState(() {
        _errorMessage = l10n.enterFullOtp;
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

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService().signInWithGoogle();
      if (!mounted) return;

      switch (result.status) {
        case AuthStatus.success:
          final user = result.user;
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(InitializationService.prefKeyUuid, user.id);
          }
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/dashboard');
          break;
        case AuthStatus.conflict:
        case AuthStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Something went wrong.'),
            ),
          );
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService().signInWithFacebook();
      if (!mounted) return;

      switch (result.status) {
        case AuthStatus.success:
          final user = result.user;
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(InitializationService.prefKeyUuid, user.id);
          }
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/dashboard');
          break;
        case AuthStatus.conflict:
        case AuthStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Something went wrong.'),
            ),
          );
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService().signInWithApple();
      if (!mounted) return;

      switch (result.status) {
        case AuthStatus.success:
          final user = result.user;
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(InitializationService.prefKeyUuid, user.id);
          }
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/dashboard');
          break;
        case AuthStatus.conflict:
        case AuthStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Something went wrong.'),
            ),
          );
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================================
  // BUILD METHOD & RESPONSIVE CARD LAYOUT
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final langCode = (LocaleService.instance.currentLocale?.languageCode ??
            Localizations.localeOf(context).languageCode)
        .toLowerCase();
    final isRtl = langCode == 'ar' || langCode == 'cop';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.background,
      body: PolitiaBrandedBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 600;

            if (isDesktop) {
              return _buildDesktopLayout(
                context,
                l10n,
                colors,
                isDark,
                langCode,
                isRtl,
              );
            }

            return _buildMobileLayout(
              context,
              l10n,
              colors,
              isDark,
              langCode,
              isRtl,
            );
          },
        ),
      ),
    );
  }

  // =========================================================================
  // MOBILE LAYOUT (Screen width <= 600px)
  // =========================================================================
  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations l10n,
    dynamic colors,
    bool isDark,
    String langCode,
    bool isRtl,
  ) {
    return Stack(
      children: [
        SafeArea(
          bottom: false, // Card extends off screen bottom edge
          child: Column(
            children: [
              // Header Above the Card (Fade-in with 48px space above logo and 24px space below logo)
              FadeTransition(
                opacity: _cardFadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0, bottom: 24.0, left: 20.0, right: 20.0),
                  child: _buildTopHeaderBar(context),
                ),
              ),

              // Full Screen Width Card (Sliding Up from bottom of screen + Fading In)
              Expanded(
                child: SlideTransition(
                  position: _cardSlideAnimation,
                  child: FadeTransition(
                    opacity: _cardFadeAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161513) : colors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: isDark ? const Color(0xFF2A2722) : colors.border,
                            width: 1.2,
                          ),
                          left: BorderSide(
                            color: isDark ? const Color(0xFF2A2722) : colors.border,
                            width: 1.2,
                          ),
                          right: BorderSide(
                            color: isDark ? const Color(0xFF2A2722) : colors.border,
                            width: 1.2,
                          ),
                          bottom: BorderSide.none,
                        ),
                        boxShadow: [
                          if (isDark)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 24,
                              offset: const Offset(0, -4),
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520.0),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
                              child: _currentStep == 1
                                  ? _buildStep1Identify(context, l10n, isDark, langCode)
                                  : _buildStep2Authenticate(context, l10n, isDark),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Globe language icon positioned at the absolute top corner of the screen
        Positioned(
          top: 48,
          right: isRtl ? null : 16,
          left: isRtl ? 16 : null,
          child: FadeTransition(
            opacity: _cardFadeAnimation,
            child: IconButton(
              onPressed: () => LanguageSelectionSheet.show(context),
              icon: const Icon(
                Icons.language_rounded,
                size: 28,
                color: Color(0xFFB8960C),
              ),
              tooltip: l10n.changeLanguage,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // DESKTOP LAYOUT (Screen width > 600px)
  // =========================================================================
  Widget _buildDesktopLayout(
    BuildContext context,
    AppLocalizations l10n,
    dynamic colors,
    bool isDark,
    String langCode,
    bool isRtl,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: FadeTransition(
              opacity: _cardFadeAnimation,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // CARD
                  Container(
                    width: 450,
                    padding: const EdgeInsets.fromLTRB(40, 60, 40, 40),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1C1A17) : colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2A2722) : colors.border,
                        width: 1.2,
                      ),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: _currentStep == 1
                        ? _buildStep1Identify(context, l10n, isDark, langCode)
                        : _buildStep2Authenticate(context, l10n, isDark),
                  ),

                  // LOGO ON TOP EDGE
                  Positioned(
                    top: -36,
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: Image.asset(
                        'assets/images/logo.webp',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.church_rounded,
                          color: Color(0xFFB8960C),
                          size: 44,
                        ),
                      ),
                    ),
                  ),

                  // GLOBE LANGUAGE ICON IN TOP RIGHT
                  Positioned(
                    top: 12,
                    right: isRtl ? null : 12,
                    left: isRtl ? 12 : null,
                    child: IconButton(
                      onPressed: () => LanguageSelectionSheet.show(context),
                      icon: const Icon(
                        Icons.language_rounded,
                        size: 24,
                        color: Color(0xFFB8960C),
                      ),
                      tooltip: l10n.changeLanguage,
                    ),
                  ),

                  // STEP 2 BACK BUTTON IN TOP LEADING
                  if (_currentStep == 2)
                    Positioned(
                      top: 12,
                      left: isRtl ? null : 12,
                      right: isRtl ? 12 : null,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _currentStep = 1;
                            _errorMessage = null;
                            _fieldError = null;
                            _passwordController.clear();
                          });
                        },
                        icon: Icon(
                          isRtl
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          color: colors.textPrimary,
                          size: 20,
                        ),
                        tooltip: l10n.back,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // HEADER BAR (Prominent 80x80 Centered Logo & Step 2 Back Button)
  // =========================================================================
  Widget _buildTopHeaderBar(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);
    final langCode = (LocaleService.instance.currentLocale?.languageCode ??
            Localizations.localeOf(context).languageCode)
        .toLowerCase();
    final isRtl = langCode == 'ar' || langCode == 'cop';

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo centered (plain 80x80 without border or glow)
          Center(
            child: Image.asset(
              'assets/images/logo.webp',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.church_rounded,
                color: Color(0xFFB8960C),
                size: 44,
              ),
            ),
          ),

          // Back button pinned to leading edge (if Step 2)
          if (_currentStep == 2)
            Positioned(
              left: isRtl ? null : 0,
              right: isRtl ? 0 : null,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                    _errorMessage = null;
                    _fieldError = null;
                    _passwordController.clear();
                  });
                },
                icon: Icon(
                  isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
                  color: colors.textPrimary,
                  size: 20,
                ),
                tooltip: l10n.back,
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP 1: IDENTIFY WIDGET (Email or Egyptian Phone + Social Logins)
  // =========================================================================
  Widget _buildStep1Identify(BuildContext context, AppLocalizations l10n, bool isDark, String langCode) {
    final colors = context.appColors;
    final buttonColor = isDark ? const Color(0xFF9A7A0A) : colors.primary;
    final socialBorderColor = const Color(0xFFB8960C).withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. "WELCOME" label (small, spaced letters)
        Text(
          l10n.welcome,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 13,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),

        // 2. "SIGN IN" title (large, bold) — 4px below
        const SizedBox(height: 4),
        Text(
          l10n.signIn,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),

        // 3. Description text — 8px below
        const SizedBox(height: 8),
        Text(
          l10n.signInDescription,
          style: TextStyle(fontSize: 13, color: colors.textMuted),
        ),

        // 4. SizedBox height: 24
        const SizedBox(height: 24),

        // Error Banner (for backend exception errors if any)
        if (_errorMessage != null) ...[
          _buildErrorBanner(_errorMessage!),
          const SizedBox(height: 18),
        ],

        // 5. Email or Mobile Number input field
        CustomAuthTextField(
          label: l10n.emailOrMobile,
          controller: _identityController,
          hintText: l10n.emailOrMobileHint,
          prefixIcon: Icon(Icons.perm_identity_rounded, color: colors.textMuted, size: 20),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleStep1Continue(),
          onChanged: (_) {
            if (_fieldError != null || _errorMessage != null) {
              setState(() {
                _fieldError = null;
                _errorMessage = null;
              });
            }
          },
        ),

        // Error message below input field with fade + slide down animation (300ms)
        _buildFieldError(_fieldError, isDark, langCode),

        // 6. Carrier hint text — 8px below input
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 14, color: const Color(0xFFE5B842).withValues(alpha: 0.9)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                l10n.supportedEgyptianCarriers,
                style: TextStyle(fontSize: 11.5, color: colors.textMuted),
              ),
            ),
          ],
        ),

        // 7. SizedBox height: 24
        const SizedBox(height: 24),

        // 8. Continue button (full width, gold color)
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleStep1Continue,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
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
                    l10n.continueText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        // 9. SizedBox height: 16
        const SizedBox(height: 16),

        // 10. OR divider (——— OR ———) centered
        _buildOrDivider(context, colors, isDark, l10n),

        // 11. SizedBox height: 16
        const SizedBox(height: 16),

        // 12. Continue with Google button (outlined style)
        _buildSocialButton(
          icon: Image.network(
            'https://www.google.com/favicon.ico',
            width: 22,
            height: 22,
            errorBuilder: (_, __, ___) => const Text(
              'G',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
          ),
          text: l10n.continueWithGoogle,
          onTap: _isLoading ? () {} : () => _handleGoogleSignIn(),
          textColor: colors.textPrimary,
          borderColor: socialBorderColor,
        ),

        // 13. SizedBox height: 12
        const SizedBox(height: 12),

        // 14. Continue with Facebook button (outlined style)
        _buildSocialButton(
          icon: const Icon(Icons.facebook, size: 22, color: Color(0xFF1877F2)),
          text: l10n.continueWithFacebook,
          onTap: _isLoading ? () {} : () => _handleFacebookSignIn(),
          textColor: colors.textPrimary,
          borderColor: socialBorderColor,
        ),

        // 15. SizedBox height: 12
        const SizedBox(height: 12),

        // 16. Continue with Apple button (outlined style)
        _buildSocialButton(
          icon: Icon(Icons.apple, size: 23, color: isDark ? Colors.white : Colors.black),
          text: l10n.continueWithApple,
          onTap: _isLoading ? () {} : () => _handleAppleSignIn(),
          textColor: colors.textPrimary,
          borderColor: socialBorderColor,
        ),

        // 17. SizedBox height: 24
        const SizedBox(height: 24),

        // 18. "Don't have an account? SIGN UP" centered
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
                  foregroundColor: buttonColor,
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
  // ANIMATED FIELD ERROR WIDGET (Below Input Field)
  // =========================================================================
  Widget _buildFieldError(String? errorText, bool isDark, String langCode) {
    final isRtl = langCode == 'ar' || langCode == 'cop';
    final errorColor = isDark ? Colors.red.shade400 : Colors.red.shade700;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: (errorText == null || errorText.isEmpty)
          ? const SizedBox.shrink()
          : Padding(
              key: ValueKey<String>(errorText),
              padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
              child: Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 14,
                      color: errorColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        errorText,
                        style: TextStyle(
                          fontSize: 12,
                          color: errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // =========================================================================
  // SOCIAL BUTTON & OR DIVIDER HELPERS
  // =========================================================================
  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context, dynamic colors, bool isDark, AppLocalizations l10n) {
    final dividerColor = isDark
        ? const Color(0xFFB8960C).withValues(alpha: 0.35)
        : const Color(0xFFB8960C).withValues(alpha: 0.30);

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            l10n.orDivider,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: colors.textMuted,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: dividerColor)),
      ],
    );
  }

  // =========================================================================
  // STEP 2: PROFILE PREVIEW & AUTHENTICATION WIDGET
  // =========================================================================
  Widget _buildStep2Authenticate(BuildContext context, AppLocalizations l10n, bool isDark) {
    final colors = context.appColors;
    final profile = _profilePreview;
    final buttonColor = isDark ? const Color(0xFF9A7A0A) : colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. PROFILE CARD PREVIEW
        _buildProfilePreviewCard(profile, colors, isDark, l10n),
        const SizedBox(height: 20),

        // Error / Warning Banner
        if (_errorMessage != null) ...[
          _buildErrorBanner(_errorMessage!),
          const SizedBox(height: 16),
        ],

        // Dynamic Mode: OTP vs Password
        if (_isOtpMode)
          _buildOtpInputSection(l10n, colors, isDark)
        else
          _buildPasswordInputSection(l10n, colors),

        const SizedBox(height: 24),

        // Bottom Action Bar
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
                            _fieldError = null;
                            _passwordController.clear();
                          });
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(l10n.switchAccount),
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
                    backgroundColor: buttonColor,
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
                              ? l10n.verifyAndSignIn
                              : l10n.signIn,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
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

  // =========================================================================
  // PROFILE PREVIEW CARD (Avatar, Full Name, Resolved Phone Number)
  // =========================================================================
  Widget _buildProfilePreviewCard(UserProfilePreview? profile, dynamic colors, bool isDark, AppLocalizations l10n) {
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
            profile?.displayName ?? l10n.registeredMember,
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
  Widget _buildPasswordInputSection(AppLocalizations l10n, dynamic colors) {
    final remaining = (SignInService.maxAllowedFailedAttempts - _failedAttempts).clamp(0, SignInService.maxAllowedFailedAttempts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAuthTextField(
          label: l10n.password,
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
                l10n.attemptsRemaining(remaining),
                style: const TextStyle(fontSize: 12, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
              )
            else
              const SizedBox.shrink(),

            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.contactAdminForgot),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 36),
                foregroundColor: colors.textSecondary,
              ),
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // 6-DIGIT OTP INPUT SECTION
  // =========================================================================
  Widget _buildOtpInputSection(AppLocalizations l10n, dynamic colors, bool isDark) {
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
                    l10n.maxAttemptsOtp,
                    style: const TextStyle(fontSize: 12.5, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),

        Text(
          l10n.enterOtpCode,
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
                    borderSide: BorderSide(
                      color: isDark
                          ? colors.border
                          : const Color(0xFFB8960C).withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? colors.border
                          : const Color(0xFFB8960C).withValues(alpha: 0.5),
                      width: 1.2,
                    ),
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
                l10n.resendCodeIn(_resendCountdown),
                style: TextStyle(fontSize: 12.5, color: colors.textMuted),
              )
            else
              TextButton.icon(
                onPressed: _sendOtpCode,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  l10n.resendCode,
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
              l10n.usePasswordInstead,
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

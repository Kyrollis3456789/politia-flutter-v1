import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/core/theme/app_design_tokens.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/features/auth/registration/widgets/step_illustration_badge.dart';

/// Milestone 2: Contact & Social Presence
/// Built with 3 Atomic Sub-steps, Zero-Scroll Strict Constraints, 
/// Obsidian Dark styling, and bi-directional cross-step navigation.
class Step2ContactSocial extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int initialSubStep;

  const Step2ContactSocial({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
    this.initialSubStep = 0,
  });

  @override
  State<Step2ContactSocial> createState() => _Step2ContactSocialState();
}

class _Step2ContactSocialState extends State<Step2ContactSocial> {
  late final PageController _pageController;
  late int _currentSubStep;

  @override
  void initState() {
    super.initState();
    _currentSubStep = widget.initialSubStep.clamp(0, 2);
    _pageController = PageController(initialPage: _currentSubStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSubStep(int step) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentSubStep = step);
  }

  void _nextSubStep() {
    if (_currentSubStep < 2) {
      _goToSubStep(_currentSubStep + 1);
    } else {
      widget.onNext();
    }
  }

  void _prevSubStep() {
    if (_currentSubStep > 0) {
      _goToSubStep(_currentSubStep - 1);
    } else {
      widget.onBack();
    }
  }

  StepIllustrationType _getIllustrationType(int subStep) {
    switch (subStep) {
      case 0:
        return StepIllustrationType.primaryMobile;
      case 1:
        return StepIllustrationType.emailAddress;
      case 2:
        return StepIllustrationType.socialLinks;
      default:
        return StepIllustrationType.contactInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final badgeHeight = isMobile ? (isKeyboardOpen ? 70.0 : 90.0) : 110.0;

    return PopScope(
      canPop: _currentSubStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentSubStep > 0) {
          _prevSubStep();
        }
      },
      child: Column(
        children: [
          // 1. Persistent Contextual Micro-Animation Badge
          StepIllustrationBadge(
            type: _getIllustrationType(_currentSubStep),
            height: badgeHeight,
          ),

          SizedBox(height: isMobile ? (isKeyboardOpen ? 2 : 4) : 8),

          // 2. Atomic Sub-Step Viewport
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Sub-step 1: Mobile Phone & WhatsApp
                _SubStepMobileWhatsApp(
                  notifier: widget.notifier,
                  onNext: _nextSubStep,
                  onBack: _prevSubStep,
                ),

                // Sub-step 2: Email Address (Live Regex Validation)
                _SubStepEmail(
                  notifier: widget.notifier,
                  onNext: _nextSubStep,
                  onBack: _prevSubStep,
                ),

                // Sub-step 3: Social Profiles (Optional + Skip)
                _SubStepSocialProfiles(
                  notifier: widget.notifier,
                  onNext: () => widget.onNext(),
                  onBack: _prevSubStep,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Reusable Button Styles for Step 2
// ----------------------------------------------------------------------
ButtonStyle _buildPrimaryButtonStyle({
  required BuildContext context,
  required bool isEnabled,
}) {
  final colors = context.appColors;

  return ElevatedButton.styleFrom(
    backgroundColor: isEnabled ? colors.primary : colors.buttonDisabledBackground,
    foregroundColor: isEnabled ? colors.buttonTextOnPrimary : colors.buttonDisabledText,
    disabledBackgroundColor: colors.buttonDisabledBackground,
    disabledForegroundColor: colors.buttonDisabledText,
    shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
    elevation: isEnabled ? 1.5 : 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );
}

// ----------------------------------------------------------------------
// Sub-step 1: Mobile Phone & WhatsApp
// ----------------------------------------------------------------------
class _SubStepMobileWhatsApp extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepMobileWhatsApp({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepMobileWhatsApp> createState() => _SubStepMobileWhatsAppState();
}

class _SubStepMobileWhatsAppState extends State<_SubStepMobileWhatsApp> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  bool _whatsappSameAsMobile = true;
  String? _detectedCarrier;

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _phoneController = TextEditingController(text: draft.primaryPhone);
    _whatsappController = TextEditingController(
      text: draft.whatsappNumber?.isNotEmpty == true ? draft.whatsappNumber : draft.primaryPhone,
    );
    _whatsappSameAsMobile = draft.whatsappNumber == null ||
        draft.whatsappNumber!.isEmpty ||
        draft.whatsappNumber == draft.primaryPhone;
    _updateCarrier(_phoneController.text);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _updateCarrier(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    String? carrier;
    if (digits.length >= 3) {
      if (digits.startsWith('010') || digits.startsWith('10')) {
        carrier = 'Vodafone';
      } else if (digits.startsWith('011') || digits.startsWith('11')) {
        carrier = 'Etisalat';
      } else if (digits.startsWith('012') || digits.startsWith('12')) {
        carrier = 'Orange';
      } else if (digits.startsWith('015') || digits.startsWith('15')) {
        carrier = 'WE';
      }
    }
    if (_detectedCarrier != carrier) {
      setState(() => _detectedCarrier = carrier);
    }
  }

  bool _isPhoneValid(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('01')) return true;
    if (digits.length == 10 && (digits.startsWith('10') || digits.startsWith('11') || digits.startsWith('12') || digits.startsWith('15'))) return true;
    return false;
  }

  bool get _canSubmit {
    if (!_isPhoneValid(_phoneController.text)) return false;
    if (!_whatsappSameAsMobile) {
      if (!_isPhoneValid(_whatsappController.text)) return false;
    }
    return true;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final primary = _phoneController.text.trim();
    final whatsapp = _whatsappSameAsMobile ? primary : _whatsappController.text.trim();

    widget.notifier.updateDraft((d) {
      d.primaryPhone = primary;
      d.whatsappNumber = whatsapp;
    });

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final canSubmit = _canSubmit;

    final inputFill = isDark ? const Color(0xFF161513) : const Color(0xFFF7F5F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isMobile) const SizedBox(height: 8),

                  // Title & Subtitle
                  Text(
                    isArabic ? 'رقم الهاتف المحمول والواتساب' : 'Mobile Phone & WhatsApp',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic
                        ? 'أدخل رقم هاتفك لتأكيد الهوية وتلقي الإشعارات الكنسية'
                        : 'Enter your active mobile number for identity verification',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Primary Mobile Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                      _EgyptianPhoneFormatter(),
                    ],
                    onChanged: (val) {
                      _updateCarrier(val);
                      setState(() {});
                    },
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter mobile number';
                      }
                      if (!_isPhoneValid(val)) {
                        return isArabic ? 'رقم الهاتف غير صالح (11 رقم مصري)' : 'Invalid Egyptian phone (11 digits)';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: isArabic ? 'رقم الهاتف المحمول' : 'Mobile Phone',
                      hintText: '010 1234 5678',
                      filled: true,
                      fillColor: inputFill,
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsetsDirectional.only(end: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: colors.border, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇪🇬', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              '+20',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      suffixIcon: _detectedCarrier != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
                                ),
                                child: Text(
                                  _detectedCarrier!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // WhatsApp Toggle Checkbox
                  InkWell(
                    onTap: () {
                      setState(() {
                        _whatsappSameAsMobile = !_whatsappSameAsMobile;
                        if (_whatsappSameAsMobile) {
                          _whatsappController.text = _phoneController.text;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _whatsappSameAsMobile,
                              activeColor: colors.primary,
                              checkColor: colors.buttonTextOnPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              side: BorderSide(color: colors.primary.withValues(alpha: 0.45)),
                              onChanged: (val) {
                                setState(() {
                                  _whatsappSameAsMobile = val ?? true;
                                  if (_whatsappSameAsMobile) {
                                    _whatsappController.text = _phoneController.text;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isArabic ? 'رقم الواتساب هو نفس رقم الهاتف المحمول' : 'WhatsApp is identical to mobile number',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Animated Separate WhatsApp Number Input
                  AnimatedSize(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOutCubic,
                    child: !_whatsappSameAsMobile
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: _whatsappController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                                _EgyptianPhoneFormatter(),
                              ],
                              onChanged: (_) => setState(() {}),
                              validator: (val) {
                                if (!_whatsappSameAsMobile) {
                                  if (val == null || val.trim().isEmpty) {
                                    return isArabic ? 'يرجى إدخال رقم الواتساب' : 'Please enter WhatsApp number';
                                  }
                                  if (!_isPhoneValid(val)) {
                                    return isArabic ? 'رقم الواتساب غير صالح' : 'Invalid WhatsApp number';
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: isArabic ? 'رقم الواتساب' : 'WhatsApp Number',
                                hintText: '010 1234 5678',
                                filled: true,
                                fillColor: inputFill,
                                prefixIcon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin: const EdgeInsetsDirectional.only(end: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: colors.border, width: 1),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 17,
                                    color: Color(0xFF25D366),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: AppDesignTokens.borderRadiusInput,
                                  borderSide: BorderSide(color: colors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: AppDesignTokens.borderRadiusInput,
                                  borderSide: BorderSide(color: colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: AppDesignTokens.borderRadiusInput,
                                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
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
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
                  ),
                  child: Text(
                    isArabic ? 'السابق' : 'Back',
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submit : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: canSubmit),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: canSubmit ? colors.buttonTextOnPrimary : colors.buttonDisabledText,
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
}

// ----------------------------------------------------------------------
// Sub-step 2: Email Address
// ----------------------------------------------------------------------
class _SubStepEmail extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepEmail({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepEmail> createState() => _SubStepEmailState();
}

class _SubStepEmailState extends State<_SubStepEmail> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notifier.draft.email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEmailValid => _emailRegex.hasMatch(_controller.text.trim());

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _controller.text.trim();

    widget.notifier.updateDraft((d) {
      d.email = email;
    });

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final isValid = _isEmailValid;
    final inputFill = isDark ? const Color(0xFF161513) : const Color(0xFFF7F5F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isMobile) const SizedBox(height: 8),

                  // Title & Subtitle
                  Text(
                    isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic
                        ? 'لتلقي إشعارات الأمان واستعادة الحساب والتواصل الرسمي'
                        : 'For security alerts, account recovery and official communications',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Input Field
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (_) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter email address';
                      }
                      if (!_emailRegex.hasMatch(val.trim())) {
                        return isArabic ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email address format';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                      hintText: 'name@domain.com',
                      filled: true,
                      fillColor: inputFill,
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                      suffixIcon: isValid
                          ? Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: colors.primary,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        borderSide: BorderSide(color: colors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
                  ),
                  child: Text(
                    isArabic ? 'السابق' : 'Back',
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isValid ? _submit : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: isValid),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isValid ? colors.buttonTextOnPrimary : colors.buttonDisabledText,
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
}

// ----------------------------------------------------------------------
// Sub-step 3: Social Profiles (Optional)
// ----------------------------------------------------------------------
class _SubStepSocialProfiles extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepSocialProfiles({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepSocialProfiles> createState() => _SubStepSocialProfilesState();
}

class _SubStepSocialProfilesState extends State<_SubStepSocialProfiles> {
  late final TextEditingController _facebookController;
  late final TextEditingController _instagramController;

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _facebookController = TextEditingController(text: draft.socialLinks['facebook'] ?? '');
    _instagramController = TextEditingController(text: draft.socialLinks['instagram'] ?? '');
  }

  @override
  void dispose() {
    _facebookController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  void _submit() {
    final fb = _facebookController.text.trim();
    final ig = _instagramController.text.trim();

    widget.notifier.updateDraft((d) {
      d.socialLinks = {
        if (fb.isNotEmpty) 'facebook': fb,
        if (ig.isNotEmpty) 'instagram': ig,
      };
    });

    widget.onNext();
  }

  void _skip() {
    widget.notifier.updateDraft((d) {
      d.socialLinks = {};
    });
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final inputFill = isDark ? const Color(0xFF161513) : const Color(0xFFF7F5F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isMobile) const SizedBox(height: 8),

                // Title & Subtitle
                Text(
                  isArabic ? 'الحسابات الاجتماعية' : 'Social Media Profiles',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'اختياري — ربط حساباتك الاجتماعية لتعزيز التواصل المجتمعي'
                      : 'Optional — Connect your social profiles for community networking',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),

                // Facebook Profile Field
                TextField(
                  controller: _facebookController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'رابط فيسبوك أو اسم المستخدم' : 'Facebook Link or Username',
                    hintText: isArabic ? 'facebook.com/username أو @user' : 'facebook.com/user or @user',
                    filled: true,
                    fillColor: inputFill,
                    prefixIcon: const Icon(
                      Icons.facebook_rounded,
                      size: 20,
                      color: Color(0xFF1877F2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Instagram Profile Field
                TextField(
                  controller: _instagramController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'اسم مستخدم إنستغرام أو لينكد إن' : 'Instagram or LinkedIn Handle',
                    hintText: '@username',
                    filled: true,
                    fillColor: inputFill,
                    prefixIcon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Color(0xFFE1306C),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppDesignTokens.borderRadiusInput,
                      borderSide: BorderSide(color: colors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Action Buttons: Back + Skip + Next
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
                  ),
                  child: Text(
                    isArabic ? 'السابق' : 'Back',
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    isArabic ? 'تخطي مؤقتاً' : 'Skip for now',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: true),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.buttonTextOnPrimary,
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
}

// ----------------------------------------------------------------------
// Egyptian Phone Mask Formatter: 010 1234 5678
// ----------------------------------------------------------------------
class _EgyptianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 7) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

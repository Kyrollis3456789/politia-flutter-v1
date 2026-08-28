import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:politia/core/services/connectivity_service.dart';
import 'package:politia/core/services/name_transliteration_service.dart';
import 'package:politia/core/services/name_suggestion_service.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/core/theme/app_design_tokens.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/features/auth/registration/widgets/live_coptic_id_card_badge.dart';
import 'package:politia/features/auth/registration/widgets/national_id_decoder.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Helper for consistent primary button visual depth and contrast across all sub-steps.
ButtonStyle _buildPrimaryButtonStyle({
  required BuildContext context,
  required bool isEnabled,
}) {
  final colors = context.appColors;
  return ElevatedButton.styleFrom(
    backgroundColor: colors.primary,
    foregroundColor: const Color(0xFF1A140E),
    disabledBackgroundColor: const Color(0x1AE5B842),
    disabledForegroundColor: const Color(0x99E5B842),
    side: isEnabled
        ? BorderSide.none
        : const BorderSide(color: Color(0x33E5B842), width: 1.0),
    shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
    elevation: 0,
  );
}

/// Step 1: Personal Identity with Persistent Progressive ID Card,
/// 7 Logical Sub-Steps, Anti-Fraud Blind Validation, and Desktop-Safe Photo Picker.
class Step1PersonalInfo extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int initialSubStep;

  const Step1PersonalInfo({
    super.key,
    required this.notifier,
    required this.onNext,
    this.onBack,
    this.initialSubStep = 0,
  });

  @override
  State<Step1PersonalInfo> createState() => _Step1PersonalInfoState();
}

class _Step1PersonalInfoState extends State<Step1PersonalInfo> {
  late final PageController _pageController;
  late int _currentSubStep;

  @override
  void initState() {
    super.initState();
    _currentSubStep = widget.initialSubStep.clamp(0, 6);
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
    if (_currentSubStep < 6) {
      _goToSubStep(_currentSubStep + 1);
    } else {
      widget.onNext();
    }
  }

  void _prevSubStep() {
    if (_currentSubStep > 0) {
      _goToSubStep(_currentSubStep - 1);
    } else {
      if (widget.onBack != null) {
        widget.onBack!();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

    // Dynamic Card Sizing:
    // On Mobile with keyboard open: ~120px height, compact margins.
    // On Mobile closed: ~155px height.
    // On Desktop: 350px width with 1.586 aspect ratio.
    final double? cardWidth = isMobile ? null : 350.0;
    final double? cardHeight = isMobile ? (isKeyboardOpen ? 120.0 : 155.0) : null;
    final EdgeInsetsGeometry cardMargin = isMobile
        ? (isKeyboardOpen
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 2)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 4))
        : const EdgeInsets.only(bottom: 18);

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
          // 1. Persistent Progressive 3D Church ID Card (Anchored at Top)
          ListenableBuilder(
            listenable: widget.notifier,
            builder: (context, _) {
              final draft = widget.notifier.draft;
              final bool showBackFace = _currentSubStep == 1 || _currentSubStep == 3 || _currentSubStep == 5;
              return LiveCopticIdCardBadge(
                englishName: draft.fullNameEn,
                arabicName: draft.fullNameAr,
                nickname: draft.nickname,
                gender: draft.gender,
                dateOfBirth: draft.dateOfBirth,
                nationalId: draft.nationalId,
                avatarPath: draft.avatarPath,
                showBackFace: showBackFace,
                isComplete: _currentSubStep >= 5 && (draft.nationalId?.isNotEmpty == true),
                width: cardWidth,
                height: cardHeight,
                margin: cardMargin,
              );
            },
          ),

          if (isMobile) SizedBox(height: isKeyboardOpen ? 4 : 6),

          // 2. Sub-step Content PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Sub-step 1: English Full Name
                _SubStepEnglishName(
                  notifier: widget.notifier,
                  onNext: _nextSubStep,
                ),

              // Sub-step 2: Arabic Full Name (Pre-filled via auto-transliteration)
              _SubStepArabicName(
                notifier: widget.notifier,
                onNext: _nextSubStep,
                onBack: _prevSubStep,
              ),

              // Sub-step 3: Preferred Nickname (Optional / Skip)
              _SubStepNickname(
                notifier: widget.notifier,
                onNext: _nextSubStep,
                onBack: _prevSubStep,
              ),

              // Sub-step 4: Gender Selection
              _SubStepGender(
                notifier: widget.notifier,
                onNext: _nextSubStep,
                onBack: _prevSubStep,
              ),

              // Sub-step 5: Date of Birth Selection
              _SubStepDateOfBirth(
                notifier: widget.notifier,
                onNext: _nextSubStep,
                onBack: _prevSubStep,
              ),

              // Sub-step 6: National ID (14 digits + Anti-Fraud Blind Validation)
              _SubStepNationalId(
                notifier: widget.notifier,
                onNext: _nextSubStep,
                onBack: _prevSubStep,
              ),

              // Sub-step 7: Profile Photo Upload (Desktop-Safe)
              _SubStepProfileImage(
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
// Sub-step 1: Full Name in English
// ----------------------------------------------------------------------
class _SubStepEnglishName extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;

  const _SubStepEnglishName({
    required this.notifier,
    required this.onNext,
  });

  @override
  State<_SubStepEnglishName> createState() => _SubStepEnglishNameState();
}

class _SubStepEnglishNameState extends State<_SubStepEnglishName> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isLoading = false;
  String? _duplicateError;
  String? _formatWarning;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notifier.draft.fullNameEn);
    _wordCount = _controller.text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  void _updateWordCount(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    setState(() {
      _wordCount = words;
      _duplicateError = null;
    });
    widget.notifier.updateDraft((d) => d.fullNameEn = text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> checkEnglishNameExists(String name) async {
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('id')
          .ilike('full_name_en', name.trim())
          .limit(1);
      return (res as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submit() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (!ConnectivityService.instance.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'لا يوجد اتصال بالإنترنت. يرجى الاتصال للمتابعة.'
                : 'No internet connection. Please connect to proceed.',
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (_wordCount < 4) return;
    final name = _controller.text.trim();

    setState(() => _isLoading = true);
    try {
      final exists = await checkEnglishNameExists(name);

      if (exists == true) {
        setState(() {
          _duplicateError = isArabic
              ? "يوجد حساب مسجل بهذا الاسم بالفعل. يرجى إضافة اسم خامس للمتابعة."
              : "An account with this name already exists. Please add a 5th name to continue.";
        });
      } else {
        widget.notifier.updateDraft((d) => d.fullNameEn = name);

        // Auto-transliterate English name into Arabic before navigating to Sub-step 2
        if (widget.notifier.draft.fullNameAr.trim().isEmpty) {
          final autoArabic = await NameTransliterationService.transliterate(name);
          if (autoArabic.isNotEmpty) {
            widget.notifier.updateDraft((d) => d.fullNameAr = autoArabic);
          }
        }

        widget.onNext();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking name: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final bool canSubmit = !_isLoading && _wordCount >= 4;

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

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      isArabic
                          ? 'ما هو اسمك الكامل باللغة الإنجليزية؟'
                          : 'What is your full English name?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  CustomAuthTextField(
                    label: isArabic ? 'الاسم بالإنجليزية (4 مقاطع على الأقل)' : 'Full Name',
                    controller: _controller,
                    hintText: isArabic ? 'الاسم بالإنجليزية (4 مقاطع على الأقل)' : 'e.g., First Father Grandfather Family',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    isValid: canSubmit,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: colors.textMuted,
                      size: AppDesignTokens.iconRegular,
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      if (canSubmit) _submit();
                    },
                    inputFormatters: [
                      EnglishNameFormatter(
                        onInvalidChar: () {
                          setState(() {
                            _formatWarning = isArabic
                                ? "يرجى استخدام الحروف الإنجليزية فقط (الشرطات مسموحة)."
                                : "Please use English letters only (hyphens and underscores are allowed).";
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) setState(() => _formatWarning = null);
                          });
                        },
                      ),
                    ],
                    onChanged: _updateWordCount,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isArabic ? 'الاسم بالإنجليزية مطلوب' : 'English name is required';
                      }
                      if (_wordCount < 4 && _duplicateError == null) {
                        return isArabic ? 'يرجى كتابة 4 أسماء على الأقل' : 'Please enter at least 4 names';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  if (_formatWarning != null) ...[
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 15, color: colors.statusError),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatWarning!,
                            style: TextStyle(fontSize: 12, color: colors.statusError, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  if (_duplicateError != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.statusWarning.withValues(alpha: 0.12),
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        border: Border.all(color: colors.statusWarning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 18, color: colors.statusWarning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _duplicateError!,
                              style: TextStyle(color: colors.statusWarning, fontSize: 12.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: canSubmit ? _submit : null,
            style: _buildPrimaryButtonStyle(context: context, isEnabled: canSubmit),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Color(0xFF1A140E), strokeWidth: 2.2),
                  )
                : Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: canSubmit ? const Color(0xFF1A140E) : const Color(0x99E5B842),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class EnglishNameFormatter extends TextInputFormatter {
  final VoidCallback? onInvalidChar;

  EnglishNameFormatter({this.onInvalidChar});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    if (RegExp(r'[^a-zA-Z\-_ ]').hasMatch(newValue.text)) {
      onInvalidChar?.call();
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[^a-zA-Z\-_ ]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s{2,}'), ' ');

    List<String> words = cleaned.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + (word.length > 1 ? word.substring(1).toLowerCase() : '');
    }).toList();

    String resultText = capitalizedWords.join(' ');

    int cursorOffset = resultText.length < newValue.selection.baseOffset
        ? resultText.length
        : newValue.selection.baseOffset;

    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}

// ----------------------------------------------------------------------
// Sub-step 2: Full Name in Arabic (Pre-filled from Auto-Transliteration)
// ----------------------------------------------------------------------
class _SubStepArabicName extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepArabicName({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepArabicName> createState() => _SubStepArabicNameState();
}

class _SubStepArabicNameState extends State<_SubStepArabicName> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isLoading = false;
  String? _duplicateError;
  String? _formatWarning;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notifier.draft.fullNameAr);
    _wordCount = _controller.text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  void _updateWordCount(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    setState(() {
      _wordCount = words;
      _duplicateError = null;
    });
    widget.notifier.updateDraft((d) => d.fullNameAr = text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> checkArabicNameExists(String name) async {
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('id')
          .ilike('full_name_ar', name.trim())
          .limit(1);
      return (res as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submit() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (!ConnectivityService.instance.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'لا يوجد اتصال بالإنترنت. يرجى الاتصال للمتابعة.'
                : 'No internet connection. Please connect to proceed.',
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (_wordCount < 4) return;
    final name = _controller.text.trim();

    setState(() => _isLoading = true);
    try {
      final exists = await checkArabicNameExists(name);
      if (exists) {
        setState(() {
          _duplicateError = isArabic
              ? "يوجد حساب مسجل بهذا الاسم بالفعل. يرجى إضافة اسم خامس للمتابعة."
              : "An account with this name already exists. Please add a 5th name to continue.";
        });
        return;
      }

      widget.notifier.updateDraft((d) => d.fullNameAr = name);
      widget.onNext();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking Arabic name: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final bool canSubmit = !_isLoading && _wordCount >= 4;

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

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      isArabic ? 'ما هو اسمك الكامل باللغة العربية؟' : 'What is your full Arabic name?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  CustomAuthTextField(
                    label: isArabic ? 'الاسم باللغة العربية (4 مقاطع على الأقل)' : 'Full Name (Arabic)',
                    controller: _controller,
                    hintText: 'الاسم الرباعي باللغة العربية',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    isValid: canSubmit,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      if (canSubmit) _submit();
                    },
                    inputFormatters: [
                      ArabicNameFormatter(
                        onInvalidChar: () {
                          setState(() {
                            _formatWarning = isArabic
                                ? "يرجى استخدام الحروف العربية فقط."
                                : "Please use Arabic letters only.";
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) setState(() => _formatWarning = null);
                          });
                        },
                      ),
                    ],
                    onChanged: _updateWordCount,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isArabic ? 'الاسم بالعربية مطلوب' : 'Arabic name is required';
                      }
                      if (_wordCount < 4 && _duplicateError == null) {
                        return isArabic ? 'يرجى كتابة 4 أسماء على الأقل' : 'Please enter at least 4 names in Arabic';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  if (_formatWarning != null) ...[
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 15, color: colors.statusError),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatWarning!,
                            style: TextStyle(fontSize: 12, color: colors.statusError, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  if (_duplicateError != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.statusWarning.withValues(alpha: 0.12),
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        border: Border.all(color: colors.statusWarning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 18, color: colors.statusWarning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _duplicateError!,
                              style: TextStyle(color: colors.statusWarning, fontSize: 12.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
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
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Color(0xFF1A140E), strokeWidth: 2.2),
                        )
                      : Text(
                          isArabic ? 'التالي' : 'Next',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: canSubmit ? const Color(0xFF1A140E) : const Color(0x99E5B842),
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

class ArabicNameFormatter extends TextInputFormatter {
  final VoidCallback? onInvalidChar;

  ArabicNameFormatter({this.onInvalidChar});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    if (RegExp(r'[^\u0621-\u064A\s]').hasMatch(newValue.text)) {
      onInvalidChar?.call();
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s{2,}'), ' ');

    int cursorOffset = cleaned.length < newValue.selection.baseOffset
        ? cleaned.length
        : newValue.selection.baseOffset;

    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}

// ----------------------------------------------------------------------
// Sub-step 3: Nickname (Preferred Handle)
// ----------------------------------------------------------------------
class _SubStepNickname extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepNickname({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepNickname> createState() => _SubStepNicknameState();
}

class _SubStepNicknameState extends State<_SubStepNickname> {
  late final TextEditingController _controller;
  ({String en, String ar})? _suggestion;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notifier.draft.nickname);
    _suggestion = NameSuggestionService.suggestNickname(
      fullNameEn: widget.notifier.draft.fullNameEn,
      fullNameAr: widget.notifier.draft.fullNameAr,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applySuggestion(String text) {
    setState(() {
      _controller.text = text;
    });
    widget.notifier.updateDraft((d) => d.nickname = text.trim());
  }

  void _submit() {
    widget.notifier.updateDraft((d) => d.nickname = _controller.text.trim());
    widget.onNext();
  }

  void _skip() {
    _controller.clear();
    widget.notifier.updateDraft((d) => d.nickname = null);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

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

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    isArabic
                        ? 'ما هو اسم الشهرة أو اللقب المفضل لديك؟'
                        : 'What is your preferred nickname?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                CustomAuthTextField(
                  label: isArabic ? 'اسم الشهرة (اختياري)' : 'Nickname / Handle',
                  controller: _controller,
                  hintText: isArabic ? 'مثال: كيرو، مينو (اختياري)' : 'e.g. Kiro, Mino (Optional)',
                  textInputAction: TextInputAction.next,
                  onChanged: (val) => widget.notifier.updateDraft((d) => d.nickname = val.trim()),
                  onFieldSubmitted: (_) => _submit(),
                ),

                // Interactive Smart Nickname Suggestion Chip
                if (_suggestion != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'اقتراح مخصص:' : 'Suggested handle:',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                        ActionChip(
                          avatar: Icon(Icons.auto_awesome_rounded, size: 14, color: colors.primary),
                          label: Text(
                            isArabic ? _suggestion!.ar : _suggestion!.en,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          backgroundColor: colors.primary.withValues(alpha: 0.12),
                          side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () => _applySuggestion(isArabic ? _suggestion!.ar : _suggestion!.en),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Unified Fixed Navigation Bar: Back (Left) + Skip (Center) + Next (Right)
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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
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
                  child: Text(isArabic ? 'تخطي' : 'Skip', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600)),
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
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A140E)),
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
// Sub-step 4: Gender Selection (Logical Order)
// ----------------------------------------------------------------------
class _SubStepGender extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepGender({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepGender> createState() => _SubStepGenderState();
}

class _SubStepGenderState extends State<_SubStepGender> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.notifier.draft.gender;
  }

  void _select(String gender) {
    setState(() => _selectedGender = gender);
    widget.notifier.updateDraft((d) => d.gender = gender);
  }

  void _submit() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'يرجى اختيار النوع.' : 'Please select your gender.')),
      );
      return;
    }
    widget.notifier.updateDraft((d) => d.gender = _selectedGender);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

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

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    isArabic ? 'اختر النوع' : 'Select your gender',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Visual Choice Cards for Gender
                Row(
                  children: [
                    // Male Card
                    Expanded(
                      child: _buildGenderCard(
                        gender: 'male',
                        title: isArabic ? 'ذكر' : 'Male',
                        icon: Icons.person_rounded,
                        isSelected: _selectedGender == 'male',
                        colors: colors,
                        isDark: isDark,
                        onTap: () => _select('male'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Female Card
                    Expanded(
                      child: _buildGenderCard(
                        gender: 'female',
                        title: isArabic ? 'أنثى' : 'Female',
                        icon: Icons.person_2_rounded,
                        isSelected: _selectedGender == 'female',
                        colors: colors,
                        isDark: isDark,
                        onTap: () => _select('female'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedGender != null ? _submit : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: _selectedGender != null),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _selectedGender != null ? const Color(0xFF1A140E) : const Color(0x99E5B842),
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

  Widget _buildGenderCard({
    required String gender,
    required String title,
    required IconData icon,
    required bool isSelected,
    required AppColorsExtension colors,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: isDark ? 0.16 : 0.10)
              : colors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: isDark ? 0.25 : 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Sub-step 5: Date of Birth Selection (Logical Order)
// ----------------------------------------------------------------------
class _SubStepDateOfBirth extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepDateOfBirth({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepDateOfBirth> createState() => _SubStepDateOfBirthState();
}

class _SubStepDateOfBirthState extends State<_SubStepDateOfBirth> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.notifier.draft.dateOfBirth;
    if (_selectedDate != null) {
      _controller = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_selectedDate!),
      );
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDateChanged(String val) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final digits = val.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 8) {
      final day = int.tryParse(digits.substring(0, 2));
      final month = int.tryParse(digits.substring(2, 4));
      final year = int.tryParse(digits.substring(4, 8));
      final now = DateTime.now();

      if (day == null || day < 1 || day > 31) {
        setState(() {
          _errorMessage = isArabic ? "يوم غير صالح (01-31)" : "Invalid day (01-31)";
          _selectedDate = null;
        });
        widget.notifier.updateDraft((d) => d.dateOfBirth = null);
        return;
      }

      if (month == null || month < 1 || month > 12) {
        setState(() {
          _errorMessage = isArabic ? "شهر غير صالح (01-12)" : "Invalid month (01-12)";
          _selectedDate = null;
        });
        widget.notifier.updateDraft((d) => d.dateOfBirth = null);
        return;
      }

      if (year == null || year < 1920 || year > now.year) {
        setState(() {
          _errorMessage = isArabic
              ? "السنة يجب أن تكون بين 1920 و ${now.year}"
              : "Year must be between 1920 and ${now.year}";
          _selectedDate = null;
        });
        widget.notifier.updateDraft((d) => d.dateOfBirth = null);
        return;
      }

      try {
        final dt = DateTime(year, month, day);
        if (dt.year == year && dt.month == month && dt.day == day && !dt.isAfter(now)) {
          setState(() {
            _selectedDate = dt;
            _errorMessage = null;
          });
          widget.notifier.updateDraft((d) => d.dateOfBirth = dt);
        } else {
          setState(() {
            _errorMessage = isArabic ? "تاريخ غير صالح في التقويم" : "Invalid calendar date";
            _selectedDate = null;
          });
          widget.notifier.updateDraft((d) => d.dateOfBirth = null);
        }
      } catch (_) {
        setState(() {
          _errorMessage = isArabic ? "تاريخ غير صالح" : "Invalid date";
          _selectedDate = null;
        });
        widget.notifier.updateDraft((d) => d.dateOfBirth = null);
      }
    } else {
      if (_selectedDate != null || _errorMessage != null) {
        setState(() {
          _selectedDate = null;
          _errorMessage = null;
        });
        widget.notifier.updateDraft((d) => d.dateOfBirth = null);
      }
    }
  }

  Future<void> _pickDate() async {
    final colors = context.appColors;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: colors.primary,
                  onPrimary: colors.buttonTextOnPrimary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _selectedDate = picked;
        _controller.text = formatted;
        _errorMessage = null;
      });
      widget.notifier.updateDraft((d) => d.dateOfBirth = picked);
    }
  }

  void _submit() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'يرجى إدخال تاريخ ميلاد صالح.' : 'Please enter a valid date of birth.')),
      );
      return;
    }
    widget.notifier.updateDraft((d) => d.dateOfBirth = _selectedDate);
    widget.onNext();
  }

  int? get _calculatedAge {
    if (_selectedDate == null) return null;
    final now = DateTime.now();
    int age = now.year - _selectedDate!.year;
    if (now.month < _selectedDate!.month ||
        (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
      age--;
    }
    return age >= 0 ? age : null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

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

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    isArabic ? 'تاريخ الميلاد' : 'Date of Birth',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                CustomAuthTextField(
                  label: isArabic ? 'تاريخ الميلاد' : 'Date of Birth',
                  controller: _controller,
                  hintText: isArabic ? 'يوم / شهر / سنة' : 'DD/MM/YYYY',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  isValid: _selectedDate != null,
                  prefixIcon: Icon(
                    Icons.cake_outlined,
                    color: colors.textMuted,
                    size: AppDesignTokens.iconRegular,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_month_rounded,
                      color: _selectedDate != null ? colors.primary : colors.textSecondary,
                      size: 20,
                    ),
                    tooltip: isArabic ? 'اختيار من التقويم' : 'Open calendar',
                    onPressed: _pickDate,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
                    _DateInputFormatter(),
                  ],
                  onChanged: _onDateChanged,
                  onFieldSubmitted: (_) {
                    if (_selectedDate != null) _submit();
                  },
                ),

                // Live Age Calculation Badge
                if (_selectedDate != null && _calculatedAge != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: const Color(0x1AE5B842),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0x33E5B842), width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cake_rounded,
                            size: 13,
                            color: Color(0xCCE5B842),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isArabic
                                ? 'العمر: $_calculatedAge سنة'
                                : 'Age: $_calculatedAge years old',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xCCE5B842),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (_errorMessage != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 14, color: colors.statusError),
                      const SizedBox(width: 6),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.statusError,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedDate != null ? _submit : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: _selectedDate != null),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _selectedDate != null ? const Color(0xFF1A140E) : const Color(0x99E5B842),
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

/// Formatter that automatically inserts slashes to produce DD/MM/YYYY format
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final limitedDigits = digits.length > 8 ? digits.substring(0, 8) : digits;
    final buffer = StringBuffer();

    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(limitedDigits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ----------------------------------------------------------------------
// Sub-step 6: National ID with Anti-Fraud Blind Validation
// ----------------------------------------------------------------------
class _SubStepNationalId extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepNationalId({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepNationalId> createState() => _SubStepNationalIdState();
}

class _SubStepNationalIdState extends State<_SubStepNationalId> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isLoading = false;
  String? _securityError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notifier.draft.nationalId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _securityError = null);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (!ConnectivityService.instance.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'لا يوجد اتصال بالإنترنت. يرجى الاتصال للمتابعة.'
                : 'No internet connection. Please connect to proceed.',
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    final val = _controller.text.trim();

    if (val.length != 14) return;

    // 1. Anti-Fraud Blind Decoding & Demographic Comparison
    final res = NationalIdResult.decode(val);
    if (!res.isValid || res.birthDate == null || res.gender == null) {
      setState(() {
        _securityError = isArabic
            ? "الرقم القومي المُدخل لا يتطابق مع البيانات الشخصية المحددة. يرجى مراجعة بياناتك."
            : "The National ID entered does not match your provided personal details. Please verify your data.";
      });
      return;
    }

    final providedDob = widget.notifier.draft.dateOfBirth;
    final providedGender = widget.notifier.draft.gender;

    bool matchDob = true;
    if (providedDob != null) {
      matchDob = providedDob.year == res.birthDate!.year &&
          providedDob.month == res.birthDate!.month &&
          providedDob.day == res.birthDate!.day;
    }

    bool matchGender = true;
    if (providedGender != null) {
      matchGender = providedGender.toLowerCase() == res.gender!.toLowerCase();
    }

    // Strict Blind Security Match: Do not leak internal clues
    if (!matchDob || !matchGender) {
      setState(() {
        _securityError = isArabic
            ? "الرقم القومي المُدخل لا يتطابق مع البيانات الشخصية المحددة. يرجى مراجعة بياناتك."
            : "The National ID entered does not match your provided personal details. Please verify your data.";
      });
      return;
    }

    // 2. Supabase Uniqueness Check
    setState(() => _isLoading = true);
    try {
      final existingUser = await Supabase.instance.client
          .from('profiles')
          .select('id')
          .eq('national_id', val)
          .maybeSingle();

      if (existingUser != null) {
        setState(() {
          _securityError = isArabic
              ? "هذا الرقم القومي مسجل مسبقاً."
              : "This National ID is already registered.";
        });
        return;
      }

      // Valid & Verified
      widget.notifier.updateDraft((d) {
        d.nationalId = val;
        d.birthLocation = res.governorate;
      });

      widget.onNext();
    } catch (e) {
      setState(() {
        _securityError = isArabic
            ? "تعذر التحقق من الرقم القومي. يرجى التأكد من اتصال الإنترنت والمحاولة مجدداً."
            : "Could not verify National ID. Please check your internet connection and try again.";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

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

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      isArabic
                          ? 'ما هو الرقم القومي الخاص بك (14 رقماً)؟'
                          : 'What is your 14-digit National ID number?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  CustomAuthTextField(
                    label: isArabic ? 'الرقم القومي (14 رقماً)' : 'National ID (14 digits)',
                    controller: _controller,
                    hintText: isArabic ? 'أدخل 14 رقماً' : 'Enter 14 digits',
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    showCounter: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      setState(() => _securityError = null);
                      widget.notifier.updateDraft((d) => d.nationalId = val.trim());
                    },
                    onFieldSubmitted: (_) => _submit(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isArabic ? 'الرقم القومي مطلوب' : 'National ID is required';
                      }
                      if (val.trim().length != 14) {
                        return isArabic ? 'يجب أن يتكون من 14 رقماً بالتمام' : 'Must be exactly 14 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Security Neutral Error Banner
                  if (_securityError != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.statusError.withValues(alpha: 0.12),
                        borderRadius: AppDesignTokens.borderRadiusInput,
                        border: Border.all(color: colors.statusError.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.security_rounded, size: 16, color: colors.statusError),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _securityError!,
                              style: TextStyle(
                                color: colors.statusError,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: !_isLoading ? _submit : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: !_isLoading),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Color(0xFF1A140E), strokeWidth: 2.2),
                        )
                      : Text(
                          isArabic ? 'التالي' : 'Next',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A140E)),
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
// Sub-step 7: Profile Image Upload (Optional / Skip)
// ----------------------------------------------------------------------
class _SubStepProfileImage extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SubStepProfileImage({
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_SubStepProfileImage> createState() => _SubStepProfileImageState();
}

class _SubStepProfileImageState extends State<_SubStepProfileImage> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.notifier.draft.avatarPath;
  }

  void _showImageSourceModal() {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;

    if (!isMobile) {
      // Desktop / Large Screen Dialog
      showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 360,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161513),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x33E5B842),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Title & Close (X) Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? 'اختر مصدر الصورة' : 'Select Photo Source',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close_rounded, size: 20, color: Color(0x99FFFFFF)),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Option 1: Camera Card
                    _buildOptionCard(
                      ctx: ctx,
                      icon: Icons.camera_alt_outlined,
                      title: isArabic ? 'التقاط صورة بالكاميرا' : 'Take Photo (Camera)',
                      subtitle: isArabic ? 'موصى به للهواتف المحمولة' : 'Optimized for mobile devices',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _handleCameraSelection();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Option 2: Gallery / Files Card
                    _buildOptionCard(
                      ctx: ctx,
                      icon: Icons.photo_library_outlined,
                      title: isArabic ? 'اختيار من المعرض / الملفات' : 'Choose from Gallery / Files',
                      subtitle: isArabic ? 'تصفح الملفات من جهازك' : 'Browse image files on your device',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _pickAndCropImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Mobile Bottom Sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? 'اختر مصدر الصورة' : 'Select Photo Source',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: colors.primary, size: 20),
                    ),
                    title: Text(
                      isArabic ? 'التقاط صورة بالكاميرا' : 'Take Photo (Camera)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _handleCameraSelection();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.photo_library_outlined, color: colors.primary, size: 20),
                    ),
                    title: Text(
                      isArabic ? 'اختيار من المعرض / الملفات' : 'Choose from Gallery / Files',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _pickAndCropImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildOptionCard({
    required BuildContext ctx,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      hoverColor: const Color(0x14E5B842),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0x26E5B842),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0x80FFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0x60FFFFFF),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraSelection() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // 1. Desktop Platforms (Windows / macOS / Linux): Seamlessly trigger file picker without error/warning snackbars
    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      _pickAndCropImage(ImageSource.gallery);
      return;
    }

    // 2. Mobile Platforms (Android / iOS)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic
                  ? 'يرجى منح إذن الوصول إلى الكاميرا لالتقاط صورة البطاقة.'
                  : 'Please grant camera permissions to capture your ID photo.',
            ),
          ),
        );
        return;
      }
    }

    // 3. Web or Permission Granted
    _pickAndCropImage(ImageSource.camera);
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final primaryColor = Theme.of(context).colorScheme.primary;

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (kIsWeb || (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux))) {
          setState(() {
            _imagePath = pickedFile.path;
          });
          widget.notifier.updateDraft((d) => d.avatarPath = pickedFile.path);
        } else {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: isArabic ? 'تعديل صورة البطاقة' : 'Edit ID Portrait',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
                cropStyle: CropStyle.circle,
              ),
              IOSUiSettings(
                title: isArabic ? 'تعديل صورة البطاقة' : 'Edit ID Portrait',
                cropStyle: CropStyle.circle,
                aspectRatioLockEnabled: true,
              ),
            ],
          );

          if (croppedFile != null) {
            setState(() {
              _imagePath = croppedFile.path;
            });
            widget.notifier.updateDraft((d) => d.avatarPath = croppedFile.path);
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removePhoto() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _imagePath = null;
    });
    widget.notifier.updateDraft((d) => d.avatarPath = null);
  }

  void _skip() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    widget.notifier.updateDraft((d) {
      d.skipAvatarUntil = DateTime.now().add(const Duration(days: 3));
    });
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.sizeOf(context).width < AppDesignTokens.tabletBreakpoint;
    final hasImage = _imagePath != null && File(_imagePath!).existsSync();

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

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    isArabic
                        ? 'قم برفع الصورة الشخصية لبطاقة العضوية'
                        : 'Upload your Church ID portrait',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Interactive Dropzone / Avatar Card
                Center(
                  child: InkWell(
                    onTap: _showImageSourceModal,
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
                            border: Border.all(
                              color: hasImage
                                  ? colors.primary
                                  : colors.primary.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: hasImage
                                ? Image.file(
                                    File(_imagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.person_rounded,
                                      size: 40,
                                      color: colors.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 30,
                                    color: colors.primary.withValues(alpha: 0.8),
                                  ),
                          ),
                        ),
                        // Small badge on bottom-right of avatar
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.surface, width: 2),
                            ),
                            child: Icon(
                              hasImage ? Icons.edit_rounded : Icons.add_rounded,
                              size: 12,
                              color: const Color(0xFF1A140E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Minimal Action Row below Avatar
                Center(
                  child: hasImage
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: _showImageSourceModal,
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  isArabic ? 'تغيير الصورة' : 'Change',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(color: colors.border),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _removePhoto,
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  isArabic ? 'إزالة' : 'Remove',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.statusError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: _showImageSourceModal,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_library_outlined, size: 14, color: colors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  isArabic ? 'اختيار صورة' : 'Choose Image',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Unified Fixed Navigation Bar: Back (Left) + Skip (Center) + Next (Right)
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
                  child: Text(isArabic ? 'السابق' : 'Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
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
                    style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
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
                  onPressed: _imagePath != null ? widget.onNext : null,
                  style: _buildPrimaryButtonStyle(context: context, isEnabled: _imagePath != null),
                  child: Text(
                    isArabic ? 'التالي' : 'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _imagePath != null ? const Color(0xFF1A140E) : const Color(0x99E5B842),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/core/theme/app_design_tokens.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/features/auth/registration/steps/step1_personal_info.dart';
import 'package:politia/features/auth/registration/steps/step2_contact_social.dart';
import 'package:politia/features/auth/registration/steps/step3_family_relations.dart';
import 'package:politia/features/auth/registration/steps/step4_education_career.dart';
import 'package:politia/features/auth/registration/steps/step5_residential_locations.dart';
import 'package:politia/features/auth/registration/steps/step6_church_commitment.dart';
import 'package:politia/features/auth/registration/steps/step7_hobbies_languages.dart';
import 'package:politia/features/auth/registration/steps/step8_password_final.dart';
import 'package:politia/features/auth/registration/widgets/step_progress_bar.dart';
import 'package:politia/widgets/auth_language_picker.dart';
import 'package:politia/widgets/language_picker_dialog.dart';
import 'package:politia/widgets/politia_branded_background.dart';

/// Stepper metadata record defining the 8 registration milestones.
class _StepMeta {
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final IconData icon;

  const _StepMeta({
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.icon,
  });

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String subtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;
}

/// Responsive Modern Split-Screen Registration Screen for Politia.
class MultiStepRegistrationScreen extends StatefulWidget {
  const MultiStepRegistrationScreen({super.key});

  @override
  State<MultiStepRegistrationScreen> createState() => _MultiStepRegistrationScreenState();
}

class _MultiStepRegistrationScreenState extends State<MultiStepRegistrationScreen> {
  final RegistrationNotifier _notifier = RegistrationNotifier();
  int _resetKey = 0;

  static const List<_StepMeta> _steps = [
    _StepMeta(
      titleEn: "Personal Identity",
      titleAr: "الهوية الشخصية",
      subtitleEn: "Full name, National ID & Photo",
      subtitleAr: "الاسم الرباعي، الرقم القومي والصورة",
      icon: Icons.person_outline_rounded,
    ),
    _StepMeta(
      titleEn: "Contact & Social",
      titleAr: "بيانات التواصل",
      subtitleEn: "Phone numbers, email & socials",
      subtitleAr: "أرقام الهاتف، البريد والحسابات",
      icon: Icons.phone_outlined,
    ),
    _StepMeta(
      titleEn: "Family Relations",
      titleAr: "البيانات العائلية",
      subtitleEn: "Marital status & family ties",
      subtitleAr: "الحالة الاجتماعية والروابط الأسرية",
      icon: Icons.family_restroom_rounded,
    ),
    _StepMeta(
      titleEn: "Education & Career",
      titleAr: "التعليم والعمل",
      subtitleEn: "Degree, field & university",
      subtitleAr: "المؤهل الدراسي، المجال والجامعة",
      icon: Icons.school_outlined,
    ),
    _StepMeta(
      titleEn: "Residential Location",
      titleAr: "محل الإقامة",
      subtitleEn: "Governorate, city & address",
      subtitleAr: "المحافظة، المدينة والعنوان",
      icon: Icons.location_on_outlined,
    ),
    _StepMeta(
      titleEn: "Church Commitment",
      titleAr: "الارتباط الكنسي",
      subtitleEn: "Parish, diocese & rank",
      subtitleAr: "كنيسة الحضور، الإيبارشية والرتبة",
      icon: Icons.church_outlined,
    ),
    _StepMeta(
      titleEn: "Hobbies & Languages",
      titleAr: "المواهب واللغات",
      subtitleEn: "Talents, interests & dialects",
      subtitleAr: "المهارات، الاهتمامات واللغات",
      icon: Icons.interests_outlined,
    ),
    _StepMeta(
      titleEn: "Security & Finish",
      titleAr: "الأمان وإنهاء الحساب",
      subtitleEn: "Master password & activation",
      subtitleAr: "كلمة المرور الرئيسية والتفعيل",
      icon: Icons.lock_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _confirmClearData(BuildContext context) async {
    final colors = context.appColors;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignTokens.borderRadiusDialog,
          side: BorderSide(color: colors.border),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colors.statusError, size: 22),
            const SizedBox(width: 8),
            Text(
              isArabic ? "مسح البيانات" : "Clear Data",
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? "هل أنت متأكد من رغبتك في مسح كافة البيانات المُدخلة؟ سيتم إعادة تعيين جميع الخطوات الثمانية والبدء من جديد."
              : "Are you sure you want to clear all entered registration data? This will reset all 8 steps and start fresh.",
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              isArabic ? "إلغاء" : "Cancel",
              style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.statusError,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            label: Text(isArabic ? "مسح الكل" : "Clear All"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _notifier.clearDraft();
      setState(() {
        _resetKey++;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(isArabic ? "تم مسح كافة بيانات التسجيل بنجاح." : "All registration data has been cleared."),
            ],
          ),
          backgroundColor: colors.surface,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: colors.border),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final currentStep = _notifier.currentStep;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: colors.background,
          body: PolitiaBrandedBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= AppDesignTokens.tabletBreakpoint;

                  return isDesktop
                      ? _buildDesktopSplitLayout(context, currentStep)
                      : _buildMobileLayout(context, currentStep);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // DESKTOP / TABLET SPLIT-SCREEN LAYOUT (Strict No-Scroll Viewport & Inner Card Depth)
  // =========================================================================
  Widget _buildDesktopSplitLayout(BuildContext context, int currentStep) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final meta = _steps[currentStep.clamp(0, _steps.length - 1)];

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 1080,
          minHeight: 560,
          maxHeight: 740,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppDesignTokens.borderRadiusDialog,
          border: Border.all(color: colors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.45) : colors.textPrimary.withValues(alpha: 0.07),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppDesignTokens.borderRadiusDialog,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------------- LEFT SIDEBAR STEPPER (~36% width) ----------------
              Expanded(
                flex: 36,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121110) : const Color(0xFFFAF8F5),
                    border: Border(
                      right: isArabic ? BorderSide.none : BorderSide(color: colors.border, width: 1.2),
                      left: isArabic ? BorderSide(color: colors.border, width: 1.2) : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Branding Header
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary.withValues(alpha: 0.15),
                              border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.webp',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.church_rounded,
                                  color: colors.primary,
                                  size: AppDesignTokens.iconRegular,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "POLITIA",
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Vertical Stepper Timeline
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(_steps.length, (index) {
                              final stepItem = _steps[index];
                              return _buildVerticalStepItem(
                                context: context,
                                index: index,
                                currentStep: currentStep,
                                icon: stepItem.icon,
                                title: stepItem.title(isArabic),
                                subtitle: stepItem.subtitle(isArabic),
                                isLast: index == _steps.length - 1,
                                onTap: () {
                                  if (index < currentStep) {
                                    _handleGoToStep(index);
                                  }
                                },
                              );
                            }),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0x22E5B842)),
                      const SizedBox(height: 8),

                      // Bottom Navigation Action Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                                  size: AppDesignTokens.iconMini,
                                  color: colors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isArabic ? "العودة لتسجيل الدخول" : "Back to login",
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isArabic ? "${currentStep + 1} من 8" : "${currentStep + 1} of 8",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- RIGHT MAIN CONTENT AREA (~64% width) ----------------
              Expanded(
                flex: 64,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Minimalist Clean Production-Grade Header Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Step Breadcrumb / Label
                          Text(
                            isArabic
                                ? "الخطوة 0${currentStep + 1} / 08 • ${meta.titleAr.toUpperCase()}"
                                : "STEP 0${currentStep + 1} / 08 • ${meta.titleEn.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: colors.textSecondary,
                            ),
                          ),

                          // Subtle Text-Only Actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Language Toggle
                              InkWell(
                                onTap: () => LanguageSelectionSheet.show(context),
                                borderRadius: BorderRadius.circular(6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    'EN | عربي',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Low-emphasis Reset Button
                              IconButton(
                                onPressed: () => _confirmClearData(context),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 17,
                                  color: colors.textMuted,
                                ),
                                tooltip: isArabic ? "مسح البيانات" : "Reset Data",
                                splashRadius: 18,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Subtle Hairline Divider
                      Container(
                        height: 1,
                        color: const Color(0x22E5B842),
                      ),
                      const SizedBox(height: 16),

                      // Continuous Flat Content Area (Un-nested, natural breathing rhythm)
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: _buildActiveStep(currentStep),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Bottom Horizontal Step Segment Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(8, (index) {
                          final isActive = index <= currentStep;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 4.5,
                            width: index == currentStep ? 32 : 18,
                            decoration: BoxDecoration(
                              color: isActive ? colors.primary : colors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ],
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
  // VERTICAL STEP ITEM FOR SIDEBAR TIMELINE (Smooth Animated Transitions)
  // =========================================================================
  Widget _buildVerticalStepItem({
    required BuildContext context,
    required int index,
    required int currentStep,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCurrent = currentStep == index;
    final isCompleted = currentStep > index;

    final Color badgeBg = isCurrent
        ? colors.primary.withValues(alpha: isDark ? 0.18 : 0.12)
        : (isCompleted ? colors.primary : (isDark ? const Color(0xFF161513) : const Color(0xFFF0ECE4)));

    final Color iconColor = isCurrent
        ? colors.primary
        : (isCompleted ? colors.buttonTextOnPrimary : colors.textMuted);

    final Color borderColor = isCurrent
        ? colors.primary
        : (isCompleted ? colors.primary : colors.border);

    final List<BoxShadow> haloShadow = isCurrent
        ? [
            BoxShadow(
              color: colors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ]
        : [];

    return InkWell(
      onTap: isCompleted ? onTap : null,
      borderRadius: AppDesignTokens.borderRadiusInput,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Node + Centered Continuous Timeline Line
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(AppDesignTokens.radiusBadge + 2),
                  border: Border.all(color: borderColor, width: 1.4),
                  boxShadow: haloShadow,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      isCompleted ? Icons.check_rounded : icon,
                      key: ValueKey('step_icon_${index}_$isCompleted'),
                      size: AppDesignTokens.iconMini,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  width: 1.5,
                  height: 26,
                  color: isCompleted
                      ? colors.primary
                      : colors.border,
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Step Labels with Typography Animation
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: isCurrent ? FontWeight.w700 : (isCompleted ? FontWeight.w600 : FontWeight.w500),
                      color: isCurrent
                          ? colors.textPrimary
                          : (isCompleted ? colors.textPrimary.withValues(alpha: 0.85) : colors.textMuted),
                    ),
                    child: Text(title),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: isCurrent
                          ? const Color(0xCCE5B842)
                          : colors.textMuted,
                    ),
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MOBILE RESPONSIVE LAYOUT (Compact Horizontal Stepper)
  // =========================================================================
  Widget _buildMobileLayout(BuildContext context, int currentStep) {
    final colors = context.appColors;
    final canPop = Navigator.of(context).canPop() || currentStep > 0;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final meta = _steps[currentStep.clamp(0, _steps.length - 1)];
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      children: [
        // Top Navigation Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: isKeyboardOpen ? 4.0 : 8.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App / Church Logo + Back Button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canPop) ...[
                        IconButton(
                          onPressed: () {
                            if (currentStep > 0) {
                              _handlePrevStep();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(
                            isArabic
                                ? Icons.arrow_forward_ios_rounded
                                : Icons.arrow_back_ios_new_rounded,
                            color: colors.textPrimary,
                            size: 18,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary.withValues(alpha: 0.15),
                          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.webp',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.church_rounded,
                              color: colors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),

                  // Compact Step Title Pill
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: AppDesignTokens.borderRadiusBadge,
                        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        isArabic
                            ? "${currentStep + 1} من 8: ${meta.title(true)}"
                            : "${currentStep + 1} of 8: ${meta.title(false)}",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _confirmClearData(context),
                        icon: Icon(
                          Icons.restart_alt_rounded,
                          color: colors.statusError,
                          size: 19,
                        ),
                        tooltip: isArabic ? "مسح البيانات" : "Clear Data",
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      const SizedBox(width: 4),
                      const AuthLanguagePicker(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isKeyboardOpen ? 4 : 8),
              StepProgressBar(
                currentStep: currentStep,
                showHeader: false,
                onStepTapped: (step) => _notifier.goToStep(step),
              ),
            ],
          ),
        ),

        // Form Card Container
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(color: colors.border, width: 1.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: isKeyboardOpen ? 6.0 : 12.0,
              ),
              child: _buildActiveStep(currentStep),
            ),
          ),
        ),
      ],
    );
  }

  bool _isNavigatingBackward = false;

  void _handlePrevStep() {
    HapticFeedback.lightImpact();
    setState(() {
      _isNavigatingBackward = true;
    });
    _notifier.prevStep();
  }

  void _handleNextStep() {
    HapticFeedback.lightImpact();
    setState(() {
      _isNavigatingBackward = false;
    });
    _notifier.nextStep();
  }

  void _handleGoToStep(int step) {
    HapticFeedback.selectionClick();
    setState(() {
      _isNavigatingBackward = step < _notifier.currentStep;
    });
    _notifier.goToStep(step);
  }

  // =========================================================================
  // STEP ROUTER SWITCH
  // =========================================================================
  Widget _buildActiveStep(int currentStep) {
    return KeyedSubtree(
      key: ValueKey('step_${currentStep}_${_isNavigatingBackward ? "back" : "fwd"}_$_resetKey'),
      child: _buildStepContent(currentStep),
    );
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 0:
        final startSubStep = _isNavigatingBackward ? 6 : 0;
        return Step1PersonalInfo(
          notifier: _notifier,
          initialSubStep: startSubStep,
          onNext: _handleNextStep,
          onBack: () {
            HapticFeedback.selectionClick();
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        );
      case 1:
        final startSubStep = _isNavigatingBackward ? 2 : 0;
        return Step2ContactSocial(
          notifier: _notifier,
          initialSubStep: startSubStep,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 2:
        return Step3FamilyRelations(
          notifier: _notifier,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 3:
        return Step4EducationCareer(
          notifier: _notifier,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 4:
        return Step5ResidentialLocations(
          notifier: _notifier,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 5:
        return Step6ChurchCommitment(
          notifier: _notifier,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 6:
        return Step7HobbiesLanguages(
          notifier: _notifier,
          onNext: _handleNextStep,
          onBack: _handlePrevStep,
        );
      case 7:
        return Step8PasswordFinal(
          notifier: _notifier,
          onBack: _handlePrevStep,
        );
      default:
        return Step1PersonalInfo(
          notifier: _notifier,
          onNext: _handleNextStep,
        );
    }
  }
}

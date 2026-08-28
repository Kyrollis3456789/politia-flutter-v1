import 'package:flutter/material.dart';
import 'package:politia/core/theme/app_colors_extension.dart';

/// Progress Bar & Milestone Indicator showing progress through all 8 steps.
class StepProgressBar extends StatelessWidget {
  final int currentStep; // 0-indexed (0 to 7)
  final Function(int) onStepTapped;
  final bool showHeader;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
    this.showHeader = true,
  });

  static const List<String> stepNamesEn = [
    'Identity',
    'Contact',
    'Family',
    'Education',
    'Residence',
    'Church',
    'Hobbies',
    'Password',
  ];

  static const List<String> stepNamesAr = [
    'الهوية',
    'التواصل',
    'العائلة',
    'التعليم',
    'الإقامة',
    'الكنيسة',
    'المواهب',
    'الأمان',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = colors.primary;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final safeStep = currentStep.clamp(0, 7);

    final titleText = isArabic
        ? 'الخطوة ${safeStep + 1} من 8: ${stepNamesAr[safeStep]}'
        : 'Step ${safeStep + 1} of 8: ${stepNamesEn[safeStep]}';

    return Column(
      children: [
        // Numerical Progress Label & Active Step Name (if enabled)
        if (showHeader) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: TextStyle(
                  fontFamily: isArabic ? null : 'Cinzel',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: primary,
                ),
              ),
              Text(
                '${((safeStep + 1) / 8 * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Multi-segment Bar
        Row(
          children: List.generate(8, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            Color segColor;
            if (isCurrent) {
              segColor = primary;
            } else if (isCompleted) {
              segColor = primary.withValues(alpha: 0.5);
            } else {
              segColor = colors.border;
            }

            return Expanded(
              child: InkWell(
                onTap: isCompleted ? () => onStepTapped(index) : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 6,
                  margin: EdgeInsetsDirectional.only(end: index < 7 ? 4.0 : 0.0),
                  decoration: BoxDecoration(
                    color: segColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

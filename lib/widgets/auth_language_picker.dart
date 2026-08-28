import 'package:flutter/material.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/widgets/language_picker_dialog.dart';

/// Reusable Language Picker pill/badge for Authentication and Registration Screens.
class AuthLanguagePicker extends StatelessWidget {
  const AuthLanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => LanguageSelectionSheet.show(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language_rounded,
                color: colors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'EN / عربي',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

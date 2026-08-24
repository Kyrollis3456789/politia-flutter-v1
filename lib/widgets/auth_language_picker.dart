import 'package:flutter/material.dart';
import 'package:politia/widgets/language_picker_dialog.dart';

/// Reusable Language Picker button for Authentication Screens.
class AuthLanguagePicker extends StatelessWidget {
  const AuthLanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.language_rounded,
          color: isDark ? Colors.white70 : const Color(0xFF1F2937),
          size: 22,
        ),
        tooltip: 'Change Language / إعدادات اللغة',
        onPressed: () {
          LanguageSelectionSheet.show(context);
        },
      ),
    );
  }
}


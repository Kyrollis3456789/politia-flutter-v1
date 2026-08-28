import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/theme/app_design_tokens.dart';
import 'app_colors_extension.dart';

/// Central theme definitions for Politia (Calibrated Luminous Liturgical Gold & Warm Ivory/Dark Brand).
class AppThemes {
  AppThemes._();

  // --- Light Semantic Design Tokens (Warm Alabaster & Deep Gold) ---
  static const lightAppColors = AppColorsExtension(
    primary: Color(0xFFB88E28),        // Rich Deep Warm Gold / Bronze
    secondary: Color(0xFFD4A746),      // Amber Accent Gold
    background: Color(0xFFF9F8F6),     // Warm Alabaster Linen
    surface: Color(0xFFFFFFFF),        // Pure Clean White Surface
    textPrimary: Color(0xFF1F1E1D),    // Deep High-Contrast Charcoal
    textSecondary: Color(0xFF5A554E),  // Warm Slate Gray
    textMuted: Color(0xFF8A8275),      // Subtle Muted Gray
    divider: Color(0xFFE8E2D5),        // Soft Alabaster Divider
    border: Color(0xFFE8E2D5),         // Soft Hairline Border
    patternOpacity: 0.0,               // Clean background without overlay
    statusSuccess: Color(0xFF2E7D32),  // Forest Green
    statusWarning: Color(0xFFC57E12),  // Deep Amber
    statusError: Color(0xFFC62828),    // Ruby Red
    statusInfo: Color(0xFF6B6265),     // Muted Charcoal
    buttonTextOnPrimary: Colors.white,
    buttonDisabledBackground: Color(0x1AB88E28), // Soft Warm Gold Tint
    buttonDisabledText: Color(0x99B88E28),       // Visible Muted Gold
  );

  // --- Dark Semantic Design Tokens (Deep Obsidian & Liturgical Gold) ---
  static const darkAppColors = AppColorsExtension(
    primary: Color(0xFFE5B842),        // Rich Liturgical Gold
    secondary: Color(0xFFF2C94C),      // Luminous Warm Gold Accent
    background: Color(0xFF0D0C0B),     // Deep Obsidian
    surface: Color(0xFF161513),        // Elevated Dark Container
    textPrimary: Color(0xFFF5F5F5),    // Crisp White
    textSecondary: Color(0xCCFFFFFF),  // Soft White
    textMuted: Color(0x99FFFFFF),      // Muted White
    divider: Color(0x22E5B842),        // Deep Gold Hairline Divider
    border: Color(0x22E5B842),         // Subtle Gold Hairline Border
    patternOpacity: 0.0,               // Clean dark background
    statusSuccess: Color(0xFF81C784),  // Soft Sage Green
    statusWarning: Color(0xFFE5A93C),  // Warm Halo Amber
    statusError: Color(0xFFE57373),    // Soft Coral Red
    statusInfo: Color(0xFFA89F9E),     // Muted Warm Gray
    buttonTextOnPrimary: Color(0xFF1A140E), // Sharp Dark Text on Luminous Gold Fill
    buttonDisabledBackground: Color(0x1AE5B842), // Subtle translucent gold
    buttonDisabledText: Color(0x99E5B842),       // Visible Muted Gold Dark
  );

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: lightAppColors.primary,
        onPrimary: Colors.white,
        secondary: lightAppColors.secondary,
        onSecondary: Colors.white,
        error: lightAppColors.statusError,
        onError: Colors.white,
        surface: lightAppColors.surface,
        onSurface: lightAppColors.textPrimary,
      ),
      scaffoldBackgroundColor: lightAppColors.background,
      canvasColor: lightAppColors.background,
      cardColor: lightAppColors.surface,
      dividerColor: lightAppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: lightAppColors.background,
        foregroundColor: lightAppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: lightAppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cinzel',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightAppColors.primary,
          side: BorderSide(color: lightAppColors.border, width: 1.2),
          shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      extensions: const [lightAppColors],
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: darkAppColors.primary,
        onPrimary: const Color(0xFF1A140E),
        secondary: darkAppColors.secondary,
        onSecondary: const Color(0xFF1A140E),
        error: darkAppColors.statusError,
        onError: Colors.white,
        surface: darkAppColors.surface,
        onSurface: darkAppColors.textPrimary,
      ),
      scaffoldBackgroundColor: darkAppColors.background,
      canvasColor: darkAppColors.background,
      cardColor: darkAppColors.surface,
      dividerColor: darkAppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: darkAppColors.background,
        foregroundColor: darkAppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: darkAppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cinzel',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAppColors.primary,
          foregroundColor: darkAppColors.buttonTextOnPrimary,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkAppColors.primary,
          side: BorderSide(color: darkAppColors.border, width: 1.2),
          shape: const RoundedRectangleBorder(borderRadius: AppDesignTokens.borderRadiusButton),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      extensions: const [darkAppColors],
    );
  }
}

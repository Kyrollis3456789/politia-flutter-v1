import 'package:flutter/material.dart';

/// Central Design System tokens for Politia (8pt Grid, Radii, Icon Sizes & Typography).
class AppDesignTokens {
  AppDesignTokens._();

  // =========================================================================
  // 8pt SPACING GRID
  // =========================================================================
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;

  // =========================================================================
  // BORDER RADII
  // =========================================================================
  static const double radiusBadge = 6.0;
  static const double radiusInput = 10.0;
  static const double radiusButton = 10.0;
  static const double radiusCard = 16.0;
  static const double radiusDialog = 20.0;

  static const BorderRadius borderRadiusBadge = BorderRadius.all(Radius.circular(radiusBadge));
  static const BorderRadius borderRadiusInput = BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius borderRadiusButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius borderRadiusCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusDialog = BorderRadius.all(Radius.circular(radiusDialog));

  // =========================================================================
  // ICONOGRAPHY SIZES
  // =========================================================================
  static const double iconMini = 16.0;
  static const double iconRegular = 20.0;
  static const double iconLarge = 24.0;
  static const double iconHeader = 32.0;

  // =========================================================================
  // RESPONSIVE BREAKPOINTS
  // =========================================================================
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
}

/// 8pt Grid System Tokens for strict, human-crafted layout rhythm.
class AppSpacing {
  AppSpacing._();

  static const double xs = AppDesignTokens.spaceXs;   // 4.0
  static const double sm = AppDesignTokens.spaceSm;   // 8.0
  static const double md = AppDesignTokens.spaceMd;   // 16.0
  static const double lg = AppDesignTokens.spaceLg;   // 24.0
  static const double xl = AppDesignTokens.spaceXl;   // 32.0
  static const double xxl = AppDesignTokens.spaceXxl; // 48.0

  // Quick Spacer Widgets
  static const Widget vXs = SizedBox(height: xs);
  static const Widget vSm = SizedBox(height: sm);
  static const Widget vMd = SizedBox(height: md);
  static const Widget vLg = SizedBox(height: lg);
  static const Widget vXl = SizedBox(height: xl);
  static const Widget vXxl = SizedBox(height: xxl);

  static const Widget hXs = SizedBox(width: xs);
  static const Widget hSm = SizedBox(width: sm);
  static const Widget hMd = SizedBox(width: md);
  static const Widget hLg = SizedBox(width: lg);
  static const Widget hXl = SizedBox(width: xl);
}


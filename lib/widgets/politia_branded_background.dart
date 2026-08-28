import 'package:flutter/material.dart';
import 'package:politia/core/theme/app_colors_extension.dart';

/// Wraps screens with the original Politia background texture and a clean,
/// theme-sensitive gradient overlay that adapts to Light and Dark modes.
class PolitiaBrandedBackground extends StatelessWidget {
  const PolitiaBrandedBackground({
    super.key,
    required this.child,
    this.backgroundAsset = 'assets/images/splash-bg.webp',
  });

  final Widget child;
  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final overlayColors = [
      colors.background.withValues(alpha: isDark ? 0.90 : 0.89),
      colors.background.withValues(alpha: isDark ? 0.98 : 0.96),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Clean background texture image
        Image.asset(
          backgroundAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Container(
            color: colors.background,
          ),
        ),

        // Layer 2: Clean semantic gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: overlayColors,
            ),
          ),
        ),

        // Layer 3: The child screen content
        child,
      ],
    );
  }
}

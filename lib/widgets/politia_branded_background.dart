import 'package:flutter/material.dart';

/// Wraps screens that use the shared Politia branded background texture with theme-sensitive overlay.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // DARK MODE overlay:
    //   A two-stop LinearGradient from top to bottom
    //   Stop 1: Color(0xFF0F1923) at opacity 0.78
    //   Stop 2: Color(0xFF1A2535) at opacity 0.72
    // LIGHT MODE overlay:
    //   A two-stop LinearGradient from top to bottom
    //   Stop 1: Color(0xFF2D1F0A) at opacity 0.14
    //   Stop 2: Color(0xFF1C1208) at opacity 0.10
    final overlayColors = isDark
        ? [
            const Color(0xFF0F1923).withValues(alpha: 0.78),
            const Color(0xFF1A2535).withValues(alpha: 0.72),
          ]
        : [
            const Color(0xFF2D1F0A).withValues(alpha: 0.14),
            const Color(0xFF1C1208).withValues(alpha: 0.10),
          ];

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Background texture image
        Image.asset(
          backgroundAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Container(
            color: isDark ? const Color(0xFF0F1923) : const Color(0xFFF8FAFC),
          ),
        ),

        // Layer 2: Theme-sensitive overlay
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

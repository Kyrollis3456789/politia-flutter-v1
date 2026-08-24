import 'package:flutter/material.dart';

/// Wraps screens that use the shared Politia branded background texture with the legacy Next.js gradient overlay.
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

    // Legacy Next.js CSS overlay variables
    final overlayColors = isDark
        ? const [
            Color(0xE6090D16), // rgba(9, 13, 22, 0.90)
            Color(0xF7090D16), // rgba(9, 13, 22, 0.97)
          ]
        : const [
            Color(0xD9F8FAFC), // rgba(248, 250, 252, 0.85)
            Color(0xF2F8FAFC), // rgba(248, 250, 252, 0.95)
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
            color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
          ),
        ),

        // Layer 2: Theme-sensitive overlay gradient
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

import 'package:flutter/material.dart';
import '../../core/services/init_service.dart';
import '../../widgets/politia_branded_background.dart';

/// Politia Splash Screen — Soft organic breathing glow with feathered ambient aura,
/// Cinzel typography, and responsive optical layout with automated route resolution to /login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Trigger bootstrap and route navigation
    _startBootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (disableAnimations) {
      _glowController?.dispose();
      _glowController = null;
      _glowAnimation = null;
    } else if (_glowController == null) {
      // 2.6s organic breathing cycle (fade in & fade out in reverse)
      _glowController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2600),
      )..repeat(reverse: true);

      _glowAnimation = Tween<double>(begin: 0.25, end: 1.0).animate(
        CurvedAnimation(
          parent: _glowController!,
          curve: Curves.easeInOutSine,
        ),
      );
    }
  }

  void _startBootstrap() async {
    try {
      final targetRoute = await InitializationService.instance.resolveInitialization(context);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(targetRoute);
    } catch (e) {
      debugPrint('[SplashScreen] Initialization note: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    _glowController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
        behavior: HitTestBehavior.opaque,
        child: PolitiaBrandedBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final vw = constraints.maxWidth;

              // Responsive horizontal padding
              final double responsiveHPad;
              if (vw < 440) {
                responsiveHPad = (vw * 0.07).clamp(20.0, double.infinity);
              } else if (vw <= 900) {
                responsiveHPad = vw * 0.09;
              } else {
                responsiveHPad = 0.0;
              }

              // Responsive vertical gaps
              final double titleTopGap;
              final double titleToSloganGap;
              final double sloganToSpinnerGap;
              if (vw < 440) {
                titleTopGap = 20.0;
                titleToSloganGap = 6.0;
                sloganToSpinnerGap = 28.0;
              } else if (vw <= 900) {
                titleTopGap = 24.0;
                titleToSloganGap = 8.0;
                sloganToSpinnerGap = 34.0;
              } else {
                titleTopGap = 28.0;
                titleToSloganGap = 10.0;
                sloganToSpinnerGap = 40.0;
              }

              // Responsive logo sizing
              final double logoSize;
              if (vw < 440) {
                logoSize = (vw * 0.36).clamp(120.0, 152.0);
              } else if (vw <= 900) {
                logoSize = (vw * 0.20).clamp(148.0, 176.0);
              } else {
                logoSize = 192.0;
              }

              // Responsive typography (scaled smoothly on mobile)
              final double titleFontSize;
              final double sloganFontSize;
              final double sloganLetterSpacing;

              if (vw < 440) {
                titleFontSize = (vw * 0.055).clamp(16.0, 20.0);
                sloganFontSize = (vw * 0.026).clamp(8.5, 10.0);
                sloganLetterSpacing = (vw * 0.006).clamp(1.6, 2.8);
              } else if (vw <= 900) {
                titleFontSize = (vw * 0.050).clamp(22.0, 28.0);
                sloganFontSize = (vw * 0.022).clamp(9.0, 10.5);
                sloganLetterSpacing = (vw * 0.006).clamp(1.6, 2.8);
              } else {
                titleFontSize = 30.0;
                sloganFontSize = 10.5;
                sloganLetterSpacing = 3.2;
              }

              // Light/Dark specific colors
              final titleColor = isDark
                ? const Color(0xFFF3F4F6)
                : const Color(0xFF1C2340);

              final sloganColor = isDark
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF3D3520); // Warm dark brown for high contrast on parchment

              final spinnerValueColor = isDark
                ? const Color(0xFFB45309)
                : const Color(0xFF92400E); // Darker amber for clear visibility in light mode

              final spinnerTrackColor = isDark
                ? const Color(0xFFB45309).withValues(alpha: 0.18)
                : const Color(0xFF92400E).withValues(alpha: 0.20);

              return Align(
                alignment: const Alignment(0, -0.10), // Optical centering: 10% above mathematical center
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsiveHPad),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Constrained Logo with Softly Breathing Ambient Aura
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: OverflowBox(
                            maxWidth: logoSize * 1.8,
                            maxHeight: logoSize * 1.8,
                            child: _buildGlowingLogo(
                              logoSize: logoSize,
                              isDark: isDark,
                              disableAnimations: disableAnimations,
                            ),
                          ),
                        ),

                        SizedBox(height: titleTopGap),

                        // Brand Title — Hardcoded string with non-breaking space
                        Text(
                          'At Church - Coptic\u00A0Orthodox',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w700,
                            fontSize: titleFontSize,
                            color: titleColor,
                            letterSpacing: 0.5,
                            height: 1.3,
                          ),
                        ),

                        SizedBox(height: titleToSloganGap),

                        // Slogan
                        Text(
                          'ANCHORED IN FAITH, CONNECTED IN LOVE',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w400,
                            fontSize: sloganFontSize,
                            color: sloganColor,
                            letterSpacing: sloganLetterSpacing,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: sloganToSpinnerGap),

                        // Loading Indicator
                        Semantics(
                          label: 'Application loading',
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                spinnerValueColor,
                              ),
                              backgroundColor: spinnerTrackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingLogo({
    required double logoSize,
    required bool isDark,
    required bool disableAnimations,
  }) {
    if (disableAnimations || _glowAnimation == null) {
      final staticOpacity = isDark ? 0.45 : 0.28;
      return _buildGlowStack(
        logoSize: logoSize,
        glowOpacity: staticOpacity,
        isDark: isDark,
      );
    }

    return AnimatedBuilder(
      animation: _glowAnimation!,
      builder: (context, _) {
        final animatedVal = _glowAnimation!.value;
        final glowOpacity = isDark
            ? animatedVal * 0.60
            : animatedVal * 0.35;

        return _buildGlowStack(
          logoSize: logoSize,
          glowOpacity: glowOpacity,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildGlowStack({
    required double logoSize,
    required double glowOpacity,
    required bool isDark,
  }) {
    final glowDiameter = logoSize * 1.6;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow layer — Feathered RadialGradient with seamless Gaussian falloff
        Container(
          width: glowDiameter,
          height: glowDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFD97706).withValues(alpha: glowOpacity.clamp(0.0, 1.0)),
                const Color(0xFFD97706).withValues(alpha: (glowOpacity * 0.50).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: (glowOpacity * 0.15).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.40, 0.70, 1.0],
            ),
          ),
        ),

        // Logo image — ON TOP of ambient breathing glow
        ClipOval(
          child: Image.asset(
            'assets/images/logo.webp',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => Container(
              width: logoSize,
              height: logoSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB45309),
              ),
              child: const Icon(
                Icons.church_rounded,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

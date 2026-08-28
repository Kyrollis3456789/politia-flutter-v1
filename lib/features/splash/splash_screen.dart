import 'package:flutter/material.dart';
import '../../core/services/init_service.dart';
import '../../widgets/politia_branded_background.dart';

/// Politia Splash Screen with Mobile Visual Hierarchy Redesign,
/// Staggered Top-to-Bottom Entry Animations, Breathing Ambient Aura,
/// and Continuous Glowing Loading Spinner.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Continuous Breathing Glow Controller (Logo Aura & Spinner Glow)
  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  // Staggered Entry Animation Controller (Top-to-Bottom Sequence over 1.8s)
  AnimationController? _entryController;
  Animation<double>? _logoEntryAnimation;
  Animation<double>? _titleEntryAnimation;
  Animation<double>? _taglineEntryAnimation;
  Animation<double>? _verseEntryAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Continuous Breathing Glow
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.30, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController!,
        curve: Curves.easeInOutSine,
      ),
    );

    // 2. Initialize Staggered Entry Sequence (1.8 seconds)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.00, 0.40, curve: Curves.easeOutCubic),
    );

    _titleEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOutCubic),
    );

    _taglineEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
    );

    _verseEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
    );

    // Start entry animation
    _entryController!.forward();

    // Trigger bootstrap and route navigation
    _startBootstrap();
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
    _entryController?.dispose();
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
              final vh = constraints.maxHeight;
              final isMobile = vw < 600;

              return isMobile
                  ? _buildMobileLayout(context, vw, vh, isDark, disableAnimations)
                  : _buildDesktopLayout(context, vw, vh, isDark, disableAnimations);
            },
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MOBILE REDESIGNED LAYOUT (~25% Logo, ~35% Title, ~45% Tagline, ~55% Verse, ~80% Spinner)
  // =========================================================================
  Widget _buildMobileLayout(
    BuildContext context,
    double vw,
    double vh,
    bool isDark,
    bool disableAnimations,
  ) {
    // Scaled logo up by ~15–20% (142 - 168px)
    final double logoSize = (vw * 0.38).clamp(142.0, 168.0);
    final sloganColor = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF3A3A3C);
    final verseColor = isDark ? const Color(0xFFE5B869) : const Color(0xFF8B5E14);

    return Stack(
      children: [
        // Main Content Column (Logo -> Title -> Tagline -> Verse)
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (vw * 0.08).clamp(24.0, 36.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Upper Section Spacer (~18-22% top margin to place logo center at ~25-28%)
                SizedBox(height: vh * 0.12),

                // 1. BRAND LOGO (Scaled +20% with ambient luminous aura)
                _buildAnimatedEntry(
                  animation: _logoEntryAnimation,
                  disableAnimations: disableAnimations,
                  child: SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: OverflowBox(
                      maxWidth: logoSize * 1.9,
                      maxHeight: logoSize * 1.9,
                      child: _buildGlowingLogo(
                        logoSize: logoSize,
                        isDark: isDark,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: (vh * 0.028).clamp(16.0, 24.0)),

                // 2. APP TITLE: "AT CHURCH - COPTIC ORTHODOX" (High contrast white / dark charcoal)
                _buildAnimatedEntry(
                  animation: _titleEntryAnimation,
                  disableAnimations: disableAnimations,
                  child: Text(
                    'AT CHURCH - COPTIC ORTHODOX',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontWeight: FontWeight.bold,
                      fontSize: (vw * 0.062).clamp(22.0, 26.0),
                      color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF161513),
                      letterSpacing: 2.0,
                      height: 1.25,
                      shadows: isDark
                          ? [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),

                SizedBox(height: (vh * 0.012).clamp(8.0, 12.0)),

                // 3. TAGLINE: "ANCHORED IN FAITH, CONNECTED IN LOVE" (Dark: #E0E0E0, Light: #3A3A3C)
                _buildAnimatedEntry(
                  animation: _taglineEntryAnimation,
                  disableAnimations: disableAnimations,
                  child: Text(
                    'ANCHORED IN FAITH, CONNECTED IN LOVE',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontWeight: FontWeight.w500,
                      fontSize: (vw * 0.028).clamp(11.0, 12.5),
                      color: sloganColor,
                      letterSpacing: 2.5,
                      height: 1.45,
                    ),
                  ),
                ),

                SizedBox(height: (vh * 0.035).clamp(20.0, 32.0)),

                // 4. ARABIC BIBLICAL VERSE: «أَنْتُمْ نُورُ الْعَالَمِ. لاَ يُمْكِنُ أَنْ تُخْفَى مَدِينَةٌ مَوْضُوعَةٌ عَلَى جَبَل» (متى 5 : 14)
                _buildAnimatedEntry(
                  animation: _verseEntryAnimation,
                  disableAnimations: disableAnimations,
                  child: Text(
                    '«أَنْتُمْ نُورُ الْعَالَمِ. لاَ يُمْكِنُ أَنْ تُخْفَى مَدِينَةٌ مَوْضُوعَةٌ عَلَى جَبَل» (متى 5 : 14)',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: (vw * 0.036).clamp(13.5, 15.0),
                      fontWeight: FontWeight.w600,
                      color: verseColor,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 5. LOADING SPINNER (Positioned at ~80–85% from top with continuous pulsing glow)
        Positioned(
          left: 0,
          right: 0,
          bottom: (vh * 0.12).clamp(48.0, 80.0),
          child: Center(
            child: _buildGlowingSpinner(
              isDark: isDark,
              disableAnimations: disableAnimations,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // DESKTOP / TABLET LAYOUT (Preserved Optical Balance)
  // =========================================================================
  Widget _buildDesktopLayout(
    BuildContext context,
    double vw,
    double vh,
    bool isDark,
    bool disableAnimations,
  ) {
    const double logoSize = 180.0;
    final titleColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1C2340);
    final sloganColor = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF3A3A3C);
    final verseColor = isDark ? const Color(0xFFE5B869) : const Color(0xFF8B5E14);

    return Align(
      alignment: const Alignment(0, -0.06),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              _buildAnimatedEntry(
                animation: _logoEntryAnimation,
                disableAnimations: disableAnimations,
                child: SizedBox(
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
              ),

              const SizedBox(height: 24),

              // Title
              _buildAnimatedEntry(
                animation: _titleEntryAnimation,
                disableAnimations: disableAnimations,
                child: Text(
                  'AT CHURCH - COPTIC ORTHODOX',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    color: titleColor,
                    letterSpacing: 2.0,
                    height: 1.25,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              _buildAnimatedEntry(
                animation: _taglineEntryAnimation,
                disableAnimations: disableAnimations,
                child: Text(
                  'ANCHORED IN FAITH, CONNECTED IN LOVE',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.5,
                    color: sloganColor,
                    letterSpacing: 2.5,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Arabic Verse
              _buildAnimatedEntry(
                animation: _verseEntryAnimation,
                disableAnimations: disableAnimations,
                child: Text(
                  '«أَنْتُمْ نُورُ الْعَالَمِ. لاَ يُمْكِنُ أَنْ تُخْفَى مَدِينَةٌ مَوْضُوعَةٌ عَلَى جَبَل» (متى 5 : 14)',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: verseColor,
                    height: 1.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Spinner
              _buildGlowingSpinner(
                isDark: isDark,
                disableAnimations: disableAnimations,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // ANIMATED ENTRY HELPER (Fade + Subtle Upward Slide)
  // =========================================================================
  Widget _buildAnimatedEntry({
    required Animation<double>? animation,
    required bool disableAnimations,
    required Widget child,
  }) {
    if (disableAnimations || animation == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final opacity = animation.value.clamp(0.0, 1.0);
        final offsetY = (1.0 - animation.value) * 14.0;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
    );
  }

  // =========================================================================
  // GLOWING LOGO WITH AMBIENT LIGHTING AURA
  // =========================================================================
  Widget _buildGlowingLogo({
    required double logoSize,
    required bool isDark,
    required bool disableAnimations,
  }) {
    if (disableAnimations || _glowAnimation == null) {
      final staticOpacity = isDark ? 0.50 : 0.32;
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
        final glowOpacity = isDark ? animatedVal * 0.65 : animatedVal * 0.40;

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
    final glowDiameter = logoSize * 1.65;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Feathered Gaussian radial aura
        Container(
          width: glowDiameter,
          height: glowDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFD97706).withValues(alpha: glowOpacity.clamp(0.0, 1.0)),
                const Color(0xFFE5B869).withValues(alpha: (glowOpacity * 0.60).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: (glowOpacity * 0.20).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        // Crisp Logo Image
        ClipOval(
          child: Image.asset(
            'assets/images/logo.webp',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
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

  // =========================================================================
  // GLOWING LOADING SPINNER WITH BREATHING HALO
  // =========================================================================
  Widget _buildGlowingSpinner({
    required bool isDark,
    required bool disableAnimations,
  }) {
    final spinnerValueColor = isDark ? const Color(0xFFE5B869) : const Color(0xFFC69214);
    final spinnerTrackColor = spinnerValueColor.withValues(alpha: 0.18);

    if (disableAnimations || _glowAnimation == null) {
      return Semantics(
        label: 'Application loading',
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.8,
            valueColor: AlwaysStoppedAnimation<Color>(spinnerValueColor),
            backgroundColor: spinnerTrackColor,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _glowAnimation!,
      builder: (context, _) {
        final glowVal = _glowAnimation!.value;
        final glowAlpha = (glowVal * 0.35).clamp(0.0, 1.0);

        return Semantics(
          label: 'Application loading',
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: spinnerValueColor.withValues(alpha: glowAlpha),
                  blurRadius: 16 * glowVal,
                  spreadRadius: 2 * glowVal,
                ),
              ],
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.8,
                valueColor: AlwaysStoppedAnimation<Color>(spinnerValueColor),
                backgroundColor: spinnerTrackColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

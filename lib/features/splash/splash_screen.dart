import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/init_service.dart';
import '../../widgets/politia_branded_background.dart';

/// Production-ready Politia Splash / Onboarding Screen.
/// Features seamless edge-to-edge status bar handling, refined Coptic typography hierarchy,
/// golden Coptic cross divider, elevated scripture card, continuous 1->2->3->2->1 breathing
/// three-dot loader, and smooth staggered entry animations.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Continuous Breathing Glow Controller (Logo Aura)
  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  // Continuous 1 -> 2 -> 3 -> 2 -> 1 Three-Dot Loader Animation Controller (1500ms cycle)
  AnimationController? _dotsController;

  // Staggered Entry Animation Controller (Top-to-Bottom Sequence over 1.8s)
  AnimationController? _entryController;
  Animation<double>? _logoEntryAnimation;
  Animation<double>? _titleEntryAnimation;
  Animation<double>? _subtitleEntryAnimation;
  Animation<double>? _cardEntryAnimation;
  Animation<double>? _footerEntryAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Subtle Breathing Glow (Logo Aura)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController!,
        curve: Curves.easeInOutSine,
      ),
    );

    // 2. Initialize Continuous 1->2->3->2->1 Three-Dot Loader (375ms per step, 1500ms full cycle)
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // 3. Initialize Staggered Entry Sequence (1.8s)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
    );

    _titleEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.20, 0.55, curve: Curves.easeOutCubic),
    );

    _subtitleEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
    );

    _cardEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic),
    );

    _footerEntryAnimation = CurvedAnimation(
      parent: _entryController!,
      curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
    );

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
    _dotsController?.dispose();
    _entryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // Seamless edge-to-edge transparent system bars with appropriate icon contrast
    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          behavior: HitTestBehavior.opaque,
          child: PolitiaBrandedBackground(
            child: SafeArea(
              maintainBottomViewPadding: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final vw = constraints.maxWidth;
                  final vh = constraints.maxHeight;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (vw * 0.07).clamp(20.0, 32.0),
                        ),
                        child: _buildMainLayout(
                          context: context,
                          vw: vw,
                          vh: vh,
                          isDark: isDark,
                          disableAnimations: disableAnimations,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout({
    required BuildContext context,
    required double vw,
    required double vh,
    required bool isDark,
    required bool disableAnimations,
  }) {
    // Theme-sensitive refined colors
    final navyTitleColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF16203B);
    final subtitleColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF3A3A3C);
    final goldAccent = isDark ? const Color(0xFFE5B869) : const Color(0xFFD4A044); // Warm Premium Gold

    // Responsive dimensions
    final logoSize = (vw * 0.28).clamp(112.0, 134.0);
    final titleFontSize = (vw * 0.056).clamp(19.5, 23.5);
    final subtitleFontSize = (vw * 0.026).clamp(10.5, 11.8);

    return Column(
      children: [
        // Main Centered Content
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. BRAND LOGO (Centered with subtle ambient breathing aura)
                  _buildAnimatedEntry(
                    animation: _logoEntryAnimation,
                    disableAnimations: disableAnimations,
                    child: SizedBox(
                      width: logoSize,
                      height: logoSize,
                      child: OverflowBox(
                        maxWidth: logoSize * 1.6,
                        maxHeight: logoSize * 1.6,
                        child: _buildGlowingLogo(
                          logoSize: logoSize,
                          isDark: isDark,
                          disableAnimations: disableAnimations,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: (vh * 0.024).clamp(16.0, 24.0)),

                  // 2. MAIN APP TITLE: "AT CHURCH - COPTIC ORTHODOX"
                  _buildAnimatedEntry(
                    animation: _titleEntryAnimation,
                    disableAnimations: disableAnimations,
                    child: Text(
                      'AT CHURCH - COPTIC\nORTHODOX',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                        color: navyTitleColor,
                        letterSpacing: 2.0,
                        height: 1.28,
                        shadows: isDark
                            ? [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),

                  SizedBox(height: (vh * 0.016).clamp(10.0, 16.0)),

                  // 3. ELEGANT GOLDEN CROSS DIVIDER LINE
                  _buildAnimatedEntry(
                    animation: _titleEntryAnimation,
                    disableAnimations: disableAnimations,
                    child: _buildCrossDivider(goldAccent),
                  ),

                  SizedBox(height: (vh * 0.014).clamp(10.0, 14.0)),

                  // 4. SUBTITLE: "ANCHORED IN FAITH, CONNECTED IN LOVE"
                  _buildAnimatedEntry(
                    animation: _subtitleEntryAnimation,
                    disableAnimations: disableAnimations,
                    child: Text(
                      'ANCHORED IN FAITH, CONNECTED IN LOVE',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.w500,
                        fontSize: subtitleFontSize,
                        color: subtitleColor,
                        letterSpacing: 2.2,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: (vh * 0.028).clamp(18.0, 26.0)),

                  // 5. SCRIPTURE CONTAINER CARD
                  _buildAnimatedEntry(
                    animation: _cardEntryAnimation,
                    disableAnimations: disableAnimations,
                    child: _buildScriptureCard(
                      vw: vw,
                      isDark: isDark,
                      goldAccent: goldAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 6. CONTINUOUS ANIMATED THREE-DOT LOADER (1 -> 2 -> 3 -> 2 -> 1)
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: _buildAnimatedEntry(
            animation: _footerEntryAnimation,
            disableAnimations: disableAnimations,
            child: _buildAnimatedThreeDotLoader(
              isDark: isDark,
              goldAccent: goldAccent,
              disableAnimations: disableAnimations,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // GOLDEN CROSS DIVIDER COMPONENT
  // =========================================================================
  Widget _buildCrossDivider(Color goldAccent) {
    return SizedBox(
      width: 210.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goldAccent.withValues(alpha: 0.0),
                    goldAccent.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.add_rounded,
              size: 16,
              color: goldAccent,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goldAccent.withValues(alpha: 0.85),
                    goldAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SCRIPTURE QUOTE CARD COMPONENT
  // =========================================================================
  Widget _buildScriptureCard({
    required double vw,
    required bool isDark,
    required Color goldAccent,
  }) {
    // Subtle, distinct background tint without heavy appearance
    final cardBg = isDark
        ? const Color(0xFF1B1A17).withValues(alpha: 0.90)
        : const Color(0xFFFBF8F2).withValues(alpha: 0.94);

    final cardBorder = isDark
        ? goldAccent.withValues(alpha: 0.28)
        : goldAccent.withValues(alpha: 0.32);

    // Warm, highly readable Arabic text color
    final verseTextColor = isDark
        ? const Color(0xFFF3C775)
        : const Color(0xFF784E1A); // Darker warm-gold/brown tone for crisp readability

    final citationColor = isDark
        ? goldAccent.withValues(alpha: 0.90)
        : const Color(0xFF8B5E14).withValues(alpha: 0.85);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: (vw * 0.06).clamp(20.0, 28.0),
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(color: cardBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFF784E1A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arabic Scripture Quote
          Text(
            '«أَنْتُمْ نُورُ الْعَالَمِ. لَا يُمْكِنُ أَنْ تُخْفَى مَدِينَةٌ مَوْضُوعَةٌ عَلَى جَبَلٍ»',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            softWrap: true,
            style: TextStyle(
              fontSize: (vw * 0.038).clamp(14.0, 15.5),
              fontWeight: FontWeight.w600,
              color: verseTextColor,
              height: 1.65,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 8),

          // Citation Reference
          Text(
            '(متى 5 : 14)',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: (vw * 0.032).clamp(12.5, 14.0),
              fontWeight: FontWeight.w500,
              color: citationColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CONTINUOUS 1 -> 2 -> 3 -> 2 -> 1 ANIMATED THREE-DOT LOADER
  // =========================================================================
  Widget _buildAnimatedThreeDotLoader({
    required bool isDark,
    required Color goldAccent,
    required bool disableAnimations,
  }) {
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.22)
        : const Color(0xFF16203B).withValues(alpha: 0.20);

    if (disableAnimations || _dotsController == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSingleDot(weight: 0.0, inactiveColor: inactiveColor, goldColor: goldAccent),
          const SizedBox(width: 9),
          _buildSingleDot(weight: 1.0, inactiveColor: inactiveColor, goldColor: goldAccent),
          const SizedBox(width: 9),
          _buildSingleDot(weight: 0.0, inactiveColor: inactiveColor, goldColor: goldAccent),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _dotsController!,
      builder: (context, _) {
        final t = _dotsController!.value; // 0.0 -> 1.0

        // Calculate smooth continuous 1 -> 2 -> 3 -> 2 -> 1 active weight for each dot
        // Phase moves over 4 segments in cycle:
        // Segment 0 [0.00 - 0.25]: Dot 1 (1->0) to Dot 2 (0->1)
        // Segment 1 [0.25 - 0.50]: Dot 2 (1->0) to Dot 3 (0->1)
        // Segment 2 [0.50 - 0.75]: Dot 3 (1->0) to Dot 2 (0->1)
        // Segment 3 [0.75 - 1.00]: Dot 2 (1->0) to Dot 1 (0->1)
        final double phase = t * 4.0;
        final int segment = phase.floor().clamp(0, 3);
        final double localT = phase - segment;
        final double smoothT = Curves.easeInOutCubic.transform(localT);

        double w1 = 0.0;
        double w2 = 0.0;
        double w3 = 0.0;

        switch (segment) {
          case 0:
            w1 = 1.0 - smoothT;
            w2 = smoothT;
            w3 = 0.0;
            break;
          case 1:
            w1 = 0.0;
            w2 = 1.0 - smoothT;
            w3 = smoothT;
            break;
          case 2:
            w1 = 0.0;
            w2 = smoothT;
            w3 = 1.0 - smoothT;
            break;
          case 3:
            w1 = smoothT;
            w2 = 1.0 - smoothT;
            w3 = 0.0;
            break;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSingleDot(weight: w1, inactiveColor: inactiveColor, goldColor: goldAccent),
            const SizedBox(width: 9),
            _buildSingleDot(weight: w2, inactiveColor: inactiveColor, goldColor: goldAccent),
            const SizedBox(width: 9),
            _buildSingleDot(weight: w3, inactiveColor: inactiveColor, goldColor: goldAccent),
          ],
        );
      },
    );
  }

  Widget _buildSingleDot({
    required double weight, // 0.0 = completely inactive, 1.0 = fully active gold
    required Color inactiveColor,
    required Color goldColor,
  }) {
    final clampedWeight = weight.clamp(0.0, 1.0);

    // Smooth size interpolation: 6.5px base -> 8.8px active
    final double size = 6.5 + (2.3 * clampedWeight);

    // Color and opacity blending
    final dotColor = Color.lerp(inactiveColor, goldColor, clampedWeight)!;

    return Container(
      width: 14.0, // Fixed layout box prevents any horizontal jumping
      height: 14.0,
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotColor,
          boxShadow: clampedWeight > 0.15
              ? [
                  BoxShadow(
                    color: goldColor.withValues(alpha: 0.45 * clampedWeight),
                    blurRadius: 6.0 * clampedWeight,
                    spreadRadius: 1.0 * clampedWeight,
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  // =========================================================================
  // GLOWING LOGO COMPONENT
  // =========================================================================
  Widget _buildGlowingLogo({
    required double logoSize,
    required bool isDark,
    required bool disableAnimations,
  }) {
    if (disableAnimations || _glowAnimation == null) {
      final staticOpacity = isDark ? 0.38 : 0.20;
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
        final glowOpacity = isDark ? animatedVal * 0.48 : animatedVal * 0.28;

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
    final glowDiameter = logoSize * 1.50;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Feathered Gaussian radial aura (natural soft glow without circular outline)
        Container(
          width: glowDiameter,
          height: glowDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFD97706).withValues(alpha: glowOpacity.clamp(0.0, 1.0)),
                const Color(0xFFE5B869).withValues(alpha: (glowOpacity * 0.50).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: (glowOpacity * 0.12).clamp(0.0, 1.0)),
                const Color(0xFFB45309).withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        // Original Brand Logo (Unframed and undistorted)
        Image.asset(
          'assets/images/logo.webp',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
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
              size: 56,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // ANIMATED ENTRY HELPER
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
        final offsetY = (1.0 - animation.value) * 12.0;

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
}

import 'package:flutter/material.dart';
import '../../core/services/init_service.dart';

/// Persistent, production-ready Splash Screen with continuous glowing and loader animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceOpacity;
  late final Animation<Offset> _entranceSlide;

  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animation: 1.0s cubic-bezier(0.2, 0.8, 0.2, 1)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    final entranceCurved = CurvedAnimation(
      parent: _entranceController,
      curve: const Cubic(0.2, 0.8, 0.2, 1.0),
    );
    _entranceScale = Tween<double>(begin: 0.8, end: 1.0).animate(entranceCurved);
    _entranceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(entranceCurved);
    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(entranceCurved);

    // 2. Glow Pulse: 2.5s infinite looping animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 4.0, end: 32.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    // Run initialization logic in the background silently (without auto-redirecting)
    _runBackgroundInitialization();
  }

  void _runBackgroundInitialization() async {
    try {
      await InitializationService.instance.resolveInitialization(context);
    } catch (e) {
      debugPrint('[SplashScreen] Background initialization note: $e');
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Exact Next.js visual overlay colors
    final overlay1 = isDark
        ? const Color(0xE6090D16) // rgba(9, 13, 22, 0.90)
        : const Color(0xD9F8FAFC); // rgba(248, 250, 252, 0.85)

    final overlay2 = isDark
        ? const Color(0xF7090D16) // rgba(9, 13, 22, 0.97)
        : const Color(0xF2F8FAFC); // rgba(248, 250, 252, 0.95)

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image + Overlay Gradient
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash-bg.webp',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [overlay1, overlay2],
                ),
              ),
            ),
          ),

          // Responsive Centered Content
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 400;
              final logoDimension = isSmall ? 150.0 : 192.0;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _entranceController,
                        _glowController,
                      ]),
                      builder: (context, child) {
                        return Opacity(
                          opacity: _entranceOpacity.value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: _entranceScale.value,
                            child: SlideTransition(
                              position: _entranceSlide,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Logo with Continuous Glow Pulse
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(180, 83, 9, 0.65),
                                          blurRadius: _glowAnimation.value,
                                          spreadRadius: _glowAnimation.value * 0.25,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo.webp',
                                      width: logoDimension,
                                      height: logoDimension,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Main Title (Serif Font)
                                  Text(
                                    'At Church - Coptic Orthodox',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'serif',
                                      fontSize: isSmall ? 28 : 34,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                      color: isDark
                                          ? const Color(0xFFF3F4F6)
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Subtitle Slogan
                                  Text(
                                    'ANCHORED IN FAITH, CONNECTED IN LOVE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmall ? 11 : 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: isSmall ? 2.0 : 2.6,
                                      color: isDark
                                          ? const Color(0xFFD1D5DB)
                                          : const Color(0xFF4B5563),
                                    ),
                                  ),
                                  const SizedBox(height: 36),

                                  // Persistent Amber Circular Progress Indicator
                                  const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFB45309),
                                      ),
                                      backgroundColor: Color.fromRGBO(180, 83, 9, 0.2),
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
            },
          ),
        ],
      ),
    );
  }
}

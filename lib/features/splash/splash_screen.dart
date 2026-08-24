import 'package:flutter/material.dart';
import '../../core/services/init_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _entranceScale;
  late Animation<double> _entranceOpacity;
  late Animation<Offset> _entranceSlide;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  late AnimationController _exitController;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  bool _isExiting = false;
  String _targetRoute = '/login';

  @override
  void initState() {
    super.initState();

    // 1. Entrance: 1.0s cubic-bezier(0.2, 0.8, 0.2, 1)
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

    // 2. Glow Pulse: 2.5s infinite loop (rgba(180, 83, 9, 0.4 -> 0.7))
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 4.0, end: 32.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 3. Screen Exit: 0.8s cubic-bezier(0.8, 0, 0.2, 1)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final exitCurved = CurvedAnimation(
      parent: _exitController,
      curve: const Cubic(0.8, 0.0, 0.2, 1.0),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.1).animate(exitCurved);
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(exitCurved);

    _entranceController.forward();
    _startInitialization();
  }

  void _startInitialization() async {
    final route = await InitializationService.instance.resolveInitialization(context);
    _targetRoute = route;
    if (mounted) {
      _triggerExit();
    }
  }

  void _triggerExit() {
    if (_isExiting) return;
    setState(() => _isExiting = true);
    _exitController.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(_targetRoute);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _glowController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Matching exact Next.js CSS variables
    final overlay1 = isDark
        ? const Color(0xE6090D16) // rgba(9, 13, 22, 0.90)
        : const Color(0xD9F8FAFC); // rgba(248, 250, 252, 0.85)

    final overlay2 = isDark
        ? const Color(0xF7090D16) // rgba(9, 13, 22, 0.97)
        : const Color(0xF2F8FAFC); // rgba(248, 250, 252, 0.95)

    return Scaffold(
      body: GestureDetector(
        onTap: _triggerExit,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image + Gradient
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash-bg.webp',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC)),
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

            // Animated Center Content
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _entranceController,
                  _glowController,
                  _exitController,
                ]),
                builder: (context, child) {
                  final scale = _isExiting ? _exitScale.value : _entranceScale.value;
                  final opacity = _isExiting ? _exitOpacity.value : _entranceOpacity.value;

                  return Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scale,
                      child: SlideTransition(
                        position: _entranceSlide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo with Glow Pulse
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(180, 83, 9, _isExiting ? 0.0 : 0.65),
                                    blurRadius: _glowAnimation.value,
                                    spreadRadius: _glowAnimation.value * 0.25,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.webp',
                                width: 192,
                                height: 192,
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
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                color: isDark
                                    ? const Color(0xFFF3F4F6)
                                    : const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              'ANCHORED IN FAITH, CONNECTED IN LOVE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.6,
                                color: isDark
                                    ? const Color(0xFFD1D5DB)
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Styled Theme Progress Indicator
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
          ],
        ),
      ),
    );
  }
}

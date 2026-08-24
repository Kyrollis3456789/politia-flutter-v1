import 'package:flutter/material.dart';
import 'package:politia/core/services/init_service.dart';
import 'package:politia/l10n/generated/app_localizations.dart';

/// Responsive, production-ready Splash Screen executing the Politia initialization gatekeeper.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();

    // Trigger initialization after first frame rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBootstrap();
    });
  }

  void _startBootstrap() async {
    final targetRoute = await InitializationService.instance.resolveInitialization(context);
    if (!mounted) return;

    // Navigate to target route with a clean transition
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    // Responsive scaling
    final isCompact = size.width < 600;
    final logoSize = isCompact ? 110.0 : 140.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient with ambient depth
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: isDark
                    ? const [
                        Color(0xFF1E293B), // Slate 800
                        Color(0xFF0F172A), // Slate 900
                        Color(0xFF020617), // Slate 950
                      ]
                    : const [
                        Color(0xFFF8FAFC), // Slate 50
                        Color(0xFFE2E8F0), // Slate 200
                        Color(0xFFCBD5E1), // Slate 300
                      ],
              ),
            ),
          ),

          // Subtle decorative background circles
          Positioned(
            top: -size.height * 0.1,
            right: -size.width * 0.15,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withValues(alpha: isDark ? 0.07 : 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            left: -size.width * 0.15,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigoAccent.withValues(alpha: isDark ? 0.06 : 0.04),
              ),
            ),
          ),

          // Central Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),

                        // Brand Emblem / Logo
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2563EB), // Blue 600
                                Color(0xFF1D4ED8), // Blue 700
                                Color(0xFF1E40AF), // Blue 800
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.account_balance_rounded,
                              size: logoSize * 0.55,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Application Title
                        Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                        ),

                        const SizedBox(height: 10),

                        // Subtitle / Slogan
                        Text(
                          'Empowering Digital Governance',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(flex: 2),

                        // Loading Indicator & Subtext
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Initializing Secure Environment...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                                letterSpacing: 0.3,
                              ),
                        ),

                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

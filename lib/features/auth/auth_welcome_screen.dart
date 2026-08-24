import 'package:flutter/material.dart';
import 'package:politia/l10n/generated/app_localizations.dart';
import 'package:politia/widgets/auth_language_picker.dart';
import 'package:politia/widgets/politia_branded_background.dart';

/// Standalone Welcome Screen matching the center mockup with Politia branding & breathing glow aura.
class AuthWelcomeScreen extends StatefulWidget {
  const AuthWelcomeScreen({super.key});

  @override
  State<AuthWelcomeScreen> createState() => _AuthWelcomeScreenState();
}

class _AuthWelcomeScreenState extends State<AuthWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    // Responsive scaling
    final isCompact = size.width < 440;
    final logoSize = isCompact ? 110.0 : 135.0;

    return Scaffold(
      body: PolitiaBrandedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Top Right Actions Bar (Language Switcher)
              const Positioned(
                top: 16,
                right: 20,
                child: AuthLanguagePicker(),
              ),

              // Optically Centered Content Container
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Brand Logo with Breathing Glow Aura
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: OverflowBox(
                            maxWidth: logoSize * 1.8,
                            maxHeight: logoSize * 1.8,
                            child: AnimatedBuilder(
                              animation: _glowAnimation,
                              builder: (context, _) {
                                final glowOpacity = isDark
                                    ? _glowAnimation.value * 0.60
                                    : _glowAnimation.value * 0.35;

                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: logoSize * 1.6,
                                      height: logoSize * 1.6,
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
                                          child: const Icon(Icons.church_rounded, color: Colors.white, size: 48),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Title Typography
                        Text(
                          'At Church - Coptic\u00A0Orthodox',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w700,
                            fontSize: isCompact ? 18 : 21,
                            color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF1C2340),
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Slogan
                        Text(
                          'ANCHORED IN FAITH, CONNECTED IN LOVE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w400,
                            fontSize: isCompact ? 8.5 : 9.5,
                            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF3D3520),
                            letterSpacing: isCompact ? 1.6 : 2.2,
                          ),
                        ),

                        const SizedBox(height: 38),

                        // Welcome Heading
                        Text(
                          l10n.welcomeBack,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w700,
                            fontSize: isCompact ? 24 : 28,
                            color: isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827),
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // SIGN IN (Outlined Button)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/login');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.40)
                                    : const Color(0xFFB45309),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: Text(
                              l10n.signIn,
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 1.5,
                                color: isDark ? Colors.white : const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SIGN UP (Solid Button)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? const Color(0xFFF3F4F6)
                                  : const Color(0xFFB45309),
                              foregroundColor: isDark
                                  ? const Color(0xFF111827)
                                  : Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              l10n.signUp,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Social / Alternative Footer Icons
                        Text(
                          'Login with Social Media',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialIcon(Icons.g_mobiledata_rounded, () {}),
                            const SizedBox(width: 16),
                            _buildSocialIcon(Icons.facebook_rounded, () {}),
                            const SizedBox(width: 16),
                            _buildSocialIcon(Icons.alternate_email_rounded, () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2),
            width: 1.2,
          ),
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? Colors.white70 : const Color(0xFF374151),
        ),
      ),
    );
  }
}

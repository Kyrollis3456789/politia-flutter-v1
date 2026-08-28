import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:politia/core/theme/app_colors_extension.dart';

enum StepIllustrationType {
  englishName,
  arabicName,
  nickname,
  nationalId,
  profilePhoto,
  contactInfo,
  primaryMobile,
  emailAddress,
  whatsApp,
  landline,
  socialLinks,
  family,
  education,
  location,
  church,
  hobbies,
  security,
}

/// Smooth Material-Style Lottie Micro-Animation with Theme-Adaptive Glow & Animated Fallback.
class StepIllustrationBadge extends StatefulWidget {
  final StepIllustrationType type;
  final double height;

  const StepIllustrationBadge({
    super.key,
    required this.type,
    this.height = 110,
  });

  @override
  State<StepIllustrationBadge> createState() => _StepIllustrationBadgeState();
}

class _StepIllustrationBadgeState extends State<StepIllustrationBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getLottieAssetPath(StepIllustrationType type) {
    switch (type) {
      case StepIllustrationType.englishName:
      case StepIllustrationType.arabicName:
        return 'assets/animations/identity_verification.json';
      case StepIllustrationType.nickname:
        return 'assets/animations/user_handle.json';
      case StepIllustrationType.nationalId:
        return 'assets/animations/national_id_chip.json';
      case StepIllustrationType.profilePhoto:
        return 'assets/animations/profile_photo.json';
      case StepIllustrationType.contactInfo:
      case StepIllustrationType.primaryMobile:
        return 'assets/animations/contact_chat.json';
      case StepIllustrationType.emailAddress:
        return 'assets/animations/email_envelope.json';
      case StepIllustrationType.whatsApp:
        return 'assets/animations/whatsapp_badge.json';
      case StepIllustrationType.landline:
        return 'assets/animations/landline_phone.json';
      case StepIllustrationType.socialLinks:
        return 'assets/animations/social_network.json';
      case StepIllustrationType.family:
        return 'assets/animations/family.json';
      case StepIllustrationType.education:
        return 'assets/animations/education_career.json';
      case StepIllustrationType.location:
        return 'assets/animations/location_pin.json';
      case StepIllustrationType.church:
        return 'assets/animations/church.json';
      case StepIllustrationType.hobbies:
        return 'assets/animations/hobbies_art.json';
      case StepIllustrationType.security:
        return 'assets/animations/security_shield.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetPath = _getLottieAssetPath(widget.type);

    return Center(
      child: ExcludeSemantics(
        child: Container(
          height: widget.height,
          width: widget.height * 1.45,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0x1AE5B842),
                      colors.surface,
                    ]
                  : [
                      const Color(0xFFF7F1E6),
                      const Color(0xFFEFE8DB),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? colors.primary.withValues(alpha: 0.25)
                  : const Color(0x33C89B3C),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0x1AE5B842)
                    : colors.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Lottie.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Elegant Animated Pulse/Scale Vector Fallback
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: CustomPaint(
                    painter: _IllustrationPainter(
                      type: widget.type,
                      primaryColor: colors.primary,
                      secondaryColor: colors.textSecondary,
                      isDark: isDark,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  final StepIllustrationType type;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  _IllustrationPainter({
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final goldStroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final goldFill = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.22 : 0.14)
      ..style = PaintingStyle.fill;

    final mutedStroke = Paint()
      ..color = secondaryColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    switch (type) {
      case StepIllustrationType.englishName:
      case StepIllustrationType.arabicName:
        _drawIdentityCard(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.nickname:
        _drawUserHandle(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.nationalId:
        _drawNationalIdCard(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.profilePhoto:
        _drawCameraPortrait(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.primaryMobile:
      case StepIllustrationType.contactInfo:
        _drawMobilePhone(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.emailAddress:
        _drawGlowingEmail(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.whatsApp:
        _drawWhatsAppBadge(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.landline:
        _drawLandlinePhone(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.socialLinks:
        _drawSocialNetwork(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
      case StepIllustrationType.security:
        _drawSecurityShield(canvas, center, goldStroke, goldFill);
        break;
      default:
        _drawIdentityCard(canvas, center, goldStroke, goldFill, mutedStroke);
        break;
    }
  }

  void _drawIdentityCard(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 84, height: 54),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, goldFill);
    canvas.drawRRect(rect, goldStroke);

    final avatarRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 34, center.dy - 18, 24, 24),
      const Radius.circular(6),
    );
    canvas.drawRRect(avatarRect, goldStroke);
    canvas.drawCircle(Offset(center.dx - 22, center.dy - 9), 4.5, goldStroke);

    canvas.drawLine(Offset(center.dx - 2, center.dy - 12), Offset(center.dx + 30, center.dy - 12), goldStroke);
    canvas.drawLine(Offset(center.dx - 2, center.dy - 4), Offset(center.dx + 26, center.dy - 4), mutedStroke);
    canvas.drawLine(Offset(center.dx - 2, center.dy + 4), Offset(center.dx + 18, center.dy + 4), mutedStroke);

    _drawSparkle(canvas, Offset(center.dx + 36, center.dy - 22), 5, goldStroke);
  }

  void _drawUserHandle(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    canvas.drawCircle(center, 28, goldFill);
    canvas.drawCircle(center, 28, goldStroke);

    canvas.drawCircle(Offset(center.dx, center.dy - 7), 8, goldStroke);
    final bodyPath = Path()
      ..addArc(Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 18), 3.14, 3.14);
    canvas.drawPath(bodyPath, goldStroke);

    _drawSparkle(canvas, Offset(center.dx + 26, center.dy - 18), 5.5, goldStroke);
    _drawSparkle(canvas, Offset(center.dx - 26, center.dy + 12), 4, goldStroke);
  }

  void _drawNationalIdCard(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 88, height: 56),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, goldFill);
    canvas.drawRRect(rect, goldStroke);

    final chipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 34, center.dy - 8, 18, 16),
      const Radius.circular(4),
    );
    canvas.drawRRect(chipRect, goldStroke);
    canvas.drawLine(Offset(center.dx - 25, center.dy - 8), Offset(center.dx - 25, center.dy + 8), goldStroke);

    canvas.drawLine(Offset(center.dx - 8, center.dy - 12), Offset(center.dx + 32, center.dy - 12), goldStroke);
    canvas.drawLine(Offset(center.dx - 8, center.dy - 4), Offset(center.dx + 28, center.dy - 4), mutedStroke);
    canvas.drawLine(Offset(center.dx - 8, center.dy + 4), Offset(center.dx + 30, center.dy + 4), mutedStroke);
    canvas.drawLine(Offset(center.dx - 8, center.dy + 12), Offset(center.dx + 20, center.dy + 12), mutedStroke);
  }

  void _drawCameraPortrait(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    final camRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 2), width: 72, height: 48),
      const Radius.circular(12),
    );
    canvas.drawRRect(camRect, goldFill);
    canvas.drawRRect(camRect, goldStroke);

    final topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 12, center.dy - 26, 24, 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(topRect, goldStroke);

    canvas.drawCircle(Offset(center.dx, center.dy + 2), 14, goldStroke);
    canvas.drawCircle(Offset(center.dx, center.dy + 2), 7, goldFill);
    canvas.drawCircle(Offset(center.dx + 4, center.dy - 2), 2.5, goldStroke);

    _drawSparkle(canvas, Offset(center.dx + 32, center.dy - 18), 5, goldStroke);
  }

  void _drawSecurityShield(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill) {
    final path = Path()
      ..moveTo(center.dx, center.dy - 24)
      ..lineTo(center.dx + 22, center.dy - 14)
      ..lineTo(center.dx + 22, center.dy + 6)
      ..quadraticBezierTo(center.dx + 22, center.dy + 24, center.dx, center.dy + 28)
      ..quadraticBezierTo(center.dx - 22, center.dy + 24, center.dx - 22, center.dy + 6)
      ..lineTo(center.dx - 22, center.dy - 14)
      ..close();

    canvas.drawPath(path, goldFill);
    canvas.drawPath(path, goldStroke);

    // Keyhole or Check
    final checkPath = Path()
      ..moveTo(center.dx - 8, center.dy + 2)
      ..lineTo(center.dx - 2, center.dy + 8)
      ..lineTo(center.dx + 10, center.dy - 6);
    canvas.drawPath(checkPath, goldStroke);
  }

  void _drawMobilePhone(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    // Smartphone outline
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 44, height: 68),
      const Radius.circular(10),
    );
    canvas.drawRRect(phoneRect, goldFill);
    canvas.drawRRect(phoneRect, goldStroke);

    // Screen top speaker notch & bottom home bar
    canvas.drawLine(Offset(center.dx - 6, center.dy - 26), Offset(center.dx + 6, center.dy - 26), goldStroke);
    canvas.drawLine(Offset(center.dx - 8, center.dy + 26), Offset(center.dx + 8, center.dy + 26), goldStroke);

    // Inner Phone handset icon on screen
    canvas.drawCircle(Offset(center.dx, center.dy), 9, goldFill);
    final phonePath = Path()
      ..moveTo(center.dx - 4, center.dy - 4)
      ..lineTo(center.dx - 1, center.dy - 4)
      ..lineTo(center.dx + 1, center.dy - 2)
      ..lineTo(center.dx + 4, center.dy + 1)
      ..lineTo(center.dx + 4, center.dy + 4);
    canvas.drawPath(phonePath, goldStroke);

    // Radiating signal arcs on the top-right
    final arcRect1 = Rect.fromCircle(center: Offset(center.dx + 22, center.dy - 16), radius: 8);
    final arcRect2 = Rect.fromCircle(center: Offset(center.dx + 22, center.dy - 16), radius: 14);
    canvas.drawArc(arcRect1, -1.2, 1.2, false, goldStroke);
    canvas.drawArc(arcRect2, -1.2, 1.2, false, mutedStroke);

    _drawSparkle(canvas, Offset(center.dx - 28, center.dy - 18), 4.5, goldStroke);
  }

  void _drawGlowingEmail(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    // Envelope Body
    final envRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 72, height: 48),
      const Radius.circular(10),
    );
    canvas.drawRRect(envRect, goldFill);
    canvas.drawRRect(envRect, goldStroke);

    // Envelope Flap Lines
    final flapPath = Path()
      ..moveTo(center.dx - 36, center.dy - 24)
      ..lineTo(center.dx, center.dy + 4)
      ..lineTo(center.dx + 36, center.dy - 24);
    canvas.drawPath(flapPath, goldStroke);

    // Subtle bottom corner fold accents
    final bottomFold1 = Path()
      ..moveTo(center.dx - 36, center.dy + 24)
      ..lineTo(center.dx - 12, center.dy - 2);
    final bottomFold2 = Path()
      ..moveTo(center.dx + 36, center.dy + 24)
      ..lineTo(center.dx + 12, center.dy - 2);
    canvas.drawPath(bottomFold1, mutedStroke);
    canvas.drawPath(bottomFold2, mutedStroke);

    // "@" / Glowing sparkle indicator
    _drawSparkle(canvas, Offset(center.dx + 34, center.dy - 22), 6.0, goldStroke);
    _drawSparkle(canvas, Offset(center.dx - 32, center.dy + 18), 4.0, goldStroke);
  }

  void _drawWhatsAppBadge(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    // Speech Bubble with Pointer Tail
    final bubblePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy - 2), width: 62, height: 50),
        const Radius.circular(16),
      ))
      ..moveTo(center.dx - 14, center.dy + 23)
      ..lineTo(center.dx - 24, center.dy + 31)
      ..lineTo(center.dx - 18, center.dy + 21)
      ..close();

    canvas.drawPath(bubblePath, goldFill);
    canvas.drawPath(bubblePath, goldStroke);

    // Phone Handset inside bubble
    final handsetPath = Path()
      ..moveTo(center.dx - 9, center.dy - 8)
      ..quadraticBezierTo(center.dx - 12, center.dy + 2, center.dx + 4, center.dy + 12)
      ..lineTo(center.dx + 9, center.dy + 9)
      ..lineTo(center.dx + 7, center.dy + 4)
      ..lineTo(center.dx + 2, center.dy + 4)
      ..lineTo(center.dx - 4, center.dy - 2)
      ..lineTo(center.dx - 4, center.dy - 7)
      ..close();
    canvas.drawPath(handsetPath, goldStroke);

    // Double Checkmark Badge on top-right
    final checkPath = Path()
      ..moveTo(center.dx + 18, center.dy - 16)
      ..lineTo(center.dx + 22, center.dy - 12)
      ..lineTo(center.dx + 30, center.dy - 20);
    canvas.drawPath(checkPath, goldStroke);

    _drawSparkle(canvas, Offset(center.dx + 34, center.dy - 12), 4.5, goldStroke);
  }

  void _drawLandlinePhone(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    // Desk Phone Base
    final basePath = Path()
      ..moveTo(center.dx - 32, center.dy + 22)
      ..lineTo(center.dx - 24, center.dy - 4)
      ..lineTo(center.dx + 24, center.dy - 4)
      ..lineTo(center.dx + 32, center.dy + 22)
      ..close();
    canvas.drawPath(basePath, goldFill);
    canvas.drawPath(basePath, goldStroke);

    // Keypad Grid Dots on Base
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        canvas.drawCircle(
          Offset(center.dx - 8 + (c * 8), center.dy + 2 + (r * 6)),
          1.6,
          goldStroke,
        );
      }
    }

    // Phone Handset on top
    final handsetRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 14), width: 68, height: 16),
      const Radius.circular(8),
    );
    canvas.drawRRect(handsetRect, goldFill);
    canvas.drawRRect(handsetRect, goldStroke);

    // Handset Earpieces
    canvas.drawCircle(Offset(center.dx - 24, center.dy - 14), 6, goldStroke);
    canvas.drawCircle(Offset(center.dx + 24, center.dy - 14), 6, goldStroke);

    // Coiled Wire from Left Base
    final wirePath = Path()
      ..moveTo(center.dx - 26, center.dy + 12)
      ..quadraticBezierTo(center.dx - 36, center.dy + 18, center.dx - 30, center.dy + 26);
    canvas.drawPath(wirePath, mutedStroke);

    _drawSparkle(canvas, Offset(center.dx + 34, center.dy - 20), 4.5, goldStroke);
  }

  void _drawSocialNetwork(Canvas canvas, Offset center, Paint goldStroke, Paint goldFill, Paint mutedStroke) {
    // Central Hub Node
    canvas.drawCircle(center, 12, goldFill);
    canvas.drawCircle(center, 12, goldStroke);
    canvas.drawCircle(center, 4, goldStroke);

    // 3 Orbiting Social Nodes
    final node1 = Offset(center.dx - 28, center.dy - 16);
    final node2 = Offset(center.dx + 28, center.dy - 16);
    final node3 = Offset(center.dx, center.dy + 24);

    // Connecting Lines
    canvas.drawLine(center, node1, mutedStroke);
    canvas.drawLine(center, node2, mutedStroke);
    canvas.drawLine(center, node3, mutedStroke);

    // Draw Outer Nodes
    for (final node in [node1, node2, node3]) {
      canvas.drawCircle(node, 8, goldFill);
      canvas.drawCircle(node, 8, goldStroke);
    }

    _drawSparkle(canvas, Offset(center.dx + 36, center.dy + 14), 5.0, goldStroke);
    _drawSparkle(canvas, Offset(center.dx - 36, center.dy + 14), 4.0, goldStroke);
  }

  void _drawSparkle(Canvas canvas, Offset position, double radius, Paint paint) {
    final path = Path()
      ..moveTo(position.dx, position.dy - radius)
      ..quadraticBezierTo(position.dx, position.dy, position.dx + radius, position.dy)
      ..quadraticBezierTo(position.dx, position.dy, position.dx, position.dy + radius)
      ..quadraticBezierTo(position.dx, position.dy, position.dx - radius, position.dy)
      ..quadraticBezierTo(position.dx, position.dy, position.dx, position.dy - radius);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.isDark != isDark;
  }
}

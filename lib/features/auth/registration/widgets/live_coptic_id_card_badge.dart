import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:politia/core/theme/app_colors_extension.dart';

/// Principal-grade Digital Member Pass for Politia.
///
/// Features:
/// - Front Face:
///   * Top Row: Metallic EMV gold chip container + NFC contactless wave icon (left), "POLITIA" branding (right).
///   * Middle Row: Masked ID format (`•••• •••• •••• 2026`) with monospace tracking stacked above the dynamic Full English Name.
///   * Bottom Row: Clean 2-column + avatar metadata grid with strict `Expanded` and `FittedBox` protections to guarantee 0 horizontal overflow.
/// - Back Face (Arabic Context):
///   * Realistic dark magnetic stripe along the top edge.
///   * High-contrast barcode with formatted National ID number (`2 •••• •• •• •• •••••`).
///   * Crisp Arabic typography with proper alignment and auto-scaling.
/// - Smooth 3D perspective flip (Matrix4 with z-perspective) + tactile haptic feedback.
class LiveCopticIdCardBadge extends StatefulWidget {
  final String englishName;
  final String arabicName;
  final DateTime? dateOfBirth;
  final String? nationalId;
  final String? avatarPath;
  final bool isFocused;
  final bool isComplete;
  final bool isArabic;
  final bool showBackFace;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  final String? nickname;
  final String? gender;

  const LiveCopticIdCardBadge({
    super.key,
    required this.englishName,
    required this.arabicName,
    this.dateOfBirth,
    this.nationalId,
    this.avatarPath,
    this.isFocused = false,
    this.isComplete = false,
    this.isArabic = false,
    this.showBackFace = false,
    this.margin,
    this.width,
    this.height,
    this.nickname,
    this.gender,
  });

  @override
  State<LiveCopticIdCardBadge> createState() => _LiveCopticIdCardBadgeState();
}

class _LiveCopticIdCardBadgeState extends State<LiveCopticIdCardBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  bool get _shouldShowBack => widget.showBackFace || widget.isArabic;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: _shouldShowBack ? 1.0 : 0.0,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant LiveCopticIdCardBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldShowBack = oldWidget.showBackFace || oldWidget.isArabic;
    if (_shouldShowBack != oldShowBack) {
      HapticFeedback.selectionClick();
      if (_shouldShowBack) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  /// Formats the 14-digit national ID in authentic Egyptian National ID Card spacing
  String _formatEgyptianNationalId(String? id) {
    final clean = (id ?? '').replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) {
      return "2  ••••  ••  ••  ••  •••••";
    }

    final buffer = StringBuffer();
    for (int i = 0; i < 14; i++) {
      if (i < clean.length) {
        buffer.write(clean[i]);
      } else {
        buffer.write('•');
      }

      if (i == 0 || i == 2 || i == 4 || i == 6 || i == 8) {
        buffer.write('  ');
      }
    }
    return buffer.toString();
  }

  String getGenderLabel(String? gender, bool isArabic) {
    if (gender == null || gender.trim().isEmpty) return '--';
    final g = gender.toLowerCase().trim();
    final isMale = g == 'male' || g == 'ذكر';
    return isArabic ? (isMale ? 'ذكر' : 'أنثى') : (isMale ? 'MALE' : 'FEMALE');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasFocus = widget.isFocused;
    final bool isComplete = widget.isComplete;

    final double? targetHeight = widget.height;
    final double? targetWidth =
        widget.width ?? (targetHeight != null ? (targetHeight * 1.586) : null);
    final bool isCompact = (targetHeight != null && targetHeight < 160);

    final cardBorderColor = hasFocus
        ? colors.primary
        : (isComplete
            ? colors.primary.withValues(alpha: 0.4)
            : colors.primary.withValues(alpha: 0.22));

    final cardShadowColor = Colors.black.withValues(alpha: isDark ? 0.35 : 0.12);

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final flipVal = _flipAnimation.value;
        final isBackFace = flipVal >= 0.5;
        final angle = flipVal * math.pi;

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        Widget cardContent = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0xFF191815) : const Color(0xFF22201C),
            border: Border.all(
              color: cardBorderColor,
              width: hasFocus || isComplete ? 1.3 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Subtle Matte Grain & Hairlines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CardHairlinePainter(),
                  ),
                ),

                // Card Face Content
                isBackFace
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: _buildBackFaceArabic(context, colors, isDark, isCompact),
                        ),
                      )
                    : Directionality(
                        textDirection: TextDirection.ltr,
                        child: _buildFrontFaceEnglish(context, colors, isDark, isCompact),
                      ),
              ],
            ),
          ),
        );

        Widget cardBox;
        if (targetHeight != null && targetWidth != null) {
          cardBox = SizedBox(
            height: targetHeight,
            width: targetWidth,
            child: AspectRatio(
              aspectRatio: 1.586,
              child: cardContent,
            ),
          );
        } else if (targetHeight != null) {
          cardBox = SizedBox(
            height: targetHeight,
            child: AspectRatio(
              aspectRatio: 1.586,
              child: cardContent,
            ),
          );
        } else if (targetWidth != null) {
          cardBox = SizedBox(
            width: targetWidth,
            child: AspectRatio(
              aspectRatio: 1.586,
              child: cardContent,
            ),
          );
        } else {
          cardBox = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360, maxHeight: 180),
            child: AspectRatio(
              aspectRatio: 1.586,
              child: cardContent,
            ),
          );
        }

        return Center(
          child: ExcludeSemantics(
            child: Container(
              margin: widget.margin ??
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Transform(
                alignment: Alignment.center,
                transform: transform,
                child: cardBox,
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // FRONT FACE: Authentic Digital Member Pass (English)
  // =========================================================================
  Widget _buildFrontFaceEnglish(
    BuildContext context,
    AppColorsExtension colors,
    bool isDark,
    bool isCompact,
  ) {
    final displayName = widget.englishName.trim().isEmpty
        ? 'FULL MEMBER NAME'
        : widget.englishName.trim().toUpperCase();

    final isPlaceholder = widget.englishName.trim().isEmpty;

    return Stack(
      children: [
        // Watermark Church Emblem
        Positioned(
          right: isCompact ? -8 : -12,
          bottom: isCompact ? -10 : -16,
          child: Opacity(
            opacity: 0.04,
            child: Icon(
              Icons.church_rounded,
              size: isCompact ? 75 : 110,
              color: const Color(0xFFE5B842),
            ),
          ),
        ),

        Padding(
          padding: isCompact
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 1. Top Row: Metallic EMV Chip + NFC Wave | POLITIA + Status
              // -------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Metallic EMV Chip Container
                      _buildMetallicEmvChip(isCompact),
                      const SizedBox(width: 6),
                      // NFC Contactless Wave Icon
                      Icon(
                        Icons.contactless_rounded,
                        size: isCompact ? 15 : 18,
                        color: const Color(0xB3E5B842),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isComplete)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _buildVerifiedBadge(colors, isCompact),
                        ),
                      Icon(
                        Icons.church_rounded,
                        size: isCompact ? 12 : 14,
                        color: const Color(0xFFE5B842),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "POLITIA",
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: isCompact ? 10.0 : 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: const Color(0xFFE5B842),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // -------------------------------------------------------------
              // 2. Middle Row: Masked ID + Dynamic Full English Name
              // -------------------------------------------------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Masked Member Card ID Format
                  Text(
                    "••••  ••••  ••••  2026",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isCompact ? 8.0 : 9.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: isCompact ? 1.2 : 1.8,
                      color: const Color(0x80E5B842),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        displayName,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isCompact ? 12.5 : 15.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: isPlaceholder
                              ? const Color(0x50FFFFFF)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // -------------------------------------------------------------
              // 3. Bottom Row: Overflow-Proof Metadata Grid
              // -------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Col 1: Date of Birth & Exp
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "BIRTH / EXP",
                          style: TextStyle(
                            fontSize: isCompact ? 6.5 : 7.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: const Color(0x66FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.dateOfBirth != null
                                ? "${DateFormat('dd/MM/yyyy').format(widget.dateOfBirth!)} • 12/30"
                                : "DD/MM/YYYY • 12/30",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: isCompact ? 8.5 : 10.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                              letterSpacing: 0.3,
                              color: widget.dateOfBirth != null
                                  ? Colors.white
                                  : const Color(0x50FFFFFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Col 2: Parish / Gender
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "PARISH / GENDER",
                          style: TextStyle(
                            fontSize: isCompact ? 6.5 : 7.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: const Color(0x66FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "COPTIC • ${getGenderLabel(widget.gender, false)}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: isCompact ? 8.5 : 10.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              letterSpacing: 0.4,
                              color: const Color(0xFFE5B842),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Col 3: Polished Avatar Frame
                  _buildAvatarSlot(isCompact),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // BACK FACE: Ecclesiastical & Civil Identity (Arabic / Barcode)
  // =========================================================================
  Widget _buildBackFaceArabic(
    BuildContext context,
    AppColorsExtension colors,
    bool isDark,
    bool isCompact,
  ) {
    final displayName = widget.arabicName.trim().isEmpty
        ? 'الاسم الرباعي باللغة العربية'
        : widget.arabicName.trim();

    final isPlaceholder = widget.arabicName.trim().isEmpty;
    final isArabic = widget.isArabic || Localizations.localeOf(context).languageCode == 'ar';
    final genderDisplay = getGenderLabel(widget.gender, isArabic);
    final hasGender = widget.gender != null && widget.gender!.trim().isNotEmpty;

    return Stack(
      children: [
        // 1. Realistic Magnetic Stripe Along Top Edge
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: isCompact ? 24 : 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0C0A),
                  Color(0xFF1A1814),
                  Color(0xFF0D0C0A),
                ],
              ),
            ),
          ),
        ),

        // 2. Gold Church Watermark
        Positioned(
          left: isCompact ? 8 : 12,
          top: isCompact ? 32 : 42,
          child: Opacity(
            opacity: 0.05,
            child: Icon(
              Icons.church_rounded,
              size: isCompact ? 60 : 80,
              color: const Color(0xFFE5B842),
            ),
          ),
        ),

        Padding(
          padding: isCompact
              ? const EdgeInsets.fromLTRB(12, 28, 12, 8)
              : const EdgeInsets.fromLTRB(16, 36, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // 3. Middle Row: Arabic Full Name + Gender
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Full Arabic Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? "الاسم بالكامل" : "FULL NAME",
                          style: TextStyle(
                            fontSize: isCompact ? 7.0 : 8.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: const Color(0x66FFFFFF),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              displayName,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: isCompact ? 12.5 : 14.5,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: isPlaceholder
                                    ? const Color(0x50FFFFFF)
                                    : Colors.white,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Gender Metadata
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? "النوع" : "GENDER",
                        style: TextStyle(
                          fontSize: isCompact ? 7.0 : 8.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: const Color(0x66FFFFFF),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          genderDisplay,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: isCompact ? 9.5 : 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: hasGender
                                ? const Color(0xFFE5B842)
                                : const Color(0x50FFFFFF),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // 4. Bottom: High-Contrast Barcode & Formatted National ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: isCompact ? 12 : 15,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _EgyptianBarcodePainter(),
                    ),
                  ),
                  const SizedBox(height: 3),

                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        _formatEgyptianNationalId(widget.nationalId),
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: isCompact ? 9.5 : 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: isCompact ? 0.8 : 1.2,
                          color: const Color(0xFFE5B842),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Metallic EMV Chip Widget
  // =========================================================================
  Widget _buildMetallicEmvChip(bool isCompact) {
    final double chipWidth = isCompact ? 26 : 32;
    final double chipHeight = isCompact ? 18 : 23;

    return Container(
      width: chipWidth,
      height: chipHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.5),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE58F),
            Color(0xFFE5B842),
            Color(0xFF9E7822),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF735714),
          width: 0.5,
        ),
      ),
      child: CustomPaint(
        painter: _EmvChipTracesPainter(),
      ),
    );
  }

  // =========================================================================
  // Polished Circular Avatar Slot (36px, 1.5px Ambient Gold Ring)
  // =========================================================================
  Widget _buildAvatarSlot(bool isCompact) {
    final hasImage = widget.avatarPath != null &&
        widget.avatarPath!.isNotEmpty &&
        File(widget.avatarPath!).existsSync();

    final double size = isCompact ? 30 : 36;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x1AE5B842),
        border: Border.all(
          color: const Color(0xFFE5B842),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5B842).withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? Image.file(
                File(widget.avatarPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person_rounded,
                  size: isCompact ? 16 : 20,
                  color: const Color(0xFFE5B842),
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: isCompact ? 16 : 20,
                color: const Color(0xFFE5B842).withValues(alpha: 0.7),
              ),
      ),
    );
  }

  Widget _buildVerifiedBadge(AppColorsExtension colors, bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 4 : 5,
        vertical: isCompact ? 1.0 : 1.5,
      ),
      decoration: BoxDecoration(
        color: colors.statusSuccess.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.statusSuccess, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: isCompact ? 7 : 8, color: colors.statusSuccess),
          const SizedBox(width: 2),
          Text(
            "VERIFIED",
            style: TextStyle(
              fontSize: isCompact ? 7.0 : 7.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: colors.statusSuccess,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for authentic EMV chip internal contact lines
class _EmvChipTracesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF735714)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final midX = size.width / 2;
    final midY = size.height / 2;

    // Horizontal center divider
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), paint);

    // Left & right verticals
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), paint);

    // Center circular contact
    final centerPaint = Paint()
      ..color = const Color(0xFF735714)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(midX, midY), size.height * 0.22, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for subtle hairline geometric texture
class _CardHairlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0DE5B842)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.32),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.68),
      Offset(size.width, size.height * 0.68),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for high-contrast barcode
class _EgyptianBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5B842)
      ..strokeCap = StrokeCap.square;

    final pattern = [
      3, 1, 2, 2, 1, 3, 2, 1, 4, 1, 2, 3, 1, 2, 1, 3, 2, 1, 1, 4, 2, 1, 3, 2,
      1, 2, 3, 1, 4, 1, 2, 2, 1, 3, 2, 1, 3, 2, 1, 4, 1, 2, 3, 1, 2, 1, 3, 2,
    ];

    double currentX = 0;
    final totalUnits = pattern.fold<int>(0, (sum, w) => sum + w);
    final unitWidth = size.width / (totalUnits + 10);

    for (int i = 0; i < pattern.length; i++) {
      final barWidth = pattern[i] * unitWidth;
      if (i % 2 == 0) {
        paint.strokeWidth = barWidth;
        canvas.drawLine(
          Offset(currentX + (barWidth / 2), 0),
          Offset(currentX + (barWidth / 2), size.height),
          paint,
        );
      }
      currentX += barWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

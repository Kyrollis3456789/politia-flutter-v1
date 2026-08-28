import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:politia/core/theme/app_colors_extension.dart';
import 'package:politia/core/theme/app_design_tokens.dart';

/// Pixel-perfect Material Outlined Text Field with floating label, prefix icon,
/// helper/error message, and character counter matching the unified design tokens.
class CustomAuthTextField extends StatefulWidget {
  const CustomAuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isValid,
    this.isRequired = false,
    this.maxLength,
    this.showCounter = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.textDirection,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool? isValid;
  final bool isRequired;
  final int? maxLength;
  final bool showCounter;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final TextAlign textAlign;

  @override
  State<CustomAuthTextField> createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  Widget? _resolvePrefixIcon(Color iconColor) {
    if (widget.prefixIcon != null) {
      return widget.prefixIcon;
    }

    final lower = widget.label.toLowerCase();
    IconData? defaultIcon;

    if (lower.contains('name') ||
        lower.contains('الاسم') ||
        lower.contains('nickname') ||
        lower.contains('شهرة') ||
        lower.contains('لقب')) {
      defaultIcon = Icons.person_outline_rounded;
    } else if (lower.contains('pass') ||
        lower.contains('مرور') ||
        lower.contains('أمان') ||
        lower.contains('كلمة')) {
      defaultIcon = Icons.lock_outline_rounded;
    } else if (lower.contains('phone') ||
        lower.contains('mobile') ||
        lower.contains('هاتف') ||
        lower.contains('موبايل') ||
        lower.contains('تليفون') ||
        lower.contains('رقم')) {
      defaultIcon = Icons.phone_outlined;
    } else if (lower.contains('email') ||
        lower.contains('mail') ||
        lower.contains('بريد')) {
      defaultIcon = Icons.email_outlined;
    } else if (lower.contains('national') ||
        lower.contains('id') ||
        lower.contains('الرقم القومي') ||
        lower.contains('قومي') ||
        lower.contains('بطاقة')) {
      defaultIcon = Icons.badge_outlined;
    } else if (lower.contains('church') ||
        lower.contains('كنيسة') ||
        lower.contains('diocese') ||
        lower.contains('إيبارشية') ||
        lower.contains('خدمة')) {
      defaultIcon = Icons.church_outlined;
    } else if (lower.contains('street') ||
        lower.contains('city') ||
        lower.contains('governorate') ||
        lower.contains('address') ||
        lower.contains('عنوان') ||
        lower.contains('شارع') ||
        lower.contains('محافظة') ||
        lower.contains('مدينة')) {
      defaultIcon = Icons.location_on_outlined;
    } else if (lower.contains('school') ||
        lower.contains('university') ||
        lower.contains('job') ||
        lower.contains('company') ||
        lower.contains('تعليم') ||
        lower.contains('عمل') ||
        lower.contains('جامعة') ||
        lower.contains('مؤهل')) {
      defaultIcon = Icons.business_center_outlined;
    }

    if (defaultIcon != null) {
      return Icon(defaultIcon, size: AppDesignTokens.iconRegular, color: iconColor);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colors.primary;
    final errorColor = colors.statusError;
    final normalBorderColor = colors.border;
    final iconColor = colors.textMuted;

    final prefix = _resolvePrefixIcon(iconColor);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      buildCounter: widget.showCounter || widget.maxLength != null
          ? (context, {required currentLength, required isFocused, maxLength}) {
              if (maxLength != null) {
                return Text(
                  '$currentLength / $maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.statusInfo,
                  ),
                );
              }
              return null;
            }
          : null,
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: primaryColor,
      cursorErrorColor: errorColor,
      decoration: InputDecoration(
        labelText: widget.isRequired ? '${widget.label}*' : widget.label,
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: colors.textMuted,
          fontSize: 14.0,
        ),
        helperText: widget.helperText,
        helperStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 12.0,
        ),
        errorStyle: TextStyle(
          color: errorColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: isDark ? colors.surface : Colors.white,
        
        // Outlined Borders using 12.0 radius
        border: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(color: normalBorderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(color: normalBorderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(color: errorColor, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppDesignTokens.borderRadiusInput,
          borderSide: BorderSide(
            color: colors.border.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),

        // Suffix Icon (Password toggle / validation tick / custom)
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: AppDesignTokens.iconRegular,
                  color: colors.textMuted,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon ??
                (widget.isValid == true
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: AppDesignTokens.iconRegular,
                          color: colors.statusSuccess,
                        ),
                      )
                    : null),
      ),
    );
  }
}

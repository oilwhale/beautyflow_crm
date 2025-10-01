import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_text_styles.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Secondary Button (Outline стиль)
/// Использование: вторичные действия (отмена, назад, и т.д.)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    final Color effectiveBorderColor = borderColor ?? AppColors.border;
    final Color effectiveTextColor = textColor ?? AppColors.textDark;
    final Color effectiveBackgroundColor = backgroundColor ?? AppColors.white;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppSpacing.buttonHeightMedium,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              alignment: Alignment.center,
              padding: AppSpacing.buttonPadding,
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                border: Border.all(
                  color: effectiveBorderColor,
                  width: 2,
                ),
                borderRadius: AppSpacing.borderRadiusLg,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          effectiveTextColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: AppSpacing.iconSm,
                            color: effectiveTextColor,
                          ),
                          AppSpacing.hGapSm,
                        ],
                        Text(
                          text,
                          style: AppTextStyles.button.copyWith(
                            color: effectiveTextColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Transparent Secondary Button (прозрачная)
class TransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;

  const TransparentButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: Colors.transparent,
      borderColor: AppColors.border,
      textColor: textColor ?? AppColors.textGray,
    );
  }
}

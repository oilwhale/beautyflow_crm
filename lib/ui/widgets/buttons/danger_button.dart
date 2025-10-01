import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_text_styles.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Danger Button (для деструктивных действий)
/// Использование: удаление, отмена записи
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isFilled; // заполненная или outline

  const DangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: AppSpacing.buttonHeightMedium,
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
                color: isFilled ? AppColors.error : Colors.transparent,
                border: isFilled
                    ? null
                    : Border.all(
                        color: AppColors.error,
                        width: 2,
                      ),
                borderRadius: AppSpacing.borderRadiusLg,
                boxShadow: isFilled
                    ? [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFilled ? AppColors.white : AppColors.error,
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
                            color: isFilled ? AppColors.white : AppColors.error,
                          ),
                          AppSpacing.hGapSm,
                        ],
                        Text(
                          text,
                          style: AppTextStyles.button.copyWith(
                            color: isFilled ? AppColors.white : AppColors.error,
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

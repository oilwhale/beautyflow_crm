import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Custom Card (базовая карточка)
/// Использование: все карточки в приложении
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool hasShadow;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.hasShadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(
            color: AppColors.border,
            width: 2,
          ),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_text_styles.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Status Badge (Бейдж статуса)
/// Использование: статусы записей, клиентов
class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.text,
    this.color,
    this.backgroundColor,
    this.icon,
    this.isSmall = false,
  });

  /// Создать бейдж для статуса записи
  factory StatusBadge.status(String status, {bool isSmall = false}) {
    Color color;
    String displayText;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'подтверждено':
        color = AppColors.success;
        displayText = 'Подтверждено';
        break;
      case 'pending':
      case 'ожидает':
        color = AppColors.warning;
        displayText = 'Ожидает';
        break;
      case 'cancelled':
      case 'отменено':
        color = AppColors.error;
        displayText = 'Отменено';
        break;
      case 'completed':
      case 'завершено':
        color = AppColors.primary;
        displayText = 'Завершено';
        break;
      default:
        color = AppColors.textGray;
        displayText = status;
    }

    return StatusBadge(
      text: displayText,
      color: color,
      backgroundColor: color.withOpacity(0.2),
      isSmall: isSmall,
    );
  }

  /// VIP бейдж
  factory StatusBadge.vip({bool isSmall = false}) {
    return StatusBadge(
      text: 'VIP',
      color: AppColors.white,
      backgroundColor: Colors.transparent,
      icon: Icons.star,
      isSmall: isSmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textDark;
    final effectiveBackgroundColor =
        backgroundColor ?? effectiveColor.withOpacity(0.2);

    return Container(
      padding: isSmall
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            )
          : const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: AppSpacing.borderRadiusXs,
        gradient: icon == Icons.star ? AppColors.primaryGradient : null,
        boxShadow: icon == Icons.star
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 12 : 14,
              color: effectiveColor,
            ),
            SizedBox(width: isSmall ? 4 : 6),
          ],
          Text(
            text,
            style: (isSmall ? AppTextStyles.tiny : AppTextStyles.tinyBold)
                .copyWith(color: effectiveColor),
          ),
        ],
      ),
    );
  }
}

/// Category Tag (Тег категории услуги)
class CategoryTag extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryTag({
    super.key,
    required this.text,
    this.color,
    this.onTap,
    this.isSelected = false,
  });

  /// Создать тег для категории услуги
  factory CategoryTag.service(
    String category, {
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return CategoryTag(
      text: category,
      color: AppColors.getServiceColor(category),
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusXl,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color:
                isSelected ? effectiveColor : effectiveColor.withOpacity(0.1),
            border: Border.all(
              color:
                  isSelected ? effectiveColor : effectiveColor.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: AppSpacing.borderRadiusXl,
          ),
          child: Text(
            text,
            style: AppTextStyles.smallSemibold.copyWith(
              color: isSelected ? AppColors.white : effectiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Count Badge (Бейдж с количеством)
/// Использование: количество уведомлений, визитов
class CountBadge extends StatelessWidget {
  final int count;
  final Color? color;
  final double? size;

  const CountBadge({
    super.key,
    required this.count,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = count > 99 ? '99+' : count.toString();
    final effectiveSize = size ?? 20.0;
    final effectiveColor = color ?? AppColors.error;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: effectiveColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          displayCount,
          style: TextStyle(
            fontSize: effectiveSize * 0.5,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

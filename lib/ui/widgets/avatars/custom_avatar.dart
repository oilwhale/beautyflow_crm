import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Custom Avatar (Аватар клиента)
/// Использование: отображение аватара клиента с инициалами
class CustomAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool hasStatus;
  final Color? statusColor;

  const CustomAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AppSpacing.avatarMedium,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.hasStatus = false,
    this.statusColor,
  });

  /// Получить инициалы из имени
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Получить цвет на основе имени (для разнообразия)
  Color _getColorFromName(String name) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.serviceHair,
      AppColors.serviceNails,
      AppColors.serviceMassage,
      AppColors.serviceMakeup,
      AppColors.serviceSpa,
      AppColors.serviceLashes,
    ];

    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final bgColor = backgroundColor ?? _getColorFromName(name);
    final txtColor = textColor ?? AppColors.white;
    final fontSize = size * 0.4;
    final borderRadius = size * 0.3; // 30% от размера

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: imageUrl == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  bgColor.withOpacity(0.8),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.shadowSm,
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback на инициалы если изображение не загрузилось
                  return Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: txtColor,
                        height: 1,
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: txtColor,
                  height: 1,
                ),
              ),
            ),
    );

    // Добавляем status indicator если нужен
    if (hasStatus) {
      avatarWidget = Stack(
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: statusColor ?? AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Добавляем onTap если передан
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}

/// Avatar Group (Группа аватаров с наложением)
class AvatarGroup extends StatelessWidget {
  final List<String> names;
  final List<String?>? imageUrls;
  final double size;
  final int maxVisible;
  final double overlapFactor; // 0.0 - 1.0

  const AvatarGroup({
    super.key,
    required this.names,
    this.imageUrls,
    this.size = AppSpacing.avatarSmall,
    this.maxVisible = 4,
    this.overlapFactor = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = names.length > maxVisible ? maxVisible : names.length;
    final remainingCount = names.length - visibleCount;
    final overlapWidth = size * (1 - overlapFactor);

    return SizedBox(
      height: size,
      width: (visibleCount * overlapWidth) + (remainingCount > 0 ? size : 0),
      child: Stack(
        children: [
          // Видимые аватары
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * overlapWidth,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
                child: CustomAvatar(
                  name: names[i],
                  imageUrl: imageUrls != null && i < imageUrls!.length
                      ? imageUrls![i]
                      : null,
                  size: size,
                ),
              ),
            ),

          // "+N" если есть ещё
          if (remainingCount > 0)
            Positioned(
              left: visibleCount * overlapWidth,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: TextStyle(
                      fontSize: size * 0.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGray,
                      height: 1,
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

/// Avatar Sizes (предустановленные размеры)
class AvatarSizes {
  static const double mini = AppSpacing.avatarMini; // 32
  static const double small = AppSpacing.avatarSmall; // 40
  static const double medium = AppSpacing.avatarMedium; // 52
  static const double large = AppSpacing.avatarLarge; // 64
  static const double xLarge = AppSpacing.avatarXLarge; // 88
}

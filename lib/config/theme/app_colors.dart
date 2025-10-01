import 'package:flutter/material.dart';

/// Цветовая схема BeautyFlow CRM
/// Все цвета из дизайн-системы
class AppColors {
  // ============================================================
  // PRIMARY COLORS (Сливовый)
  // ============================================================

  static const Color primary = Color(0xFF7B4B8E);
  static const Color primaryLight = Color(0xFF9B7BA8);
  static const Color primaryLighter = Color(0xFFB89BC4);
  static const Color primaryLightest = Color(0xFFD5C0E0);
  static const Color primaryDark = Color(0xFF5E3A6D);
  static const Color primaryDarker = Color(0xFF42294C);
  static const Color primaryDarkest = Color(0xFF2B1A32);

  // ============================================================
  // SECONDARY COLORS (Rose Gold)
  // ============================================================

  static const Color secondary = Color(0xFFC9A992);
  static const Color secondaryLight = Color(0xFFD4B9A6);
  static const Color secondaryLighter = Color(0xFFDFC9BA);
  static const Color secondaryLightest = Color(0xFFEAD9CE);
  static const Color secondaryDark = Color(0xFFB89980);
  static const Color secondaryDarker = Color(0xFFA6896E);
  static const Color secondaryDarkest = Color(0xFF8E7259);

  // ============================================================
  // ACCENT COLORS (Акцентные)
  // ============================================================

  static const Color accentLavender = Color(0xFFE8E4F3);
  static const Color accentCream = Color(0xFFFAF3E8);
  static const Color accentPowder = Color(0xFFF5E6F1);
  static const Color accentMint = Color(0xFFE8F5F1);
  static const Color accentPeach = Color(0xFFFFE8E0);

  // ============================================================
  // NEUTRAL COLORS (Нейтральные)
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAF8FC);
  static const Color cardBg = Color(0xFFF5F2F8);
  static const Color lightBg = Color(0xFFFAF8FC);
  static const Color border = Color(0xFFE8E4F3);

  // Dark theme colors (moved to dark theme section below)

  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGray = Color(0xFF9B7BA8);
  static const Color textLight = Color(0xFFC4B5CE);
  static const Color disabled = Color(0xFFE0D5E8);

  // ============================================================
  // SEMANTIC COLORS (Семантические)
  // ============================================================

  // Success (зелёный)
  static const Color success = Color(0xFF9CAFAA);
  static const Color successLight = Color(0xFFC4D9D3);

  // Error (розовый)
  static const Color error = Color(0xFFE8B4C8);
  static const Color errorLight = Color(0xFFF5D9E4);

  // Warning (персиковый)
  static const Color warning = Color(0xFFF5C7A9);
  static const Color warningLight = Color(0xFFFCE3D4);

  // Info (голубой)
  static const Color info = Color(0xFFA8C9E8);
  static const Color infoLight = Color(0xFFD4E4F5);

  // ============================================================
  // SERVICE CATEGORY COLORS (Цвета категорий услуг)
  // ============================================================

  static const Color serviceHair = Color(0xFFC9A992); // Волосы
  static const Color serviceNails = Color(0xFFE8B4C8); // Ногти
  static const Color serviceMassage = Color(0xFF9CAFAA); // Массаж
  static const Color serviceMakeup = Color(0xFFF5C7A9); // Макияж
  static const Color serviceSpa = Color(0xFFA8C9E8); // СПА
  static const Color serviceLashes = Color(0xFFD4B9E8); // Ресницы/Брови

  // ============================================================
  // GRADIENTS (Градиенты)
  // ============================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCream, accentPowder, accentLavender],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, cardBg],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, error, primaryLight],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient freshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, info],
  );

  // Shadow color
  static const Color shadow = Color(0xFF000000);

  // ============================================================
  // SHADOWS (Тени)
  // ============================================================

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: primary.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: primary.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: primary.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: primary.withValues(alpha: 0.2),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  // ============================================================
  // UTILITY METHODS (Вспомогательные методы)
  // ============================================================

  /// Получить цвет категории услуги
  static Color getServiceColor(String category) {
    switch (category.toLowerCase()) {
      case 'hair':
      case 'волосы':
        return serviceHair;
      case 'nails':
      case 'ногти':
        return serviceNails;
      case 'massage':
      case 'массаж':
        return serviceMassage;
      case 'makeup':
      case 'макияж':
        return serviceMakeup;
      case 'spa':
      case 'спа':
        return serviceSpa;
      case 'lashes':
      case 'ресницы':
      case 'брови':
        return serviceLashes;
      default:
        return primary;
    }
  }

  /// Получить цвет статуса
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'подтверждено':
      case 'completed':
      case 'завершено':
        return success;
      case 'pending':
      case 'ожидает':
        return warning;
      case 'cancelled':
      case 'отменено':
        return error;
      default:
        return textGray;
    }
  }

  /// Получить прозрачность цвета
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  // Добавь эти строки в конец класса AppColors,
// перед закрывающей фигурной скобкой }

  // ==================== ТЁМНАЯ ТЕМА ====================

  /// Фон тёмной темы (тёмно-фиолетовый)
  static const Color darkBackground = Color(0xFF1A1625);

  /// Поверхность для карточек в тёмной теме
  static const Color darkSurface = Color(0xFF251D30);

  /// Светлая поверхность для тёмной темы (для hover эффектов)
  static const Color darkSurfaceLight = Color(0xFF2F2638);

  /// Границы в тёмной теме
  static const Color darkBorder = Color(0xFF3D3447);

  /// Текст на тёмном фоне (основной)
  static const Color darkText = Color(0xFFE8E4F3);

  /// Вторичный текст на тёмном фоне
  static const Color darkTextSecondary = Color(0xFFB0A8C0);

  /// Градиент для тёмной темы
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1625),
      Color(0xFF251D30),
      Color(0xFF1A1625),
    ],
  );
}

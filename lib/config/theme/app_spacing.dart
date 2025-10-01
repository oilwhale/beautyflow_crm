import 'package:flutter/material.dart';

/// Система spacing & radius для BeautyFlow CRM
/// Все отступы основаны на 4px grid системе
class AppSpacing {
  // ============================================================
  // SPACING (Отступы) - 4px Grid System
  // ============================================================

  /// 4px - Extra Small
  /// Использование: Минимальные отступы между элементами
  static const double xs = 4.0;

  /// 8px - Small
  /// Использование: Отступы внутри мелких компонентов
  static const double sm = 8.0;

  /// 12px - Medium
  /// Использование: Стандартные отступы между элементами
  static const double md = 12.0;

  /// 16px - Base (базовый)
  /// Использование: Основной отступ (padding, gap)
  static const double base = 16.0;

  /// 20px - Large
  /// Использование: Увеличенные отступы
  static const double lg = 20.0;

  /// 24px - Extra Large
  /// Использование: Отступы между секциями
  static const double xl = 24.0;

  /// 32px - 2X Large
  /// Использование: Большие отступы между блоками
  static const double xxl = 32.0;

  /// 40px - 3X Large
  /// Использование: Максимальные отступы
  static const double xxxl = 40.0;

  /// 48px - 4X Large
  /// Использование: Огромные отступы
  static const double xxxxl = 48.0;

  // ============================================================
  // EDGE INSETS PRESETS (Готовые EdgeInsets)
  // ============================================================

  // All sides (со всех сторон)
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allBase = EdgeInsets.all(base);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  // Horizontal (горизонтальные)
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalBase =
      EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: xxl);

  // Vertical (вертикальные)
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalBase = EdgeInsets.symmetric(vertical: base);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: xxl);

  // Common paddings (частые паттерны)
  static const EdgeInsets screenPadding = EdgeInsets.all(base);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: base,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: base,
  );
  static const EdgeInsets modalPadding = EdgeInsets.all(xxl);

  // ============================================================
  // BORDER RADIUS (Скругления углов)
  // ============================================================

  /// 8px - Extra Small
  /// Использование: Мелкие элементы (badges, tags)
  static const double radiusXs = 8.0;

  /// 10px - Small
  /// Использование: Мини кнопки
  static const double radiusSm = 10.0;

  /// 12px - Medium
  /// Использование: Аватары, мелкие карточки
  static const double radiusMd = 12.0;

  /// 14px - Base
  /// Использование: Базовые элементы
  static const double radiusBase = 14.0;

  /// 16px - Large
  /// Использование: Кнопки, input поля
  static const double radiusLg = 16.0;

  /// 20px - Extra Large
  /// Использование: Средние карточки
  static const double radiusXl = 20.0;

  /// 24px - 2X Large
  /// Использование: Крупные карточки
  static const double radiusXxl = 24.0;

  /// 32px - 3X Large
  /// Использование: Модальные окна
  static const double radiusXxxl = 32.0;

  /// 40px - 4X Large
  /// Использование: Особо крупные элементы
  static const double radiusXxxxl = 40.0;

  /// 999px - Full (круглый)
  /// Использование: Круглые элементы
  static const double radiusFull = 999.0;

  // ============================================================
  // BORDER RADIUS PRESETS (Готовые BorderRadius)
  // ============================================================

  static final BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusBase =
      BorderRadius.circular(radiusBase);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusXxl = BorderRadius.circular(radiusXxl);
  static final BorderRadius borderRadiusXxxl =
      BorderRadius.circular(radiusXxxl);
  static final BorderRadius borderRadiusXxxxl =
      BorderRadius.circular(radiusXxxxl);
  static final BorderRadius borderRadiusFull =
      BorderRadius.circular(radiusFull);

  // Top only (только сверху) - для модальных окон
  static final BorderRadius borderRadiusTopXl = const BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );

  static final BorderRadius borderRadiusTopXxl = const BorderRadius.only(
    topLeft: Radius.circular(radiusXxl),
    topRight: Radius.circular(radiusXxl),
  );

  static final BorderRadius borderRadiusTopXxxl = const BorderRadius.only(
    topLeft: Radius.circular(radiusXxxl),
    topRight: Radius.circular(radiusXxxl),
  );

  // Bottom only (только снизу)
  static final BorderRadius borderRadiusBottomXl = const BorderRadius.only(
    bottomLeft: Radius.circular(radiusXl),
    bottomRight: Radius.circular(radiusXl),
  );

  // ============================================================
  // SIZES (Размеры для элементов)
  // ============================================================

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;

  // Avatar sizes
  static const double avatarMini = 32.0;
  static const double avatarSmall = 40.0;
  static const double avatarMedium = 52.0;
  static const double avatarLarge = 64.0;
  static const double avatarXLarge = 88.0;

  // Button heights
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 52.0;
  static const double buttonHeightLarge = 60.0;

  // Input field heights
  static const double inputHeightSmall = 40.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;

  // Bottom nav bar height
  static const double bottomNavBarHeight = 72.0;

  // App bar height
  static const double appBarHeight = 56.0;

  // Divider height
  static const double dividerHeight = 1.0;
  static const double dividerThick = 2.0;

  // ============================================================
  // GAP (Отступы для Flex/Wrap)
  // ============================================================

  /// Создать SizedBox с шириной
  static SizedBox gapWidth(double width) => SizedBox(width: width);

  /// Создать SizedBox с высотой
  static SizedBox gapHeight(double height) => SizedBox(height: height);

  // Готовые gap'ы
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapBase = SizedBox(width: base, height: base);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);

  // Vertical gaps
  static const SizedBox vGapXs = SizedBox(height: xs);
  static const SizedBox vGapSm = SizedBox(height: sm);
  static const SizedBox vGapMd = SizedBox(height: md);
  static const SizedBox vGapBase = SizedBox(height: base);
  static const SizedBox vGapLg = SizedBox(height: lg);
  static const SizedBox vGapXl = SizedBox(height: xl);
  static const SizedBox vGapXxl = SizedBox(height: xxl);

  // Horizontal gaps
  static const SizedBox hGapXs = SizedBox(width: xs);
  static const SizedBox hGapSm = SizedBox(width: sm);
  static const SizedBox hGapMd = SizedBox(width: md);
  static const SizedBox hGapBase = SizedBox(width: base);
  static const SizedBox hGapLg = SizedBox(width: lg);
}

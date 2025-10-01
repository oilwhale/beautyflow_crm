import 'package:flutter/material.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';

/// Типографика BeautyFlow CRM
/// Все текстовые стили из дизайн-системы
class AppTextStyles {
  // Базовый шрифт
  static const String fontFamily = 'SF Pro Display'; // iOS
  // На Android автоматически будет Roboto

  // ============================================================
  // HEADINGS (Заголовки)
  // ============================================================

  /// H1 - Hero / Page Title
  /// 32px, Bold, -0.02em
  /// Использование: Главные заголовки страниц, hero секции
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.64, // -0.02em * 32
    color: AppColors.textDark,
  );

  /// H2 - Section Title
  /// 24px, Bold, -0.01em
  /// Использование: Заголовки секций, крупные блоки
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.24, // -0.01em * 24
    color: AppColors.textDark,
  );

  /// H3 - Subsection
  /// 20px, Bold
  /// Использование: Подзаголовки, карточки
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// H4 - Card Title
  /// 17px, Bold
  /// Использование: Заголовки в карточках, модальных окнах
  static const TextStyle h4 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  // ============================================================
  // BODY TEXT (Основной текст)
  // ============================================================

  /// Body - Regular Text
  /// 15px, Medium
  /// Использование: Основной текст, описания
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// Body Medium (более жирный)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// Body Gray (серый текст)
  static const TextStyle bodyGray = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textGray,
  );

  // ============================================================
  // SMALL TEXT (Мелкий текст)
  // ============================================================

  /// Small - Secondary Text
  /// 13px, Medium
  /// Использование: Вторичная информация, подписи
  static const TextStyle small = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textGray,
  );

  /// Small Dark (мелкий тёмный)
  static const TextStyle smallDark = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// Small Semibold
  static const TextStyle smallSemibold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  // ============================================================
  // TINY TEXT (Очень мелкий)
  // ============================================================

  /// Tiny - Labels & Badges
  /// 11px, Semibold, +0.02em
  /// Использование: Бейджи, метки, мини-тексты
  static const TextStyle tiny = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.22, // +0.02em * 11
    color: AppColors.textLight,
  );

  /// Tiny Dark
  static const TextStyle tinyDark = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.22,
    color: AppColors.textDark,
  );

  /// Tiny Bold
  static const TextStyle tinyBold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.22,
    color: AppColors.textDark,
  );

  // ============================================================
  // BUTTON TEXT (Текст на кнопках)
  // ============================================================

  /// Button Text
  /// 15px, Semibold, +0.01em
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.15, // +0.01em * 15
    color: AppColors.white,
  );

  /// Button Small
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.13,
    color: AppColors.white,
  );

  // ============================================================
  // СПЕЦИАЛЬНЫЕ СТИЛИ
  // ============================================================

  /// Price (цена)
  static const TextStyle price = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  /// Price Small
  static const TextStyle priceSmall = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  /// Number Big (большие числа в статистике)
  static const TextStyle numberBig = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.64,
    color: AppColors.textDark,
  );

  /// Number Medium
  static const TextStyle numberMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.24,
    color: AppColors.textDark,
  );

  // ============================================================
  // СТИЛИ ДЛЯ INPUT ПОЛЕЙ
  // ============================================================

  /// Input Label
  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// Input Text
  static const TextStyle inputText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  );

  /// Input Placeholder
  static const TextStyle inputPlaceholder = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textLight,
  );

  /// Input Error
  static const TextStyle inputError = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.error,
  );

  // ============================================================
  // UTILITY METHODS (Вспомогательные методы)
  // ============================================================

  /// Изменить цвет текста
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Изменить вес шрифта
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Изменить размер
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Сделать белым (для текста на градиенте)
  static TextStyle makeWhite(TextStyle style) {
    return style.copyWith(color: AppColors.white);
  }

  /// Сделать жирным
  static TextStyle makeBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }
}

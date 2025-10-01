import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== THEME MODE PROVIDER ====================

/// Провайдер текущего режима темы (light/dark/system)
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  /// Установить светлую тему
  void setLightMode() {
    state = ThemeMode.light;
  }

  /// Установить темную тему
  void setDarkMode() {
    state = ThemeMode.dark;
  }

  /// Использовать системную тему
  void setSystemMode() {
    state = ThemeMode.system;
  }

  /// Переключить между светлой и темной темой
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Установить режим по индексу (0 = light, 1 = dark, 2 = system)
  void setModeByIndex(int index) {
    switch (index) {
      case 0:
        state = ThemeMode.light;
        break;
      case 1:
        state = ThemeMode.dark;
        break;
      case 2:
        state = ThemeMode.system;
        break;
      default:
        state = ThemeMode.light;
    }
  }
}

// ==================== THEME VARIANT PROVIDER ====================

/// Доступные варианты цветовых тем
enum ThemeVariant {
  /// Основная тема (сливовый)
  primary,

  /// Розовая тема
  rose,

  /// Лавандовая тема
  lavender,

  /// Персиковая тема
  peach,

  /// Мятная тема
  mint,

  /// Коралловая тема
  coral,

  /// Шоколадная тема
  chocolate,
}

/// Провайдер выбранного варианта темы
final themeVariantProvider =
    StateNotifierProvider<ThemeVariantNotifier, ThemeVariant>((ref) {
  return ThemeVariantNotifier();
});

class ThemeVariantNotifier extends StateNotifier<ThemeVariant> {
  ThemeVariantNotifier() : super(ThemeVariant.primary);

  /// Установить вариант темы
  void setVariant(ThemeVariant variant) {
    state = variant;
  }

  /// Получить название темы
  String getVariantName(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.primary:
        return 'Сливовая';
      case ThemeVariant.rose:
        return 'Розовая';
      case ThemeVariant.lavender:
        return 'Лавандовая';
      case ThemeVariant.peach:
        return 'Персиковая';
      case ThemeVariant.mint:
        return 'Мятная';
      case ThemeVariant.coral:
        return 'Коралловая';
      case ThemeVariant.chocolate:
        return 'Шоколадная';
    }
  }

  /// Получить эмодзи темы
  String getVariantEmoji(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.primary:
        return '💜';
      case ThemeVariant.rose:
        return '🌹';
      case ThemeVariant.lavender:
        return '💐';
      case ThemeVariant.peach:
        return '🍑';
      case ThemeVariant.mint:
        return '🌿';
      case ThemeVariant.coral:
        return '🪸';
      case ThemeVariant.chocolate:
        return '🍫';
    }
  }

  /// Получить список всех вариантов с названиями
  List<Map<String, dynamic>> getAllVariants() {
    return ThemeVariant.values.map((variant) {
      return {
        'variant': variant,
        'name': getVariantName(variant),
        'emoji': getVariantEmoji(variant),
      };
    }).toList();
  }
}

// ==================== IS DARK MODE PROVIDER ====================

/// Провайдер для проверки, используется ли темная тема
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  if (themeMode == ThemeMode.system) {
    // Если системный режим, проверяем яркость системы
    // В реальном приложении нужно получать через MediaQuery
    // Здесь просто возвращаем false как default
    return false;
  }

  return themeMode == ThemeMode.dark;
});

// ==================== FONT SCALE PROVIDER ====================

/// Провайдер масштаба шрифта
final fontScaleProvider =
    StateNotifierProvider<FontScaleNotifier, double>((ref) {
  return FontScaleNotifier();
});

class FontScaleNotifier extends StateNotifier<double> {
  FontScaleNotifier() : super(1.0);

  /// Увеличить шрифт
  void increaseScale() {
    if (state < 1.5) {
      state += 0.1;
    }
  }

  /// Уменьшить шрифт
  void decreaseScale() {
    if (state > 0.8) {
      state -= 0.1;
    }
  }

  /// Сбросить масштаб
  void resetScale() {
    state = 1.0;
  }

  /// Установить конкретное значение
  void setScale(double scale) {
    if (scale >= 0.8 && scale <= 1.5) {
      state = scale;
    }
  }
}

// ==================== ANIMATION SETTINGS PROVIDER ====================

/// Провайдер настроек анимации
final animationSettingsProvider =
    StateNotifierProvider<AnimationSettingsNotifier, AnimationSettings>((ref) {
  return AnimationSettingsNotifier();
});

class AnimationSettings {
  final bool enabled;
  final double speed; // 0.5 = медленно, 1.0 = нормально, 1.5 = быстро

  const AnimationSettings({
    this.enabled = true,
    this.speed = 1.0,
  });

  AnimationSettings copyWith({
    bool? enabled,
    double? speed,
  }) {
    return AnimationSettings(
      enabled: enabled ?? this.enabled,
      speed: speed ?? this.speed,
    );
  }
}

class AnimationSettingsNotifier extends StateNotifier<AnimationSettings> {
  AnimationSettingsNotifier() : super(const AnimationSettings());

  /// Включить/выключить анимации
  void toggleAnimations() {
    state = state.copyWith(enabled: !state.enabled);
  }

  /// Установить скорость анимации
  void setSpeed(double speed) {
    if (speed >= 0.5 && speed <= 1.5) {
      state = state.copyWith(speed: speed);
    }
  }

  /// Сбросить к значениям по умолчанию
  void reset() {
    state = const AnimationSettings();
  }
}

// ==================== COMPACT MODE PROVIDER ====================

/// Провайдер компактного режима (уменьшенные отступы и размеры)
final compactModeProvider =
    StateNotifierProvider<CompactModeNotifier, bool>((ref) {
  return CompactModeNotifier();
});

class CompactModeNotifier extends StateNotifier<bool> {
  CompactModeNotifier() : super(false);

  /// Переключить компактный режим
  void toggle() {
    state = !state;
  }

  /// Установить режим
  void setCompactMode(bool isCompact) {
    state = isCompact;
  }
}

// ==================== HELPER PROVIDERS ====================

/// Провайдер получения Duration для анимаций
final animationDurationProvider = Provider<Duration>((ref) {
  final settings = ref.watch(animationSettingsProvider);

  if (!settings.enabled) {
    return Duration.zero;
  }

  final baseMs = 300; // базовая длительность
  final adjustedMs = (baseMs / settings.speed).round();

  return Duration(milliseconds: adjustedMs);
});

/// Провайдер текущего названия темы
final currentThemeNameProvider = Provider<String>((ref) {
  final variant = ref.watch(themeVariantProvider);
  final notifier = ref.read(themeVariantProvider.notifier);
  return notifier.getVariantName(variant);
});

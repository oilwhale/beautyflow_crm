import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 4)
class SettingsModel extends HiveObject {
  @HiveField(0)
  String? masterName;

  @HiveField(1)
  String? masterPhone;

  @HiveField(2)
  String? masterEmail;

  @HiveField(3)
  String? workingHoursStart; // Формат: "09:00"

  @HiveField(4)
  String? workingHoursEnd; // Формат: "20:00"

  @HiveField(5)
  List<int>? weekendDays; // 0-6 (0 = Понедельник, 6 = Воскресенье)

  @HiveField(6)
  bool notificationsEnabled;

  @HiveField(7)
  bool notifyBeforeAppointment;

  @HiveField(8)
  int? notifyMinutesBefore; // За сколько минут напоминать

  @HiveField(9)
  String theme; // gentle, luxury, organic, dark, и т.д.

  @HiveField(10)
  bool darkMode;

  @HiveField(11)
  String? currency;

  @HiveField(12)
  DateTime? lastBackupDate;

  @HiveField(13)
  bool isPremium;

  SettingsModel({
    this.masterName,
    this.masterPhone,
    this.masterEmail,
    this.workingHoursStart = '09:00',
    this.workingHoursEnd = '20:00',
    this.weekendDays,
    this.notificationsEnabled = true,
    this.notifyBeforeAppointment = true,
    this.notifyMinutesBefore = 30,
    this.theme = 'gentle',
    this.darkMode = false,
    this.currency = '₽',
    this.lastBackupDate,
    this.isPremium = false,
  });

  // Создать настройки по умолчанию
  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      workingHoursStart: '09:00',
      workingHoursEnd: '20:00',
      weekendDays: [6], // Воскресенье
      notificationsEnabled: true,
      notifyBeforeAppointment: true,
      notifyMinutesBefore: 30,
      theme: 'gentle',
      darkMode: false,
      currency: '₽',
      isPremium: false,
    );
  }

  // Копирование с изменениями
  SettingsModel copyWith({
    String? masterName,
    String? masterPhone,
    String? masterEmail,
    String? workingHoursStart,
    String? workingHoursEnd,
    List<int>? weekendDays,
    bool? notificationsEnabled,
    bool? notifyBeforeAppointment,
    int? notifyMinutesBefore,
    String? theme,
    bool? darkMode,
    String? currency,
    DateTime? lastBackupDate,
    bool? isPremium,
  }) {
    return SettingsModel(
      masterName: masterName ?? this.masterName,
      masterPhone: masterPhone ?? this.masterPhone,
      masterEmail: masterEmail ?? this.masterEmail,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      weekendDays: weekendDays ?? this.weekendDays,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notifyBeforeAppointment:
          notifyBeforeAppointment ?? this.notifyBeforeAppointment,
      notifyMinutesBefore: notifyMinutesBefore ?? this.notifyMinutesBefore,
      theme: theme ?? this.theme,
      darkMode: darkMode ?? this.darkMode,
      currency: currency ?? this.currency,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // Проверить, рабочий ли день
  bool isWorkingDay(DateTime date) {
    if (weekendDays == null) return true;
    // DateTime.weekday: 1 = Monday, 7 = Sunday
    // Наш формат: 0 = Monday, 6 = Sunday
    final dayOfWeek = date.weekday - 1;
    return !weekendDays!.contains(dayOfWeek);
  }

  // Получить список выходных дней (названия)
  List<String> getWeekendDayNames() {
    if (weekendDays == null || weekendDays!.isEmpty) {
      return ['Нет'];
    }

    const dayNames = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];

    return weekendDays!.map((day) => dayNames[day]).toList();
  }

  @override
  String toString() {
    return 'SettingsModel(masterName: $masterName, theme: $theme, isPremium: $isPremium)';
  }
}

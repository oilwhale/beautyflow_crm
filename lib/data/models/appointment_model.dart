import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 2)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String clientId;

  @HiveField(2)
  late List<String> serviceIds; // Может быть несколько услуг

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String time; // Формат: "14:00"

  @HiveField(5)
  late int duration; // в минутах

  @HiveField(6)
  late double price;

  @HiveField(7)
  late String status; // confirmed, pending, cancelled, completed

  @HiveField(8)
  String? notes;

  @HiveField(9)
  List<String>? materialsUsed;

  @HiveField(10)
  List<String>? photoUrls;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? completedAt;

  AppointmentModel({
    required this.id,
    required this.clientId,
    required this.serviceIds,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
    this.status = 'pending',
    this.notes,
    this.materialsUsed,
    this.photoUrls,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Создать новую запись
  factory AppointmentModel.create({
    required String clientId,
    required List<String> serviceIds,
    required DateTime date,
    required String time,
    required int duration,
    required double price,
    String? notes,
  }) {
    return AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientId: clientId,
      serviceIds: serviceIds,
      date: date,
      time: time,
      duration: duration,
      price: price,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  // Копирование с изменениями
  AppointmentModel copyWith({
    String? id,
    String? clientId,
    List<String>? serviceIds,
    DateTime? date,
    String? time,
    int? duration,
    double? price,
    String? status,
    String? notes,
    List<String>? materialsUsed,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      serviceIds: serviceIds ?? this.serviceIds,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Получить DateTime с датой и временем
  DateTime getDateTime() {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  // Получить время окончания
  DateTime getEndTime() {
    return getDateTime().add(Duration(minutes: duration));
  }

  // Форматированная дата
  String getFormattedDate() {
    final months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  // Форматированное время
  String getFormattedTime() {
    final endTime = getEndTime();
    return '$time - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  // Форматированная длительность
  String getFormattedDuration() {
    if (duration < 60) {
      return '$duration мин';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '$hours ч';
    }
    return '$hours ч $minutes мин';
  }

  // Проверить, сегодня ли запись
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Проверить, в прошлом ли запись
  bool isPast() {
    return getDateTime().isBefore(DateTime.now());
  }

  // Проверить, в будущем ли запись
  bool isFuture() {
    return getDateTime().isAfter(DateTime.now());
  }

  // Проверить, можно ли редактировать
  bool canEdit() {
    return status != 'completed' && status != 'cancelled';
  }

  @override
  String toString() {
    return 'AppointmentModel(id: $id, clientId: $clientId, date: $date, time: $time, status: $status)';
  }
}

// Статусы записей
class AppointmentStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [
    pending,
    confirmed,
    completed,
    cancelled,
  ];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Ожидает';
      case confirmed:
        return 'Подтверждено';
      case completed:
        return 'Завершено';
      case cancelled:
        return 'Отменено';
      default:
        return status;
    }
  }
}

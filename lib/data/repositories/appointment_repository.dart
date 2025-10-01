import 'package:hive_flutter/hive_flutter.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  static const String _boxName = 'appointments';

  // Получить Box
  Box<AppointmentModel> get _box => Hive.box<AppointmentModel>(_boxName);

  // ==================== CREATE ====================

  /// Создать новую запись
  Future<AppointmentModel> createAppointment(
      AppointmentModel appointment) async {
    await _box.put(appointment.id, appointment);
    return appointment;
  }

  // ==================== READ ====================

  /// Получить все записи
  List<AppointmentModel> getAllAppointments() {
    return _box.values.toList();
  }

  /// Получить запись по ID
  AppointmentModel? getAppointmentById(String id) {
    return _box.get(id);
  }

  /// Получить записи клиента
  List<AppointmentModel> getAppointmentsByClientId(String clientId) {
    return _box.values
        .where((appointment) => appointment.clientId == clientId)
        .toList();
  }

  /// Получить записи на конкретную дату
  List<AppointmentModel> getAppointmentsByDate(DateTime date) {
    return _box.values.where((appointment) {
      return appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day;
    }).toList();
  }

  /// Получить записи за период
  List<AppointmentModel> getAppointmentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _box.values.where((appointment) {
      return appointment.date
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          appointment.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Получить записи на текущую неделю
  List<AppointmentModel> getAppointmentsThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getAppointmentsByDateRange(
      startDate: startOfWeek,
      endDate: endOfWeek,
    );
  }

  /// Получить записи на текущий месяц
  List<AppointmentModel> getAppointmentsThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getAppointmentsByDateRange(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  /// Получить записи по статусу
  List<AppointmentModel> getAppointmentsByStatus(String status) {
    return _box.values
        .where((appointment) => appointment.status == status)
        .toList();
  }

  /// Получить предстоящие записи
  List<AppointmentModel> getUpcomingAppointments() {
    final now = DateTime.now();
    return _box.values.where((appointment) {
      final appointmentDateTime = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
        int.parse(appointment.time.split(':')[0]),
        int.parse(appointment.time.split(':')[1]),
      );

      return appointmentDateTime.isAfter(now) &&
          (appointment.status == 'pending' ||
              appointment.status == 'confirmed');
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Получить прошедшие записи
  List<AppointmentModel> getPastAppointments() {
    final now = DateTime.now();
    return _box.values.where((appointment) {
      final appointmentDateTime = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
        int.parse(appointment.time.split(':')[0]),
        int.parse(appointment.time.split(':')[1]),
      );

      return appointmentDateTime.isBefore(now);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Получить записи на сегодня
  List<AppointmentModel> getTodayAppointments() {
    return getAppointmentsByDate(DateTime.now());
  }

  /// Получить записи на завтра
  List<AppointmentModel> getTomorrowAppointments() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return getAppointmentsByDate(tomorrow);
  }

  /// Получить завершенные записи
  List<AppointmentModel> getCompletedAppointments() {
    return getAppointmentsByStatus('completed');
  }

  /// Получить отмененные записи
  List<AppointmentModel> getCancelledAppointments() {
    return getAppointmentsByStatus('cancelled');
  }

  /// Проверить, свободно ли время
  bool isTimeSlotAvailable({
    required DateTime date,
    required String time,
    required int duration,
    String? excludeAppointmentId,
  }) {
    final appointments = getAppointmentsByDate(date);

    final requestedStart = _parseTime(time);
    final requestedEnd = requestedStart.add(Duration(minutes: duration));

    for (final appointment in appointments) {
      // Пропускаем текущую запись (для редактирования)
      if (appointment.id == excludeAppointmentId) continue;

      // Пропускаем отмененные
      if (appointment.status == 'cancelled') continue;

      final existingStart = _parseTime(appointment.time);
      final existingEnd =
          existingStart.add(Duration(minutes: appointment.duration));

      // Проверка на пересечение
      if (requestedStart.isBefore(existingEnd) &&
          requestedEnd.isAfter(existingStart)) {
        return false;
      }
    }

    return true;
  }

  /// Получить доступные слоты на день
  List<String> getAvailableTimeSlots({
    required DateTime date,
    required int duration,
    required String workStartTime, // "09:00"
    required String workEndTime, // "18:00"
    int slotInterval = 30, // интервал между слотами в минутах
  }) {
    final availableSlots = <String>[];

    final workStart = _parseTime(workStartTime);
    final workEnd = _parseTime(workEndTime);

    var currentTime = workStart;

    while (currentTime.add(Duration(minutes: duration)).isBefore(workEnd) ||
        currentTime.add(Duration(minutes: duration)) == workEnd) {
      final timeStr = _formatTime(currentTime);

      if (isTimeSlotAvailable(date: date, time: timeStr, duration: duration)) {
        availableSlots.add(timeStr);
      }

      currentTime = currentTime.add(Duration(minutes: slotInterval));
    }

    return availableSlots;
  }

  /// Поиск записей
  List<AppointmentModel> searchAppointments(String query) {
    if (query.isEmpty) return getAllAppointments();

    final lowerQuery = query.toLowerCase();
    return _box.values.where((appointment) {
      return appointment.notes?.toLowerCase().contains(lowerQuery) ?? false;
    }).toList();
  }

  // ==================== UPDATE ====================

  /// Обновить запись
  Future<AppointmentModel> updateAppointment(
      AppointmentModel appointment) async {
    await _box.put(appointment.id, appointment);
    return appointment;
  }

  /// Изменить статус записи
  Future<AppointmentModel> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    final appointment = getAppointmentById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found');
    }

    final updatedAppointment = appointment.copyWith(
      status: status,
      completedAt: status == 'completed' ? DateTime.now() : null,
    );

    await _box.put(appointmentId, updatedAppointment);
    return updatedAppointment;
  }

  /// Подтвердить запись
  Future<AppointmentModel> confirmAppointment(String appointmentId) async {
    return updateAppointmentStatus(
      appointmentId: appointmentId,
      status: 'confirmed',
    );
  }

  /// Отменить запись
  Future<AppointmentModel> cancelAppointment(String appointmentId) async {
    return updateAppointmentStatus(
      appointmentId: appointmentId,
      status: 'cancelled',
    );
  }

  /// Завершить запись
  Future<AppointmentModel> completeAppointment(String appointmentId) async {
    return updateAppointmentStatus(
      appointmentId: appointmentId,
      status: 'completed',
    );
  }

  /// Перенести запись
  Future<AppointmentModel> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTime,
  }) async {
    final appointment = getAppointmentById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found');
    }

    final updatedAppointment = appointment.copyWith(
      date: newDate,
      time: newTime,
    );

    await _box.put(appointmentId, updatedAppointment);
    return updatedAppointment;
  }

  /// Добавить фото к записи
  Future<AppointmentModel> addPhotoToAppointment(
    String appointmentId,
    String photoUrl,
  ) async {
    final appointment = getAppointmentById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found');
    }

    final photos = List<String>.from(appointment.photoUrls ?? []);
    photos.add(photoUrl);

    final updatedAppointment = appointment.copyWith(photoUrls: photos);
    await _box.put(appointmentId, updatedAppointment);
    return updatedAppointment;
  }

  /// Удалить фото из записи
  Future<AppointmentModel> removePhotoFromAppointment(
    String appointmentId,
    String photoUrl,
  ) async {
    final appointment = getAppointmentById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found');
    }

    final photos = List<String>.from(appointment.photoUrls ?? []);
    photos.remove(photoUrl);

    final updatedAppointment = appointment.copyWith(photoUrls: photos);
    await _box.put(appointmentId, updatedAppointment);
    return updatedAppointment;
  }

  // ==================== DELETE ====================

  /// Удалить запись
  Future<void> deleteAppointment(String id) async {
    await _box.delete(id);
  }

  /// Удалить старые завершенные записи
  Future<void> deleteOldCompletedAppointments({int daysOld = 365}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

    final oldAppointments = _box.values
        .where((appointment) {
          return appointment.status == 'completed' &&
              appointment.completedAt != null &&
              appointment.completedAt!.isBefore(cutoffDate);
        })
        .map((a) => a.id)
        .toList();

    await _box.deleteAll(oldAppointments);
  }

  /// Удалить все записи (осторожно!)
  Future<void> deleteAllAppointments() async {
    await _box.clear();
  }

  // ==================== STATISTICS ====================

  /// Получить общее количество записей
  int getAppointmentsCount() {
    return _box.length;
  }

  /// Получить количество записей по статусу
  int getAppointmentsCountByStatus(String status) {
    return _box.values.where((a) => a.status == status).length;
  }

  /// Получить общий доход за период
  double getRevenueByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final appointments = getAppointmentsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    return appointments
        .where((a) => a.status == 'completed')
        .fold(0.0, (sum, appointment) => sum + appointment.price);
  }

  /// Получить доход за сегодня
  double getTodayRevenue() {
    final today = DateTime.now();
    return getRevenueByDateRange(startDate: today, endDate: today);
  }

  /// Получить доход за неделю
  double getWeekRevenue() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getRevenueByDateRange(startDate: startOfWeek, endDate: endOfWeek);
  }

  /// Получить доход за месяц
  double getMonthRevenue() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getRevenueByDateRange(startDate: startOfMonth, endDate: endOfMonth);
  }

  /// Получить средний чек
  double getAverageAppointmentPrice() {
    final completed = getCompletedAppointments();
    if (completed.isEmpty) return 0.0;

    final totalRevenue = completed.fold(0.0, (sum, a) => sum + a.price);
    return totalRevenue / completed.length;
  }

  /// Получить статистику по дням недели
  Map<int, int> getAppointmentsByWeekday() {
    final Map<int, int> weekdayStats = {};

    for (final appointment in _box.values) {
      final weekday = appointment.date.weekday;
      weekdayStats[weekday] = (weekdayStats[weekday] ?? 0) + 1;
    }

    return weekdayStats;
  }

  /// Получить самые популярные часы
  Map<int, int> getAppointmentsByHour() {
    final Map<int, int> hourStats = {};

    for (final appointment in _box.values) {
      final hour = int.parse(appointment.time.split(':')[0]);
      hourStats[hour] = (hourStats[hour] ?? 0) + 1;
    }

    return hourStats;
  }

  // ==================== STREAM ====================

  /// Stream для прослушивания изменений в записях
  Stream<List<AppointmentModel>> watchAllAppointments() {
    return _box.watch().map((_) => getAllAppointments());
  }

  /// Stream для прослушивания изменений конкретной записи
  Stream<AppointmentModel?> watchAppointment(String appointmentId) {
    return _box
        .watch(key: appointmentId)
        .map((_) => getAppointmentById(appointmentId));
  }

  /// Stream для записей на сегодня
  Stream<List<AppointmentModel>> watchTodayAppointments() {
    return _box.watch().map((_) => getTodayAppointments());
  }

  /// Stream для предстоящих записей
  Stream<List<AppointmentModel>> watchUpcomingAppointments() {
    return _box.watch().map((_) => getUpcomingAppointments());
  }

  // ==================== HELPER METHODS ====================

  /// Парсинг времени из строки в DateTime
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Форматирование DateTime в строку времени
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

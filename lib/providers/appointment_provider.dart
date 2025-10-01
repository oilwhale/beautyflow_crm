import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/appointment_model.dart';
import '../data/repositories/appointment_repository.dart';

// ==================== REPOSITORY PROVIDER ====================

/// Провайдер репозитория записей
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository();
});

// ==================== STATE PROVIDERS ====================

/// Провайдер списка всех записей
final allAppointmentsProvider = StreamProvider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.watchAllAppointments();
});

/// Провайдер конкретной записи по ID
final appointmentByIdProvider =
    StreamProvider.family<AppointmentModel?, String>(
  (ref, appointmentId) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.watchAppointment(appointmentId);
  },
);

/// Провайдер записей на сегодня
final todayAppointmentsProvider = StreamProvider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.watchTodayAppointments();
});

/// Провайдер предстоящих записей
final upcomingAppointmentsProvider =
    StreamProvider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.watchUpcomingAppointments();
});

/// Провайдер записей на завтра
final tomorrowAppointmentsProvider = Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getTomorrowAppointments();
});

/// Провайдер записей клиента
final clientAppointmentsProvider =
    Provider.family<List<AppointmentModel>, String>(
  (ref, clientId) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getAppointmentsByClientId(clientId);
  },
);

/// Провайдер записей по статусу
final appointmentsByStatusProvider =
    Provider.family<List<AppointmentModel>, String>(
  (ref, status) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getAppointmentsByStatus(status);
  },
);

/// Провайдер завершенных записей
final completedAppointmentsProvider = Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getCompletedAppointments();
});

/// Провайдер отмененных записей
final cancelledAppointmentsProvider = Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getCancelledAppointments();
});

// ==================== CALENDAR PROVIDERS ====================

/// Провайдер выбранной даты в календаре
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Провайдер записей на выбранную дату
final appointmentsBySelectedDateProvider =
    Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return repository.getAppointmentsByDate(selectedDate);
});

/// Провайдер записей на текущую неделю
final weekAppointmentsProvider = Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsThisWeek();
});

/// Провайдер записей на текущий месяц
final monthAppointmentsProvider = Provider<List<AppointmentModel>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsThisMonth();
});

/// Провайдер записей за период
final appointmentsByDateRangeProvider = Provider.family<List<AppointmentModel>,
    ({DateTime startDate, DateTime endDate})>(
  (ref, params) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getAppointmentsByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  },
);

// ==================== AVAILABILITY PROVIDERS ====================

/// Проверка доступности времени
final timeSlotAvailableProvider = Provider.family<bool,
    ({DateTime date, String time, int duration, String? excludeId})>(
  (ref, params) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.isTimeSlotAvailable(
      date: params.date,
      time: params.time,
      duration: params.duration,
      excludeAppointmentId: params.excludeId,
    );
  },
);

/// Получить доступные слоты
final availableTimeSlotsProvider = Provider.family<
    List<String>,
    ({
      DateTime date,
      int duration,
      String workStartTime,
      String workEndTime,
      int slotInterval,
    })>(
  (ref, params) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getAvailableTimeSlots(
      date: params.date,
      duration: params.duration,
      workStartTime: params.workStartTime,
      workEndTime: params.workEndTime,
      slotInterval: params.slotInterval,
    );
  },
);

// ==================== STATISTICS PROVIDERS ====================

/// Провайдер количества записей
final appointmentsCountProvider = Provider<int>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsCount();
});

/// Провайдер количества записей по статусу
final appointmentsCountByStatusProvider = Provider.family<int, String>(
  (ref, status) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getAppointmentsCountByStatus(status);
  },
);

/// Провайдер дохода за сегодня
final todayRevenueProvider = Provider<double>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getTodayRevenue();
});

/// Провайдер дохода за неделю
final weekRevenueProvider = Provider<double>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getWeekRevenue();
});

/// Провайдер дохода за месяц
final monthRevenueProvider = Provider<double>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getMonthRevenue();
});

/// Провайдер дохода за период
final revenueByDateRangeProvider =
    Provider.family<double, ({DateTime startDate, DateTime endDate})>(
  (ref, params) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return repository.getRevenueByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  },
);

/// Провайдер среднего чека
final averageAppointmentPriceProvider = Provider<double>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAverageAppointmentPrice();
});

/// Провайдер статистики по дням недели
final appointmentsByWeekdayProvider = Provider<Map<int, int>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsByWeekday();
});

/// Провайдер статистики по часам
final appointmentsByHourProvider = Provider<Map<int, int>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsByHour();
});

// ==================== NOTIFIER FOR CRUD OPERATIONS ====================

/// Notifier для управления записями
class AppointmentNotifier extends StateNotifier<AsyncValue<void>> {
  AppointmentNotifier(this.repository) : super(const AsyncValue.data(null));

  final AppointmentRepository repository;

  /// Создать запись
  Future<void> createAppointment(AppointmentModel appointment) async {
    state = const AsyncValue.loading();
    try {
      await repository.createAppointment(appointment);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить запись
  Future<void> updateAppointment(AppointmentModel appointment) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateAppointment(appointment);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить запись
  Future<void> deleteAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteAppointment(appointmentId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Изменить статус записи
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Подтвердить запись
  Future<void> confirmAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await repository.confirmAppointment(appointmentId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Отменить запись
  Future<void> cancelAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await repository.cancelAppointment(appointmentId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Завершить запись
  Future<void> completeAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await repository.completeAppointment(appointmentId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Перенести запись
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.rescheduleAppointment(
        appointmentId: appointmentId,
        newDate: newDate,
        newTime: newTime,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Добавить фото
  Future<void> addPhoto(String appointmentId, String photoUrl) async {
    state = const AsyncValue.loading();
    try {
      await repository.addPhotoToAppointment(appointmentId, photoUrl);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить фото
  Future<void> removePhoto(String appointmentId, String photoUrl) async {
    state = const AsyncValue.loading();
    try {
      await repository.removePhotoFromAppointment(appointmentId, photoUrl);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Провайдер AppointmentNotifier
final appointmentNotifierProvider =
    StateNotifierProvider<AppointmentNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentNotifier(repository);
});

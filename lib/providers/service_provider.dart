import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/service_model.dart';
import '../data/repositories/service_repository.dart';

// ==================== REPOSITORY PROVIDER ====================

/// Провайдер репозитория услуг
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

// ==================== STATE PROVIDERS ====================

/// Провайдер списка всех услуг
final allServicesProvider = StreamProvider<List<ServiceModel>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.watchAllServices();
});

/// Провайдер только активных услуг
final activeServicesProvider = StreamProvider<List<ServiceModel>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.watchActiveServices();
});

/// Провайдер конкретной услуги по ID
final serviceByIdProvider =
    StreamProvider.family<ServiceModel?, String>((ref, serviceId) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.watchService(serviceId);
});

/// Провайдер услуг по категории
final servicesByCategoryProvider = Provider.family<List<ServiceModel>, String>(
  (ref, category) {
    final repository = ref.watch(serviceRepositoryProvider);
    return repository.getServicesByCategory(category);
  },
);

/// Провайдер топ услуг по выполнениям
final topServicesByPerformanceProvider =
    Provider.family<List<ServiceModel>, int>(
  (ref, limit) {
    final repository = ref.watch(serviceRepositoryProvider);
    return repository.getTopServicesByPerformance(limit: limit);
  },
);

/// Провайдер топ услуг по доходу
final topServicesByRevenueProvider = Provider.family<List<ServiceModel>, int>(
  (ref, limit) {
    final repository = ref.watch(serviceRepositoryProvider);
    return repository.getTopServicesByRevenue(limit: limit);
  },
);

// ==================== SEARCH PROVIDER ====================

/// Провайдер поиска услуг
final serviceSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedServicesProvider = Provider<List<ServiceModel>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  final query = ref.watch(serviceSearchQueryProvider);

  if (query.isEmpty) {
    return repository.getActiveServices();
  }

  return repository.searchServices(query);
});

// ==================== FILTER PROVIDERS ====================

/// Провайдер выбранной категории для фильтрации
final selectedServiceCategoryProvider = StateProvider<String?>((ref) => null);

/// Провайдер отфильтрованных услуг
final filteredServicesProvider = Provider<List<ServiceModel>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  final selectedCategory = ref.watch(selectedServiceCategoryProvider);

  if (selectedCategory == null) {
    return repository.getActiveServices();
  }

  return repository.getServicesByCategory(selectedCategory);
});

// ==================== STATISTICS PROVIDERS ====================

/// Провайдер количества услуг
final servicesCountProvider = Provider<int>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServicesCount();
});

/// Провайдер количества активных услуг
final activeServicesCountProvider = Provider<int>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getActiveServicesCount();
});

/// Провайдер общего дохода от услуг
final servicesTotalRevenueProvider = Provider<double>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getTotalRevenue();
});

/// Провайдер средней цены услуги
final servicesAveragePriceProvider = Provider<double>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getAveragePrice();
});

/// Провайдер средней длительности услуги
final servicesAverageDurationProvider = Provider<double>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getAverageDuration();
});

/// Провайдер всех категорий услуг
final allServiceCategoriesProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getAllCategories();
});

/// Провайдер всех тегов услуг
final allServiceTagsProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getAllTags();
});

/// Провайдер количества услуг по категориям
final serviceCountByCategoryProvider = Provider<Map<String, int>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServiceCountByCategory();
});

/// Провайдер дохода по категориям
final revenueByCategoryProvider = Provider<Map<String, double>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getRevenueByCategory();
});

// ==================== NOTIFIER FOR CRUD OPERATIONS ====================

/// Notifier для управления услугами
class ServiceNotifier extends StateNotifier<AsyncValue<void>> {
  ServiceNotifier(this.repository) : super(const AsyncValue.data(null));

  final ServiceRepository repository;

  /// Создать услугу
  Future<void> createService(ServiceModel service) async {
    state = const AsyncValue.loading();
    try {
      await repository.createService(service);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Создать несколько услуг
  Future<void> createServices(List<ServiceModel> services) async {
    state = const AsyncValue.loading();
    try {
      await repository.createServices(services);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить услугу
  Future<void> updateService(ServiceModel service) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateService(service);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить услугу
  Future<void> deleteService(String serviceId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteService(serviceId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить статистику услуги
  Future<void> updateServiceStats({
    required String serviceId,
    required double price,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateServiceStats(
        serviceId: serviceId,
        price: price,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Переключить активность услуги
  Future<void> toggleServiceActive(String serviceId) async {
    state = const AsyncValue.loading();
    try {
      await repository.toggleServiceActive(serviceId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить цену услуги
  Future<void> updateServicePrice(String serviceId, double newPrice) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateServicePrice(serviceId, newPrice);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить длительность услуги
  Future<void> updateServiceDuration(String serviceId, int newDuration) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateServiceDuration(serviceId, newDuration);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Добавить тег
  Future<void> addTag(String serviceId, String tag) async {
    state = const AsyncValue.loading();
    try {
      await repository.addTag(serviceId, tag);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить тег
  Future<void> removeTag(String serviceId, String tag) async {
    state = const AsyncValue.loading();
    try {
      await repository.removeTag(serviceId, tag);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Провайдер ServiceNotifier
final serviceNotifierProvider =
    StateNotifierProvider<ServiceNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return ServiceNotifier(repository);
});

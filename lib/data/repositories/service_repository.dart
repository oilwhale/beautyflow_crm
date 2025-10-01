import 'package:hive_flutter/hive_flutter.dart';
import '../models/service_model.dart';

class ServiceRepository {
  static const String _boxName = 'services';

  // Получить Box
  Box<ServiceModel> get _box => Hive.box<ServiceModel>(_boxName);

  // ==================== CREATE ====================

  /// Создать новую услугу
  Future<ServiceModel> createService(ServiceModel service) async {
    await _box.put(service.id, service);
    return service;
  }

  /// Создать несколько услуг (массовое добавление)
  Future<void> createServices(List<ServiceModel> services) async {
    final Map<String, ServiceModel> servicesMap = {
      for (var service in services) service.id: service
    };
    await _box.putAll(servicesMap);
  }

  // ==================== READ ====================

  /// Получить все услуги
  List<ServiceModel> getAllServices() {
    return _box.values.toList();
  }

  /// Получить только активные услуги
  List<ServiceModel> getActiveServices() {
    return _box.values.where((service) => service.isActive).toList();
  }

  /// Получить услугу по ID
  ServiceModel? getServiceById(String id) {
    return _box.get(id);
  }

  /// Получить несколько услуг по списку ID
  List<ServiceModel> getServicesByIds(List<String> ids) {
    return ids
        .map((id) => _box.get(id))
        .where((service) => service != null)
        .cast<ServiceModel>()
        .toList();
  }

  /// Поиск услуг по названию
  List<ServiceModel> searchServices(String query) {
    if (query.isEmpty) return getAllServices();

    final lowerQuery = query.toLowerCase();
    return _box.values.where((service) {
      return service.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Получить услуги по категории
  List<ServiceModel> getServicesByCategory(String category) {
    return _box.values
        .where((service) => service.category == category)
        .toList();
  }

  /// Получить услуги по тегу
  List<ServiceModel> getServicesByTag(String tag) {
    return _box.values.where((service) {
      return service.tags?.contains(tag) ?? false;
    }).toList();
  }

  /// Получить топ услуг по количеству выполнений
  List<ServiceModel> getTopServicesByPerformance({int limit = 10}) {
    final services = getAllServices();
    services.sort((a, b) => b.timesPerformed.compareTo(a.timesPerformed));
    return services.take(limit).toList();
  }

  /// Получить топ услуг по доходу
  List<ServiceModel> getTopServicesByRevenue({int limit = 10}) {
    final services = getAllServices();
    services.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    return services.take(limit).toList();
  }

  /// Получить услуги в ценовом диапазоне
  List<ServiceModel> getServicesByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) {
    return _box.values.where((service) {
      return service.price >= minPrice && service.price <= maxPrice;
    }).toList();
  }

  /// Получить услуги по длительности
  List<ServiceModel> getServicesByDuration({
    required int minDuration,
    required int maxDuration,
  }) {
    return _box.values.where((service) {
      return service.duration >= minDuration && service.duration <= maxDuration;
    }).toList();
  }

  /// Получить услуги, отсортированные по цене
  List<ServiceModel> getServicesSortedByPrice({bool ascending = true}) {
    final services = getAllServices();
    services.sort((a, b) {
      return ascending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price);
    });
    return services;
  }

  /// Получить услуги, отсортированные по длительности
  List<ServiceModel> getServicesSortedByDuration({bool ascending = true}) {
    final services = getAllServices();
    services.sort((a, b) {
      return ascending
          ? a.duration.compareTo(b.duration)
          : b.duration.compareTo(a.duration);
    });
    return services;
  }

  // ==================== UPDATE ====================

  /// Обновить услугу
  Future<ServiceModel> updateService(ServiceModel service) async {
    await _box.put(service.id, service);
    return service;
  }

  /// Обновить статистику услуги после выполнения
  Future<ServiceModel> updateServiceStats({
    required String serviceId,
    required double price,
  }) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final updatedService = service.copyWith(
      timesPerformed: service.timesPerformed + 1,
      totalRevenue: service.totalRevenue + price,
    );

    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  /// Переключить активность услуги
  Future<ServiceModel> toggleServiceActive(String serviceId) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final updatedService = service.copyWith(isActive: !service.isActive);
    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  /// Обновить цену услуги
  Future<ServiceModel> updateServicePrice(
      String serviceId, double newPrice) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final updatedService = service.copyWith(price: newPrice);
    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  /// Обновить длительность услуги
  Future<ServiceModel> updateServiceDuration(
      String serviceId, int newDuration) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final updatedService = service.copyWith(duration: newDuration);
    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  /// Добавить тег к услуге
  Future<ServiceModel> addTag(String serviceId, String tag) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final tags = List<String>.from(service.tags ?? []);
    if (!tags.contains(tag)) {
      tags.add(tag);
    }

    final updatedService = service.copyWith(tags: tags);
    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  /// Удалить тег из услуги
  Future<ServiceModel> removeTag(String serviceId, String tag) async {
    final service = getServiceById(serviceId);
    if (service == null) {
      throw Exception('Service not found');
    }

    final tags = List<String>.from(service.tags ?? []);
    tags.remove(tag);

    final updatedService = service.copyWith(tags: tags);
    await _box.put(serviceId, updatedService);
    return updatedService;
  }

  // ==================== DELETE ====================

  /// Удалить услугу
  Future<void> deleteService(String id) async {
    await _box.delete(id);
  }

  /// Удалить все неактивные услуги
  Future<void> deleteInactiveServices() async {
    final inactiveIds = _box.values
        .where((service) => !service.isActive)
        .map((service) => service.id)
        .toList();

    await _box.deleteAll(inactiveIds);
  }

  /// Удалить все услуги (осторожно!)
  Future<void> deleteAllServices() async {
    await _box.clear();
  }

  // ==================== STATISTICS ====================

  /// Получить общее количество услуг
  int getServicesCount() {
    return _box.length;
  }

  /// Получить количество активных услуг
  int getActiveServicesCount() {
    return _box.values.where((service) => service.isActive).length;
  }

  /// Получить общий доход от всех услуг
  double getTotalRevenue() {
    return _box.values.fold(0.0, (sum, service) => sum + service.totalRevenue);
  }

  /// Получить среднюю цену услуги
  double getAveragePrice() {
    if (_box.isEmpty) return 0.0;

    final totalPrice =
        _box.values.fold(0.0, (sum, service) => sum + service.price);
    return totalPrice / _box.length;
  }

  /// Получить среднюю длительность услуги
  double getAverageDuration() {
    if (_box.isEmpty) return 0.0;

    final totalDuration =
        _box.values.fold(0, (sum, service) => sum + service.duration);
    return totalDuration / _box.length;
  }

  /// Получить общее количество выполнений всех услуг
  int getTotalPerformances() {
    return _box.values.fold(0, (sum, service) => sum + service.timesPerformed);
  }

  /// Получить все уникальные категории
  List<String> getAllCategories() {
    final categoriesSet = <String>{};
    for (final service in _box.values) {
      categoriesSet.add(service.category);
    }
    return categoriesSet.toList()..sort();
  }

  /// Получить все уникальные теги
  List<String> getAllTags() {
    final tagsSet = <String>{};
    for (final service in _box.values) {
      if (service.tags != null) {
        tagsSet.addAll(service.tags!);
      }
    }
    return tagsSet.toList()..sort();
  }

  /// Получить количество услуг по категориям
  Map<String, int> getServiceCountByCategory() {
    final Map<String, int> categoryCount = {};

    for (final service in _box.values) {
      categoryCount[service.category] =
          (categoryCount[service.category] ?? 0) + 1;
    }

    return categoryCount;
  }

  /// Получить доход по категориям
  Map<String, double> getRevenueByCategory() {
    final Map<String, double> categoryRevenue = {};

    for (final service in _box.values) {
      categoryRevenue[service.category] =
          (categoryRevenue[service.category] ?? 0.0) + service.totalRevenue;
    }

    return categoryRevenue;
  }

  // ==================== STREAM ====================

  /// Stream для прослушивания изменений в базе услуг
  Stream<List<ServiceModel>> watchAllServices() {
    return _box.watch().map((_) => getAllServices());
  }

  /// Stream для прослушивания изменений конкретной услуги
  Stream<ServiceModel?> watchService(String serviceId) {
    return _box.watch(key: serviceId).map((_) => getServiceById(serviceId));
  }

  /// Stream для прослушивания только активных услуг
  Stream<List<ServiceModel>> watchActiveServices() {
    return _box.watch().map((_) => getActiveServices());
  }
}

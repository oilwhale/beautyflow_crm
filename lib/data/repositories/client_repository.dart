import 'package:hive_flutter/hive_flutter.dart';
import '../models/client_model.dart';

class ClientRepository {
  static const String _boxName = 'clients';

  // Получить Box
  Box<ClientModel> get _box => Hive.box<ClientModel>(_boxName);

  // ==================== CREATE ====================

  /// Создать нового клиента
  Future<ClientModel> createClient(ClientModel client) async {
    await _box.put(client.id, client);
    return client;
  }

  // ==================== READ ====================

  /// Получить всех клиентов
  List<ClientModel> getAllClients() {
    return _box.values.toList();
  }

  /// Получить клиента по ID
  ClientModel? getClientById(String id) {
    return _box.get(id);
  }

  /// Поиск клиентов по имени или телефону
  List<ClientModel> searchClients(String query) {
    if (query.isEmpty) return getAllClients();

    final lowerQuery = query.toLowerCase();
    return _box.values.where((client) {
      final nameMatch = client.name.toLowerCase().contains(lowerQuery);
      final phoneMatch =
          client.phone?.toLowerCase().contains(lowerQuery) ?? false;
      return nameMatch || phoneMatch;
    }).toList();
  }

  /// Получить VIP клиентов
  List<ClientModel> getVipClients() {
    return _box.values.where((client) => client.isVip).toList();
  }

  /// Получить клиентов с днем рождения в текущем месяце
  List<ClientModel> getClientsWithBirthdayThisMonth() {
    final now = DateTime.now();
    return _box.values.where((client) {
      if (client.birthday == null) return false;
      return client.birthday!.month == now.month;
    }).toList();
  }

  /// Получить топ клиентов по количеству визитов
  List<ClientModel> getTopClientsByVisits({int limit = 10}) {
    final clients = getAllClients();
    clients.sort((a, b) => b.totalVisits.compareTo(a.totalVisits));
    return clients.take(limit).toList();
  }

  /// Получить топ клиентов по доходу
  List<ClientModel> getTopClientsByRevenue({int limit = 10}) {
    final clients = getAllClients();
    clients.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    return clients.take(limit).toList();
  }

  /// Получить клиентов по тегу
  List<ClientModel> getClientsByTag(String tag) {
    return _box.values.where((client) {
      return client.tags?.contains(tag) ?? false;
    }).toList();
  }

  /// Получить всех клиентов, отсортированных по дате создания
  List<ClientModel> getClientsSortedByDate({bool ascending = false}) {
    final clients = getAllClients();
    clients.sort((a, b) {
      return ascending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt);
    });
    return clients;
  }

  // ==================== UPDATE ====================

  /// Обновить клиента
  Future<ClientModel> updateClient(ClientModel client) async {
    await _box.put(client.id, client);
    return client;
  }

  /// Обновить статистику клиента после записи
  Future<ClientModel> updateClientStats({
    required String clientId,
    required double appointmentPrice,
    DateTime? visitDate,
  }) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final updatedClient = client.copyWith(
      totalVisits: client.totalVisits + 1,
      totalRevenue: client.totalRevenue + appointmentPrice,
      lastVisitDate: visitDate ?? DateTime.now(),
    );

    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  /// Добавить фото к клиенту
  Future<ClientModel> addPhotoToClient(String clientId, String photoUrl) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final photos = List<String>.from(client.photoUrls ?? []);
    photos.add(photoUrl);

    final updatedClient = client.copyWith(photoUrls: photos);
    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  /// Удалить фото клиента
  Future<ClientModel> removePhotoFromClient(
      String clientId, String photoUrl) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final photos = List<String>.from(client.photoUrls ?? []);
    photos.remove(photoUrl);

    final updatedClient = client.copyWith(photoUrls: photos);
    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  /// Переключить VIP статус
  Future<ClientModel> toggleVipStatus(String clientId) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final updatedClient = client.copyWith(isVip: !client.isVip);
    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  /// Добавить тег
  Future<ClientModel> addTag(String clientId, String tag) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final tags = List<String>.from(client.tags ?? []);
    if (!tags.contains(tag)) {
      tags.add(tag);
    }

    final updatedClient = client.copyWith(tags: tags);
    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  /// Удалить тег
  Future<ClientModel> removeTag(String clientId, String tag) async {
    final client = getClientById(clientId);
    if (client == null) {
      throw Exception('Client not found');
    }

    final tags = List<String>.from(client.tags ?? []);
    tags.remove(tag);

    final updatedClient = client.copyWith(tags: tags);
    await _box.put(clientId, updatedClient);
    return updatedClient;
  }

  // ==================== DELETE ====================

  /// Удалить клиента
  Future<void> deleteClient(String id) async {
    await _box.delete(id);
  }

  /// Удалить всех клиентов (осторожно!)
  Future<void> deleteAllClients() async {
    await _box.clear();
  }

  // ==================== STATISTICS ====================

  /// Получить общее количество клиентов
  int getClientsCount() {
    return _box.length;
  }

  /// Получить количество VIP клиентов
  int getVipClientsCount() {
    return _box.values.where((client) => client.isVip).length;
  }

  /// Получить общий доход от всех клиентов
  double getTotalRevenue() {
    return _box.values.fold(0.0, (sum, client) => sum + client.totalRevenue);
  }

  /// Получить среднюю оценку всех клиентов
  double getAverageRating() {
    final clients = _box.values.where((c) => c.rating > 0).toList();
    if (clients.isEmpty) return 0.0;

    final totalRating = clients.fold(0.0, (sum, client) => sum + client.rating);
    return totalRating / clients.length;
  }

  /// Получить все уникальные теги
  List<String> getAllTags() {
    final tagsSet = <String>{};
    for (final client in _box.values) {
      if (client.tags != null) {
        tagsSet.addAll(client.tags!);
      }
    }
    return tagsSet.toList()..sort();
  }

  // ==================== STREAM ====================

  /// Stream для прослушивания изменений в базе клиентов
  Stream<List<ClientModel>> watchAllClients() {
    return _box.watch().map((_) => getAllClients());
  }

  /// Stream для прослушивания изменений конкретного клиента
  Stream<ClientModel?> watchClient(String clientId) {
    return _box.watch(key: clientId).map((_) => getClientById(clientId));
  }
}

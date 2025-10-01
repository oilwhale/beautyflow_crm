import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/client_model.dart';
import '../data/repositories/client_repository.dart';

// ==================== REPOSITORY PROVIDER ====================

/// Провайдер репозитория клиентов
final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository();
});

// ==================== STATE PROVIDERS ====================

/// Провайдер списка всех клиентов
final allClientsProvider = StreamProvider<List<ClientModel>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.watchAllClients();
});

/// Провайдер конкретного клиента по ID
final clientByIdProvider =
    StreamProvider.family<ClientModel?, String>((ref, clientId) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.watchClient(clientId);
});

/// Провайдер VIP клиентов
final vipClientsProvider = Provider<List<ClientModel>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getVipClients();
});

/// Провайдер клиентов с днем рождения в этом месяце
final birthdayClientsProvider = Provider<List<ClientModel>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getClientsWithBirthdayThisMonth();
});

/// Провайдер топ клиентов по визитам
final topClientsByVisitsProvider = Provider.family<List<ClientModel>, int>(
  (ref, limit) {
    final repository = ref.watch(clientRepositoryProvider);
    return repository.getTopClientsByVisits(limit: limit);
  },
);

/// Провайдер топ клиентов по доходу
final topClientsByRevenueProvider = Provider.family<List<ClientModel>, int>(
  (ref, limit) {
    final repository = ref.watch(clientRepositoryProvider);
    return repository.getTopClientsByRevenue(limit: limit);
  },
);

// ==================== SEARCH PROVIDER ====================

/// Провайдер поиска клиентов
final clientSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedClientsProvider = Provider<List<ClientModel>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  final query = ref.watch(clientSearchQueryProvider);

  if (query.isEmpty) {
    return repository.getAllClients();
  }

  return repository.searchClients(query);
});

// ==================== STATISTICS PROVIDERS ====================

/// Провайдер количества клиентов
final clientsCountProvider = Provider<int>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getClientsCount();
});

/// Провайдер количества VIP клиентов
final vipClientsCountProvider = Provider<int>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getVipClientsCount();
});

/// Провайдер общего дохода от клиентов
final clientsTotalRevenueProvider = Provider<double>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getTotalRevenue();
});

/// Провайдер средней оценки клиентов
final clientsAverageRatingProvider = Provider<double>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getAverageRating();
});

/// Провайдер всех тегов клиентов
final allClientTagsProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getAllTags();
});

// ==================== NOTIFIER FOR CRUD OPERATIONS ====================

/// Notifier для управления клиентами
class ClientNotifier extends StateNotifier<AsyncValue<void>> {
  ClientNotifier(this.repository) : super(const AsyncValue.data(null));

  final ClientRepository repository;

  /// Создать клиента
  Future<void> createClient(ClientModel client) async {
    state = const AsyncValue.loading();
    try {
      await repository.createClient(client);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить клиента
  Future<void> updateClient(ClientModel client) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateClient(client);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить клиента
  Future<void> deleteClient(String clientId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteClient(clientId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить статистику клиента
  Future<void> updateClientStats({
    required String clientId,
    required double appointmentPrice,
    DateTime? visitDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateClientStats(
        clientId: clientId,
        appointmentPrice: appointmentPrice,
        visitDate: visitDate,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Переключить VIP статус
  Future<void> toggleVipStatus(String clientId) async {
    state = const AsyncValue.loading();
    try {
      await repository.toggleVipStatus(clientId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Добавить фото
  Future<void> addPhoto(String clientId, String photoUrl) async {
    state = const AsyncValue.loading();
    try {
      await repository.addPhotoToClient(clientId, photoUrl);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить фото
  Future<void> removePhoto(String clientId, String photoUrl) async {
    state = const AsyncValue.loading();
    try {
      await repository.removePhotoFromClient(clientId, photoUrl);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Добавить тег
  Future<void> addTag(String clientId, String tag) async {
    state = const AsyncValue.loading();
    try {
      await repository.addTag(clientId, tag);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить тег
  Future<void> removeTag(String clientId, String tag) async {
    state = const AsyncValue.loading();
    try {
      await repository.removeTag(clientId, tag);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Провайдер ClientNotifier
final clientNotifierProvider =
    StateNotifierProvider<ClientNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return ClientNotifier(repository);
});

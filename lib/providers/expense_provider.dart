import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';

// ==================== REPOSITORY PROVIDER ====================

/// Провайдер репозитория расходов
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

// ==================== STATE PROVIDERS ====================

/// Провайдер списка всех расходов
final allExpensesProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchAllExpenses();
});

/// Провайдер конкретного расхода по ID
final expenseByIdProvider = StreamProvider.family<ExpenseModel?, String>(
  (ref, expenseId) {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.watchExpense(expenseId);
  },
);

/// Провайдер расходов на сегодня
final todayExpensesProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchTodayExpenses();
});

/// Провайдер расходов за текущий месяц
final monthExpensesProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchMonthExpenses();
});

/// Провайдер расходов за текущую неделю
final weekExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesThisWeek();
});

/// Провайдер расходов за текущий год
final yearExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesThisYear();
});

/// Провайдер расходов по категории
final expensesByCategoryProvider = Provider.family<List<ExpenseModel>, String>(
  (ref, category) {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.getExpensesByCategory(category);
  },
);

/// Провайдер расходов за период
final expensesByDateRangeProvider = Provider.family<List<ExpenseModel>,
    ({DateTime startDate, DateTime endDate})>(
  (ref, params) {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.getExpensesByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  },
);

/// Провайдер топ расходов
final topExpensesProvider = Provider.family<List<ExpenseModel>, int>(
  (ref, limit) {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.getTopExpenses(limit: limit);
  },
);

// ==================== SEARCH PROVIDER ====================

/// Провайдер поиска расходов
final expenseSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  final query = ref.watch(expenseSearchQueryProvider);

  if (query.isEmpty) {
    return repository.getAllExpenses();
  }

  return repository.searchExpenses(query);
});

// ==================== FILTER PROVIDERS ====================

/// Провайдер выбранной категории для фильтрации
final selectedExpenseCategoryProvider = StateProvider<String?>((ref) => null);

/// Провайдер отфильтрованных расходов
final filteredExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  final selectedCategory = ref.watch(selectedExpenseCategoryProvider);

  if (selectedCategory == null) {
    return repository.getAllExpenses();
  }

  return repository.getExpensesByCategory(selectedCategory);
});

// ==================== STATISTICS PROVIDERS ====================

/// Провайдер количества расходов
final expensesCountProvider = Provider<int>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesCount();
});

/// Провайдер общей суммы расходов
final totalExpensesProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getTotalExpenses();
});

/// Провайдер расходов за сегодня (сумма)
final todayExpensesTotalProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getTodayExpensesTotal();
});

/// Провайдер расходов за неделю (сумма)
final weekExpensesTotalProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getWeekExpensesTotal();
});

/// Провайдер расходов за месяц (сумма)
final monthExpensesTotalProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getMonthExpensesTotal();
});

/// Провайдер расходов за год (сумма)
final yearExpensesTotalProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getYearExpensesTotal();
});

/// Провайдер среднего расхода
final averageExpenseProvider = Provider<double>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getAverageExpense();
});

/// Провайдер расходов по категориям (сумма)
final expensesByCategoryTotalProvider = Provider<Map<String, double>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesByCategorySummary();
});

/// Провайдер количества расходов по категориям
final expensesCountByCategoryProvider = Provider<Map<String, int>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpensesCountByCategory();
});

/// Провайдер всех категорий расходов
final allExpenseCategoriesProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getAllCategories();
});

/// Провайдер расходов по месяцам
final expensesByMonthProvider = Provider.family<Map<String, double>, int>(
  (ref, monthsCount) {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.getExpensesByMonth(monthsCount: monthsCount);
  },
);

/// Провайдер самой дорогой категории
final mostExpensiveCategoryProvider = Provider<String?>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getMostExpensiveCategory();
});

// ==================== PROFIT PROVIDER ====================

/// Провайдер чистой прибыли (доход - расходы)
final netProfitProvider = Provider<double>((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  // Здесь нужно будет добавить импорт appointment_provider
  // и взять доход из appointmentRepositoryProvider
  final totalExpenses = expenseRepository.getTotalExpenses();

  // TODO: Добавить доход из AppointmentRepository
  // final totalRevenue = ref.watch(appointmentRepositoryProvider).getTotalRevenue();
  // return totalRevenue - totalExpenses;

  return -totalExpenses; // Временно возвращаем только расходы
});

/// Провайдер прибыли за месяц
final monthNetProfitProvider = Provider<double>((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final monthExpenses = expenseRepository.getMonthExpensesTotal();

  // TODO: Добавить доход из AppointmentRepository
  // final monthRevenue = ref.watch(appointmentRepositoryProvider).getMonthRevenue();
  // return monthRevenue - monthExpenses;

  return -monthExpenses; // Временно
});

// ==================== NOTIFIER FOR CRUD OPERATIONS ====================

/// Notifier для управления расходами
class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  ExpenseNotifier(this.repository) : super(const AsyncValue.data(null));

  final ExpenseRepository repository;

  /// Создать расход
  Future<void> createExpense(ExpenseModel expense) async {
    state = const AsyncValue.loading();
    try {
      await repository.createExpense(expense);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Создать несколько расходов
  Future<void> createExpenses(List<ExpenseModel> expenses) async {
    state = const AsyncValue.loading();
    try {
      await repository.createExpenses(expenses);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить расход
  Future<void> updateExpense(ExpenseModel expense) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateExpense(expense);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить расход
  Future<void> deleteExpense(String expenseId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteExpense(expenseId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить сумму расхода
  Future<void> updateExpenseAmount(String expenseId, double newAmount) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateExpenseAmount(expenseId, newAmount);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Обновить категорию расхода
  Future<void> updateExpenseCategory(
      String expenseId, String newCategory) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateExpenseCategory(expenseId, newCategory);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Удалить старые расходы
  Future<void> deleteOldExpenses({int daysOld = 365}) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteOldExpenses(daysOld: daysOld);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Провайдер ExpenseNotifier
final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ExpenseNotifier(repository);
});

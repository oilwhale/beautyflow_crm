import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  static const String _boxName = 'expenses';

  // Получить Box
  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(_boxName);

  // ==================== CREATE ====================

  /// Создать новый расход
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
    return expense;
  }

  /// Создать несколько расходов (массовое добавление)
  Future<void> createExpenses(List<ExpenseModel> expenses) async {
    final Map<String, ExpenseModel> expensesMap = {
      for (var expense in expenses) expense.id: expense
    };
    await _box.putAll(expensesMap);
  }

  // ==================== READ ====================

  /// Получить все расходы
  List<ExpenseModel> getAllExpenses() {
    return _box.values.toList();
  }

  /// Получить расход по ID
  ExpenseModel? getExpenseById(String id) {
    return _box.get(id);
  }

  /// Получить расходы по категории
  List<ExpenseModel> getExpensesByCategory(String category) {
    return _box.values
        .where((expense) => expense.category == category)
        .toList();
  }

  /// Получить расходы за период
  List<ExpenseModel> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _box.values.where((expense) {
      return expense.date
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Получить расходы на конкретную дату
  List<ExpenseModel> getExpensesByDate(DateTime date) {
    return _box.values.where((expense) {
      return expense.date.year == date.year &&
          expense.date.month == date.month &&
          expense.date.day == date.day;
    }).toList();
  }

  /// Получить расходы за сегодня
  List<ExpenseModel> getTodayExpenses() {
    return getExpensesByDate(DateTime.now());
  }

  /// Получить расходы за текущую неделю
  List<ExpenseModel> getExpensesThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getExpensesByDateRange(
      startDate: startOfWeek,
      endDate: endOfWeek,
    );
  }

  /// Получить расходы за текущий месяц
  List<ExpenseModel> getExpensesThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getExpensesByDateRange(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  /// Получить расходы за текущий год
  List<ExpenseModel> getExpensesThisYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);

    return getExpensesByDateRange(
      startDate: startOfYear,
      endDate: endOfYear,
    );
  }

  /// Получить расходы в ценовом диапазоне
  List<ExpenseModel> getExpensesByAmountRange({
    required double minAmount,
    required double maxAmount,
  }) {
    return _box.values.where((expense) {
      return expense.amount >= minAmount && expense.amount <= maxAmount;
    }).toList();
  }

  /// Поиск расходов
  List<ExpenseModel> searchExpenses(String query) {
    if (query.isEmpty) return getAllExpenses();

    final lowerQuery = query.toLowerCase();
    return _box.values.where((expense) {
      final nameMatch = expense.name.toLowerCase().contains(lowerQuery);
      final notesMatch =
          expense.notes?.toLowerCase().contains(lowerQuery) ?? false;
      return nameMatch || notesMatch;
    }).toList();
  }

  /// Получить расходы, отсортированные по дате
  List<ExpenseModel> getExpensesSortedByDate({bool ascending = false}) {
    final expenses = getAllExpenses();
    expenses.sort((a, b) {
      return ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
    });
    return expenses;
  }

  /// Получить расходы, отсортированные по сумме
  List<ExpenseModel> getExpensesSortedByAmount({bool ascending = false}) {
    final expenses = getAllExpenses();
    expenses.sort((a, b) {
      return ascending
          ? a.amount.compareTo(b.amount)
          : b.amount.compareTo(a.amount);
    });
    return expenses;
  }

  /// Получить топ расходов
  List<ExpenseModel> getTopExpenses({int limit = 10}) {
    final expenses = getAllExpenses();
    expenses.sort((a, b) => b.amount.compareTo(a.amount));
    return expenses.take(limit).toList();
  }

  // ==================== UPDATE ====================

  /// Обновить расход
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
    return expense;
  }

  /// Обновить сумму расхода
  Future<ExpenseModel> updateExpenseAmount(
      String expenseId, double newAmount) async {
    final expense = getExpenseById(expenseId);
    if (expense == null) {
      throw Exception('Expense not found');
    }

    final updatedExpense = expense.copyWith(amount: newAmount);
    await _box.put(expenseId, updatedExpense);
    return updatedExpense;
  }

  /// Обновить категорию расхода
  Future<ExpenseModel> updateExpenseCategory(
      String expenseId, String newCategory) async {
    final expense = getExpenseById(expenseId);
    if (expense == null) {
      throw Exception('Expense not found');
    }

    final updatedExpense = expense.copyWith(category: newCategory);
    await _box.put(expenseId, updatedExpense);
    return updatedExpense;
  }

  // ==================== DELETE ====================

  /// Удалить расход
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  /// Удалить расходы по категории
  Future<void> deleteExpensesByCategory(String category) async {
    final expenseIds = _box.values
        .where((expense) => expense.category == category)
        .map((expense) => expense.id)
        .toList();

    await _box.deleteAll(expenseIds);
  }

  /// Удалить старые расходы
  Future<void> deleteOldExpenses({int daysOld = 365}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

    final oldExpenseIds = _box.values
        .where((expense) => expense.date.isBefore(cutoffDate))
        .map((expense) => expense.id)
        .toList();

    await _box.deleteAll(oldExpenseIds);
  }

  /// Удалить все расходы (осторожно!)
  Future<void> deleteAllExpenses() async {
    await _box.clear();
  }

  // ==================== STATISTICS ====================

  /// Получить общее количество расходов
  int getExpensesCount() {
    return _box.length;
  }

  /// Получить общую сумму расходов
  double getTotalExpenses() {
    return _box.values.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Получить сумму расходов за период
  double getTotalExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final expenses = getExpensesByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Получить расходы за сегодня (сумма)
  double getTodayExpensesTotal() {
    final today = DateTime.now();
    return getTotalExpensesByDateRange(startDate: today, endDate: today);
  }

  /// Получить расходы за неделю (сумма)
  double getWeekExpensesTotal() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getTotalExpensesByDateRange(
        startDate: startOfWeek, endDate: endOfWeek);
  }

  /// Получить расходы за месяц (сумма)
  double getMonthExpensesTotal() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getTotalExpensesByDateRange(
        startDate: startOfMonth, endDate: endOfMonth);
  }

  /// Получить расходы за год (сумма)
  double getYearExpensesTotal() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);

    return getTotalExpensesByDateRange(
        startDate: startOfYear, endDate: endOfYear);
  }

  /// Получить средний расход
  double getAverageExpense() {
    if (_box.isEmpty) return 0.0;
    return getTotalExpenses() / _box.length;
  }

  /// Получить расходы по категориям (сумма)
  Map<String, double> getExpensesByCategorySummary() {
    final Map<String, double> categoryExpenses = {};

    for (final expense in _box.values) {
      categoryExpenses[expense.category] =
          (categoryExpenses[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryExpenses;
  }

  /// Получить количество расходов по категориям
  Map<String, int> getExpensesCountByCategory() {
    final Map<String, int> categoryCount = {};

    for (final expense in _box.values) {
      categoryCount[expense.category] =
          (categoryCount[expense.category] ?? 0) + 1;
    }

    return categoryCount;
  }

  /// Получить все уникальные категории
  List<String> getAllCategories() {
    final categoriesSet = <String>{};
    for (final expense in _box.values) {
      categoriesSet.add(expense.category);
    }
    return categoriesSet.toList()..sort();
  }

  /// Получить расходы по месяцам (для графика)
  Map<String, double> getExpensesByMonth({int monthsCount = 12}) {
    final Map<String, double> monthlyExpenses = {};
    final now = DateTime.now();

    for (int i = 0; i < monthsCount; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';

      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final total = getTotalExpensesByDateRange(
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      monthlyExpenses[monthKey] = total;
    }

    return monthlyExpenses;
  }

  /// Получить самую дорогую категорию
  String? getMostExpensiveCategory() {
    final categoryExpenses = getExpensesByCategorySummary();
    if (categoryExpenses.isEmpty) return null;

    return categoryExpenses.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // ==================== STREAM ====================

  /// Stream для прослушивания изменений в расходах
  Stream<List<ExpenseModel>> watchAllExpenses() {
    return _box.watch().map((_) => getAllExpenses());
  }

  /// Stream для прослушивания изменений конкретного расхода
  Stream<ExpenseModel?> watchExpense(String expenseId) {
    return _box.watch(key: expenseId).map((_) => getExpenseById(expenseId));
  }

  /// Stream для расходов за сегодня
  Stream<List<ExpenseModel>> watchTodayExpenses() {
    return _box.watch().map((_) => getTodayExpenses());
  }

  /// Stream для расходов за текущий месяц
  Stream<List<ExpenseModel>> watchMonthExpenses() {
    return _box.watch().map((_) => getExpensesThisMonth());
  }
}

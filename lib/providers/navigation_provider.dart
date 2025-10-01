import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== BOTTOM NAV PROVIDER ====================

/// Индексы экранов в нижней навигации
enum NavDestination {
  dashboard(0, 'Главная', 'dashboard'),
  calendar(1, 'Календарь', 'calendar'),
  clients(2, 'Клиенты', 'clients'),
  services(3, 'Услуги', 'services'),
  finance(4, 'Финансы', 'finance');

  const NavDestination(this.tabIndex, this.label, this.route);

  final int tabIndex;
  final String label;
  final String route;
}

/// Провайдер текущего выбранного экрана в нижней навигации
final bottomNavIndexProvider =
    StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0); // Начинаем с Dashboard

  /// Установить индекс
  void setIndex(int index) {
    if (index >= 0 && index < NavDestination.values.length) {
      state = index;
    }
  }

  /// Перейти на Dashboard
  void goToDashboard() => state = NavDestination.dashboard.tabIndex;

  /// Перейти на Calendar
  void goToCalendar() => state = NavDestination.calendar.tabIndex;

  /// Перейти на Clients
  void goToClients() => state = NavDestination.clients.tabIndex;

  /// Перейти на Services
  void goToServices() => state = NavDestination.services.tabIndex;

  /// Перейти на Finance
  void goToFinance() => state = NavDestination.finance.tabIndex;

  /// Циклическое переключение экранов
  void cycleNext() {
    final current = state;
    final next = (current + 1) % NavDestination.values.length;
    setIndex(next);
  }

  /// Получить NavDestination по индексу
  NavDestination getDestination() {
    return NavDestination.values[state];
  }
}

// ==================== CALENDAR VIEW MODE PROVIDER ====================

/// Режимы отображения календаря
enum CalendarViewMode {
  day('День'),
  week('Неделя'),
  month('Месяц');

  const CalendarViewMode(this.label);

  final String label;
}

/// Провайдер режима отображения календаря
final calendarViewModeProvider =
    StateNotifierProvider<CalendarViewModeNotifier, CalendarViewMode>((ref) {
  return CalendarViewModeNotifier();
});

class CalendarViewModeNotifier extends StateNotifier<CalendarViewMode> {
  CalendarViewModeNotifier() : super(CalendarViewMode.week);

  /// Установить режим
  void setMode(CalendarViewMode mode) {
    state = mode;
  }

  /// Переключить на день
  void setDayMode() => state = CalendarViewMode.day;

  /// Переключить на неделю
  void setWeekMode() => state = CalendarViewMode.week;

  /// Переключить на месяц
  void setMonthMode() => state = CalendarViewMode.month;

  /// Циклическое переключение режимов
  void cycleMode() {
    final currentIndex = CalendarViewMode.values.indexOf(state);
    final nextIndex = (currentIndex + 1) % CalendarViewMode.values.length;
    state = CalendarViewMode.values[nextIndex];
  }
}

// ==================== MODAL STATE PROVIDER ====================

/// Типы модальных окон
enum ModalType {
  none,
  newAppointment,
  appointmentDetails,
  newClient,
  clientDetails,
  newService,
  serviceDetails,
  newExpense,
  expenseDetails,
  settings,
}

/// Провайдер текущего открытого модального окна
final activeModalProvider =
    StateNotifierProvider<ActiveModalNotifier, ModalType>((ref) {
  return ActiveModalNotifier();
});

class ActiveModalNotifier extends StateNotifier<ModalType> {
  ActiveModalNotifier() : super(ModalType.none);

  /// Открыть модальное окно
  void openModal(ModalType type) {
    state = type;
  }

  /// Закрыть текущее модальное окно
  void closeModal() {
    state = ModalType.none;
  }

  /// Проверить, открыто ли какое-либо модальное окно
  bool get isModalOpen => state != ModalType.none;

  // Удобные методы для открытия конкретных модалок
  void openNewAppointment() => state = ModalType.newAppointment;
  void openAppointmentDetails() => state = ModalType.appointmentDetails;
  void openNewClient() => state = ModalType.newClient;
  void openClientDetails() => state = ModalType.clientDetails;
  void openNewService() => state = ModalType.newService;
  void openServiceDetails() => state = ModalType.serviceDetails;
  void openNewExpense() => state = ModalType.newExpense;
  void openExpenseDetails() => state = ModalType.expenseDetails;
  void openSettings() => state = ModalType.settings;
}

// ==================== SELECTED ITEM PROVIDER ====================

/// Провайдер ID выбранного элемента (для деталей)
final selectedItemIdProvider = StateProvider<String?>((ref) => null);

// ==================== DRAWER STATE PROVIDER ====================

/// Провайдер состояния бокового меню (для планшетов/десктопа)
final drawerOpenProvider = StateProvider<bool>((ref) => false);

// ==================== FILTER PANEL PROVIDER ====================

/// Провайдер состояния панели фильтров
final filterPanelOpenProvider = StateProvider<bool>((ref) => false);

// ==================== NAVIGATION HISTORY PROVIDER ====================

/// Провайдер истории навигации для кнопки "Назад"
final navigationHistoryProvider =
    StateNotifierProvider<NavigationHistoryNotifier, List<String>>((ref) {
  return NavigationHistoryNotifier();
});

class NavigationHistoryNotifier extends StateNotifier<List<String>> {
  NavigationHistoryNotifier() : super([]);

  /// Добавить маршрут в историю
  void push(String route) {
    state = [...state, route];
  }

  /// Вернуться назад (удалить последний маршрут)
  String? pop() {
    if (state.isEmpty) return null;

    final lastRoute = state.last;
    state = state.sublist(0, state.length - 1);
    return lastRoute;
  }

  /// Очистить историю
  void clear() {
    state = [];
  }

  /// Проверить, можно ли вернуться назад
  bool get canGoBack => state.isNotEmpty;

  /// Получить предыдущий маршрут
  String? get previousRoute => state.isEmpty ? null : state.last;
}

// ==================== FAB VISIBILITY PROVIDER ====================

/// Провайдер видимости FloatingActionButton
final fabVisibleProvider = StateProvider<bool>((ref) {
  // FAB видна на всех экранах кроме настроек
  final currentNav = ref.watch(bottomNavIndexProvider);
  return currentNav !=
      NavDestination.finance.tabIndex; // Скрыть на финансах, показать везде
});

// ==================== SCROLL PROVIDER ====================

/// Провайдер состояния скролла (для скрытия/показа элементов)
final isScrollingProvider = StateProvider<bool>((ref) => false);

/// Провайдер направления скролла
enum ScrollDirection { up, down, none }

final scrollDirectionProvider =
    StateProvider<ScrollDirection>((ref) => ScrollDirection.none);

// ==================== SEARCH MODE PROVIDER ====================

/// Провайдер режима поиска
final searchModeActiveProvider = StateProvider<bool>((ref) => false);

// ==================== HELPER PROVIDERS ====================

/// Провайдер текущего названия экрана
final currentScreenTitleProvider = Provider<String>((ref) {
  final index = ref.watch(bottomNavIndexProvider);
  final destination = NavDestination.values[index];
  return destination.label;
});

/// Провайдер текущего маршрута
final currentRouteProvider = Provider<String>((ref) {
  final index = ref.watch(bottomNavIndexProvider);
  final destination = NavDestination.values[index];
  return destination.route;
});

/// Провайдер проверки, на каком экране мы находимся
final isOnDashboardProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavIndexProvider) == NavDestination.dashboard.tabIndex;
});

final isOnCalendarProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavIndexProvider) == NavDestination.calendar.tabIndex;
});

final isOnClientsProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavIndexProvider) == NavDestination.clients.tabIndex;
});

final isOnServicesProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavIndexProvider) == NavDestination.services.tabIndex;
});

final isOnFinanceProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavIndexProvider) == NavDestination.finance.tabIndex;
});

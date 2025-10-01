import 'package:hive_flutter/hive_flutter.dart';
import 'package:beautyflow_crm/data/models/client_model.dart';
import 'package:beautyflow_crm/data/models/service_model.dart';
import 'package:beautyflow_crm/data/models/appointment_model.dart';
import 'package:beautyflow_crm/data/models/expense_model.dart';
import 'package:beautyflow_crm/data/models/settings_model.dart';

class HiveService {
  // Названия боксов
  static const String clientsBox = 'clients';
  static const String servicesBox = 'services';
  static const String appointmentsBox = 'appointments';
  static const String expensesBox = 'expenses';
  static const String settingsBox = 'settings';

  /// Инициализация Hive
  static Future<void> init() async {
    // Инициализация Hive для Flutter
    await Hive.initFlutter();

    // Регистрация адаптеров
    Hive.registerAdapter(ClientModelAdapter());
    Hive.registerAdapter(ServiceModelAdapter());
    Hive.registerAdapter(AppointmentModelAdapter());
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());

    // Открытие боксов
    await Hive.openBox<ClientModel>(clientsBox);
    await Hive.openBox<ServiceModel>(servicesBox);
    await Hive.openBox<AppointmentModel>(appointmentsBox);
    await Hive.openBox<ExpenseModel>(expensesBox);
    await Hive.openBox<SettingsModel>(settingsBox);
  }

  /// Получить бокс клиентов
  static Box<ClientModel> get clients => Hive.box<ClientModel>(clientsBox);

  /// Получить бокс услуг
  static Box<ServiceModel> get services => Hive.box<ServiceModel>(servicesBox);

  /// Получить бокс записей
  static Box<AppointmentModel> get appointments =>
      Hive.box<AppointmentModel>(appointmentsBox);

  /// Получить бокс расходов
  static Box<ExpenseModel> get expenses => Hive.box<ExpenseModel>(expensesBox);

  /// Получить бокс настроек
  static Box<SettingsModel> get settings =>
      Hive.box<SettingsModel>(settingsBox);

  /// Закрыть все боксы
  static Future<void> close() async {
    await Hive.close();
  }

  /// Удалить все данные
  static Future<void> clearAll() async {
    await clients.clear();
    await services.clear();
    await appointments.clear();
    await expenses.clear();
    await settings.clear();
  }
}

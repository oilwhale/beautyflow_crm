import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beautyflow_crm/config/theme/app_theme.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';
import 'package:beautyflow_crm/config/theme/app_text_styles.dart';
import 'package:beautyflow_crm/core/services/hive_service.dart';
import 'package:beautyflow_crm/ui/widgets/buttons/primary_button.dart';
import 'package:beautyflow_crm/ui/widgets/buttons/secondary_button.dart';
import 'package:beautyflow_crm/ui/widgets/buttons/danger_button.dart';
import 'package:beautyflow_crm/ui/widgets/inputs/custom_text_field.dart';
import 'package:beautyflow_crm/ui/widgets/cards/custom_card.dart';
import 'package:beautyflow_crm/ui/widgets/badges/status_badge.dart';
import 'package:beautyflow_crm/ui/widgets/avatars/custom_avatar.dart';
// Импорты провайдеров для теста
import 'package:beautyflow_crm/providers/client_provider.dart';
import 'package:beautyflow_crm/providers/service_provider.dart';
import 'package:beautyflow_crm/providers/appointment_provider.dart';
import 'package:beautyflow_crm/providers/expense_provider.dart';
import 'package:beautyflow_crm/providers/theme_provider.dart';
import 'package:beautyflow_crm/providers/navigation_provider.dart';
// Импорты моделей для создания тестовых данных
import 'package:beautyflow_crm/data/models/client_model.dart';
import 'package:beautyflow_crm/data/models/service_model.dart';
import 'package:beautyflow_crm/data/models/appointment_model.dart';
import 'package:beautyflow_crm/data/models/expense_model.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🗄️ Инициализация Hive
  try {
    await HiveService.init();
    print('✅ Hive initialized successfully');
  } catch (e) {
    print('❌ Error initializing Hive: $e');
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: BeautyFlowApp(),
    ),
  );
}

class BeautyFlowApp extends ConsumerWidget {
  const BeautyFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Следим за темой из провайдера
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'BeautyFlow CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      home: const ComponentsTestScreen(),
    );
  }
}

/// Тестовый экран для всех компонентов + тест БД + тест провайдеров
class ComponentsTestScreen extends ConsumerWidget {
  const ComponentsTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Следим за провайдерами
    final clientsCount = ref.watch(clientsCountProvider);
    final servicesCount = ref.watch(servicesCountProvider);
    final appointmentsCount = ref.watch(appointmentsCountProvider);
    final expensesCount = ref.watch(expensesCountProvider);
    final currentTheme = ref.watch(currentThemeNameProvider);
    final currentScreen = ref.watch(currentScreenTitleProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              // Заголовок
              Text(
                'UI Kit Components',
                style: AppTextStyles.h1,
              ),
              AppSpacing.vGapBase,
              Text(
                'Тестирование компонентов + БД + Провайдеры',
                style: AppTextStyles.h4.copyWith(color: AppColors.textGray),
              ),
              AppSpacing.vGapXl,

              // === ТЕСТ ПРОВАЙДЕРОВ ===
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚀 Провайдеры (Riverpod)',
                      style: AppTextStyles.h3,
                    ),
                    AppSpacing.vGapMd,
                    Text(
                      'Текущая тема: $currentTheme\n'
                      'Экран: $currentScreen\n'
                      'Клиентов: $clientsCount\n'
                      'Услуг: $servicesCount\n'
                      'Записей: $appointmentsCount\n'
                      'Расходов: $expensesCount',
                      style: AppTextStyles.body,
                    ),
                    AppSpacing.vGapMd,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'Создать тестовые данные',
                            icon: Icons.add_circle,
                            onPressed: () async {
                              await _createTestData(ref);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Тестовые данные созданы!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGapSm,
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'Переключить тему',
                            icon: Icons.brightness_6,
                            onPressed: () {
                              final currentMode = ref.read(themeModeProvider);
                              ref
                                  .read(themeModeProvider.notifier)
                                  .toggleTheme();
                              final newMode = ref.read(themeModeProvider);

                              print(
                                  '🎨 Тема изменена: $currentMode → $newMode');

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Тема: $newMode'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                        AppSpacing.hGapSm,
                        Expanded(
                          child: SecondaryButton(
                            text: 'Навигация',
                            icon: Icons.navigation,
                            onPressed: () {
                              ref
                                  .read(bottomNavIndexProvider.notifier)
                                  .cycleNext();
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGapSm,
                    Row(
                      children: [
                        Expanded(
                          child: DangerButton(
                            text: 'Очистить всё',
                            icon: Icons.delete_forever,
                            onPressed: () async {
                              await _clearAllData(ref);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🗑️ Все данные удалены'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === ТЕСТ БАЗЫ ДАННЫХ ===
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🗄️ База данных Hive',
                      style: AppTextStyles.h3,
                    ),
                    AppSpacing.vGapMd,
                    Text(
                      'Прямая проверка Hive боксов',
                      style: AppTextStyles.small,
                    ),
                    AppSpacing.vGapMd,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'Проверить БД',
                            icon: Icons.storage,
                            onPressed: () {
                              final clientsCount = HiveService.clients.length;
                              final servicesCount = HiveService.services.length;
                              final appointmentsCount =
                                  HiveService.appointments.length;
                              final expensesCount = HiveService.expenses.length;
                              final settingsCount = HiveService.settings.length;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✅ БД работает!\n'
                                    'Клиентов: $clientsCount\n'
                                    'Услуг: $servicesCount\n'
                                    'Записей: $appointmentsCount\n'
                                    'Расходов: $expensesCount\n'
                                    'Настроек: $settingsCount',
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === КНОПКИ ===
              _buildSection(
                'Кнопки',
                Column(
                  children: [
                    PrimaryButton(
                      text: 'Primary Button',
                      onPressed: () {},
                      icon: Icons.add,
                    ),
                    AppSpacing.vGapMd,
                    SecondaryButton(
                      text: 'Secondary Button',
                      onPressed: () {},
                      icon: Icons.edit,
                    ),
                    AppSpacing.vGapMd,
                    DangerButton(
                      text: 'Delete',
                      icon: Icons.delete,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === ПОЛЯ ВВОДА ===
              _buildSection(
                'Поля ввода',
                Column(
                  children: [
                    CustomTextField(
                      label: 'Имя клиента',
                      hint: 'Введите имя...',
                      prefixIcon: Icons.person,
                      controller: TextEditingController(),
                    ),
                    AppSpacing.vGapMd,
                    SearchTextField(
                      hint: 'Поиск клиентов...',
                      controller: TextEditingController(),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === КАРТОЧКИ ===
              _buildSection(
                'Карточки',
                Column(
                  children: [
                    CustomCard(
                      child: Text('Карточка статистики'),
                    ),
                    AppSpacing.vGapMd,
                    CustomCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CustomAvatar(
                                name: 'Анна Иванова',
                                size: 52,
                              ),
                              AppSpacing.hGapMd,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Анна Иванова',
                                      style: AppTextStyles.h4,
                                    ),
                                    AppSpacing.vGapXs,
                                    Text(
                                      '+7 (999) 123-45-67',
                                      style: AppTextStyles.small,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vGapMd,
                          Row(
                            children: [
                              StatusBadge.vip(isSmall: true),
                              AppSpacing.hGapSm,
                              StatusBadge.status('confirmed', isSmall: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === БЕЙДЖИ ===
              _buildSection(
                'Бейджи',
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    StatusBadge.status('confirmed'),
                    StatusBadge.status('pending'),
                    StatusBadge.status('cancelled'),
                    StatusBadge.vip(),
                    const CountBadge(count: 5),
                    CategoryTag.service('Волосы'),
                    CategoryTag.service('Ногти'),
                  ],
                ),
              ),

              AppSpacing.vGapXl,

              // === АВАТАРЫ ===
              _buildSection(
                'Аватары',
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        CustomAvatar(
                          name: 'Анна Иванова',
                          size: 40,
                        ),
                        CustomAvatar(
                          name: 'Мария Петрова',
                          size: 52,
                        ),
                        CustomAvatar(
                          name: 'Елена Сидорова',
                          size: 64,
                          hasStatus: true,
                        ),
                      ],
                    ),
                    AppSpacing.vGapMd,
                    const AvatarGroup(
                      names: [
                        'Анна Иванова',
                        'Мария Петрова',
                        'Елена Сидорова',
                        'Ольга Смирнова',
                        'Татьяна Кузнецова',
                      ],
                      maxVisible: 4,
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapXxl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3,
          ),
          AppSpacing.vGapMd,
          child,
        ],
      ),
    );
  }

  /// Создать тестовые данные
  Future<void> _createTestData(WidgetRef ref) async {
    const uuid = Uuid();

    // 1. Создать тестовых клиентов
    final testClients = [
      ClientModel(
        id: uuid.v4(),
        name: 'Анна Иванова',
        phone: '+7 (999) 123-45-67',
        email: 'anna@example.com',
        birthday: DateTime(1990, 5, 15),
        notes: 'Любит натуральные цвета',
        rating: 5.0,
        totalVisits: 12,
        totalRevenue: 24000,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        isVip: true,
        tags: ['постоянная', 'рекомендует'],
      ),
      ClientModel(
        id: uuid.v4(),
        name: 'Мария Петрова',
        phone: '+7 (999) 234-56-78',
        rating: 4.5,
        totalVisits: 8,
        totalRevenue: 16000,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 10)),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        isVip: false,
      ),
      ClientModel(
        id: uuid.v4(),
        name: 'Елена Сидорова',
        phone: '+7 (999) 345-67-89',
        rating: 5.0,
        totalVisits: 20,
        totalRevenue: 40000,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        isVip: true,
        tags: ['vip', 'друг'],
      ),
    ];

    for (final client in testClients) {
      await ref.read(clientNotifierProvider.notifier).createClient(client);
    }

    // 2. Создать тестовые услуги
    final testServices = [
      ServiceModel(
        id: uuid.v4(),
        name: 'Стрижка женская',
        category: 'hair',
        price: 2000,
        duration: 60,
        description: 'Стрижка любой сложности',
        isActive: true,
        timesPerformed: 45,
        totalRevenue: 90000,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      ServiceModel(
        id: uuid.v4(),
        name: 'Маникюр с покрытием',
        category: 'nails',
        price: 1500,
        duration: 90,
        description: 'Маникюр + гель-лак',
        isActive: true,
        timesPerformed: 60,
        totalRevenue: 90000,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      ServiceModel(
        id: uuid.v4(),
        name: 'Окрашивание',
        category: 'hair',
        price: 5000,
        duration: 180,
        description: 'Окрашивание волос премиум красителями',
        isActive: true,
        timesPerformed: 30,
        totalRevenue: 150000,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
    ];

    for (final service in testServices) {
      await ref.read(serviceNotifierProvider.notifier).createService(service);
    }

    // 3. Создать тестовые записи
    final testAppointments = [
      AppointmentModel(
        id: uuid.v4(),
        clientId: testClients[0].id,
        serviceIds: [testServices[0].id],
        date: DateTime.now().add(const Duration(days: 1)),
        time: '14:00',
        duration: 60,
        price: 2000,
        status: 'confirmed',
        notes: 'Клиент попросил более короткую стрижку',
        createdAt: DateTime.now(),
      ),
      AppointmentModel(
        id: uuid.v4(),
        clientId: testClients[1].id,
        serviceIds: [testServices[1].id],
        date: DateTime.now().add(const Duration(days: 2)),
        time: '16:00',
        duration: 90,
        price: 1500,
        status: 'pending',
        createdAt: DateTime.now(),
      ),
    ];

    for (final appointment in testAppointments) {
      await ref
          .read(appointmentNotifierProvider.notifier)
          .createAppointment(appointment);
    }

    // 4. Создать тестовые расходы
    final testExpenses = [
      ExpenseModel(
        id: uuid.v4(),
        name: 'Закупка материалов',
        amount: 15000,
        category: 'materials',
        date: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Гель-лаки, пилки, базы',
        createdAt: DateTime.now(),
      ),
      ExpenseModel(
        id: uuid.v4(),
        name: 'Аренда помещения',
        amount: 30000,
        category: 'rent',
        date: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Аренда за октябрь',
        createdAt: DateTime.now(),
      ),
      ExpenseModel(
        id: uuid.v4(),
        name: 'Реклама в Instagram',
        amount: 5000,
        category: 'marketing',
        date: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Таргетированная реклама',
        createdAt: DateTime.now(),
      ),
    ];

    for (final expense in testExpenses) {
      await ref.read(expenseNotifierProvider.notifier).createExpense(expense);
    }
  }

  /// Очистить все данные
  Future<void> _clearAllData(WidgetRef ref) async {
    await HiveService.clients.clear();
    await HiveService.services.clear();
    await HiveService.appointments.clear();
    await HiveService.expenses.clear();
  }
}

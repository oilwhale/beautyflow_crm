import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 3)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category; // materials, rent, marketing, other

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  late DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Создать новый расход
  factory ExpenseModel.create({
    required String name,
    required double amount,
    required String category,
    required DateTime date,
    String? notes,
  }) {
    return ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      category: category,
      date: date,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  // Копирование с изменениями
  ExpenseModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Форматированная сумма
  String getFormattedAmount() {
    return '${amount.toStringAsFixed(0)} ₽';
  }

  // Форматированная дата
  String getFormattedDate() {
    final months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, name: $name, amount: $amount, category: $category)';
  }
}

// Категории расходов
class ExpenseCategory {
  static const String materials = 'materials';
  static const String rent = 'rent';
  static const String marketing = 'marketing';
  static const String equipment = 'equipment';
  static const String education = 'education';
  static const String other = 'other';

  static const List<String> all = [
    materials,
    rent,
    marketing,
    equipment,
    education,
    other,
  ];

  static String getDisplayName(String category) {
    switch (category) {
      case materials:
        return 'Материалы';
      case rent:
        return 'Аренда';
      case marketing:
        return 'Реклама';
      case equipment:
        return 'Оборудование';
      case education:
        return 'Обучение';
      case other:
        return 'Прочее';
      default:
        return category;
    }
  }

  static String getIcon(String category) {
    switch (category) {
      case materials:
        return '🎨';
      case rent:
        return '🏠';
      case marketing:
        return '📱';
      case equipment:
        return '🔧';
      case education:
        return '📚';
      case other:
        return '💰';
      default:
        return '💵';
    }
  }
}

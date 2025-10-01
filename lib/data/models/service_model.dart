import 'package:hive/hive.dart';

part 'service_model.g.dart';

@HiveType(typeId: 1)
class ServiceModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? icon; // Название иконки или emoji

  @HiveField(3)
  late String category; // hair, nails, massage, makeup, spa, lashes

  @HiveField(4)
  late double price;

  @HiveField(5)
  late int duration; // в минутах

  @HiveField(6)
  String? description;

  @HiveField(7)
  List<String>? tags;

  @HiveField(8)
  bool isActive;

  @HiveField(9)
  int timesPerformed;

  @HiveField(10)
  double totalRevenue;

  @HiveField(11)
  late DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.name,
    this.icon,
    required this.category,
    required this.price,
    required this.duration,
    this.description,
    this.tags,
    this.isActive = true,
    this.timesPerformed = 0,
    this.totalRevenue = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Создать новую услугу
  factory ServiceModel.create({
    required String name,
    required String category,
    required double price,
    required int duration,
    String? icon,
    String? description,
    List<String>? tags,
  }) {
    return ServiceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      price: price,
      duration: duration,
      icon: icon,
      description: description,
      tags: tags,
      createdAt: DateTime.now(),
    );
  }

  // Копирование с изменениями
  ServiceModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? category,
    double? price,
    int? duration,
    String? description,
    List<String>? tags,
    bool? isActive,
    int? timesPerformed,
    double? totalRevenue,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      timesPerformed: timesPerformed ?? this.timesPerformed,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Форматированная цена
  String getFormattedPrice() {
    return '${price.toStringAsFixed(0)} ₽';
  }

  // Форматированная длительность
  String getFormattedDuration() {
    if (duration < 60) {
      return '$duration мин';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '$hours ч';
    }
    return '$hours ч $minutes мин';
  }

  // Средняя цена за выполнение
  double getAverageRevenue() {
    if (timesPerformed == 0) return 0.0;
    return totalRevenue / timesPerformed;
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, price: $price, category: $category)';
  }
}

// Категории услуг
class ServiceCategory {
  static const String hair = 'hair';
  static const String nails = 'nails';
  static const String massage = 'massage';
  static const String makeup = 'makeup';
  static const String spa = 'spa';
  static const String lashes = 'lashes';

  static const List<String> all = [
    hair,
    nails,
    massage,
    makeup,
    spa,
    lashes,
  ];

  static String getDisplayName(String category) {
    switch (category) {
      case hair:
        return 'Волосы';
      case nails:
        return 'Ногти';
      case massage:
        return 'Массаж';
      case makeup:
        return 'Макияж';
      case spa:
        return 'СПА';
      case lashes:
        return 'Ресницы/Брови';
      default:
        return category;
    }
  }
}

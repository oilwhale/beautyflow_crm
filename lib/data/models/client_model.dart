import 'package:hive/hive.dart';

part 'client_model.g.dart';

@HiveType(typeId: 0)
class ClientModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? email;

  @HiveField(4)
  DateTime? birthday;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  List<String>? photoUrls;

  @HiveField(7)
  double rating;

  @HiveField(8)
  int totalVisits;

  @HiveField(9)
  double totalRevenue;

  @HiveField(10)
  DateTime? lastVisitDate;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  bool isVip;

  @HiveField(13)
  List<String>? tags; // Например: "Постоянный", "Новый", и т.д.

  ClientModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.birthday,
    this.notes,
    this.photoUrls,
    this.rating = 0.0,
    this.totalVisits = 0,
    this.totalRevenue = 0.0,
    this.lastVisitDate,
    DateTime? createdAt,
    this.isVip = false,
    this.tags,
  }) : createdAt = createdAt ?? DateTime.now();

  // Создать нового клиента с уникальным ID
  factory ClientModel.create({
    required String name,
    String? phone,
    String? email,
    DateTime? birthday,
    String? notes,
  }) {
    return ClientModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      birthday: birthday,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  // Копирование с изменениями
  ClientModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    DateTime? birthday,
    String? notes,
    List<String>? photoUrls,
    double? rating,
    int? totalVisits,
    double? totalRevenue,
    DateTime? lastVisitDate,
    DateTime? createdAt,
    bool? isVip,
    List<String>? tags,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      rating: rating ?? this.rating,
      totalVisits: totalVisits ?? this.totalVisits,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      createdAt: createdAt ?? this.createdAt,
      isVip: isVip ?? this.isVip,
      tags: tags ?? this.tags,
    );
  }

  // Получить инициалы клиента
  String getInitials() {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Проверить, давно ли был клиент
  bool hasNotVisitedRecently({int days = 30}) {
    if (lastVisitDate == null) return true;
    final daysSinceVisit = DateTime.now().difference(lastVisitDate!).inDays;
    return daysSinceVisit > days;
  }

  // Получить статус клиента
  String getClientStatus() {
    if (totalVisits == 0) return 'Новый';
    if (isVip) return 'VIP';
    if (hasNotVisitedRecently(days: 60)) return 'Давно не был';
    if (totalVisits >= 10) return 'Постоянный';
    return 'Активный';
  }

  @override
  String toString() {
    return 'ClientModel(id: $id, name: $name, phone: $phone, totalVisits: $totalVisits)';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 4;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      masterName: fields[0] as String?,
      masterPhone: fields[1] as String?,
      masterEmail: fields[2] as String?,
      workingHoursStart: fields[3] as String?,
      workingHoursEnd: fields[4] as String?,
      weekendDays: (fields[5] as List?)?.cast<int>(),
      notificationsEnabled: fields[6] as bool,
      notifyBeforeAppointment: fields[7] as bool,
      notifyMinutesBefore: fields[8] as int?,
      theme: fields[9] as String,
      darkMode: fields[10] as bool,
      currency: fields[11] as String?,
      lastBackupDate: fields[12] as DateTime?,
      isPremium: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.masterName)
      ..writeByte(1)
      ..write(obj.masterPhone)
      ..writeByte(2)
      ..write(obj.masterEmail)
      ..writeByte(3)
      ..write(obj.workingHoursStart)
      ..writeByte(4)
      ..write(obj.workingHoursEnd)
      ..writeByte(5)
      ..write(obj.weekendDays)
      ..writeByte(6)
      ..write(obj.notificationsEnabled)
      ..writeByte(7)
      ..write(obj.notifyBeforeAppointment)
      ..writeByte(8)
      ..write(obj.notifyMinutesBefore)
      ..writeByte(9)
      ..write(obj.theme)
      ..writeByte(10)
      ..write(obj.darkMode)
      ..writeByte(11)
      ..write(obj.currency)
      ..writeByte(12)
      ..write(obj.lastBackupDate)
      ..writeByte(13)
      ..write(obj.isPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

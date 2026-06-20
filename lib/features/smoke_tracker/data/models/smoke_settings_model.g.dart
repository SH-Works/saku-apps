// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smoke_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmokeSettingsModelAdapter extends TypeAdapter<SmokeSettingsModel> {
  @override
  final typeId = 6;

  @override
  SmokeSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmokeSettingsModel()
      ..isEnabled = fields[0] as bool
      ..dailyLimit = (fields[1] as num).toInt()
      ..cigarettesPerPack = (fields[2] as num).toInt()
      ..pricePerPack = (fields[3] as num).toInt()
      ..notifyAtLimit = fields[4] as bool
      ..notifyAt80Percent = fields[5] as bool
      ..autoLogExpense = fields[6] as bool
      ..expenseWalletId = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, SmokeSettingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.dailyLimit)
      ..writeByte(2)
      ..write(obj.cigarettesPerPack)
      ..writeByte(3)
      ..write(obj.pricePerPack)
      ..writeByte(4)
      ..write(obj.notifyAtLimit)
      ..writeByte(5)
      ..write(obj.notifyAt80Percent)
      ..writeByte(6)
      ..write(obj.autoLogExpense)
      ..writeByte(7)
      ..write(obj.expenseWalletId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmokeSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

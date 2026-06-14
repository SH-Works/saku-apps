// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recuring_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecuringModelAdapter extends TypeAdapter<RecuringModel> {
  @override
  final typeId = 2;

  @override
  RecuringModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecuringModel()
      ..id = fields[0] as String
      ..type = fields[1] as String
      ..amount = (fields[2] as num).toInt()
      ..categoryId = fields[3] as String
      ..walletId = fields[4] as String
      ..frequency = fields[5] as String
      ..dayOfMonth = (fields[6] as num).toInt()
      ..startDate = fields[7] as DateTime
      ..endDate = fields[8] as DateTime?
      ..lastProcessedDate = fields[9] as DateTime?
      ..isActive = fields[10] as bool
      ..notes = fields[11] as String?
      ..label = fields[12] as String
      ..createdAt = fields[13] as DateTime;
  }

  @override
  void write(BinaryWriter writer, RecuringModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.walletId)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.dayOfMonth)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.lastProcessedDate)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.label)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecuringModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

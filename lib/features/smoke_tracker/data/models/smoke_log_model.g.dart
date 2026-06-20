// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smoke_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmokeLogModelAdapter extends TypeAdapter<SmokeLogModel> {
  @override
  final typeId = 5;

  @override
  SmokeLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmokeLogModel()
      ..id = fields[0] as String
      ..loggedAt = fields[1] as DateTime
      ..date = fields[2] as DateTime
      ..notes = fields[3] as String?
      ..createdAt = fields[4] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SmokeLogModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.loggedAt)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmokeLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

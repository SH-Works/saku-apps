// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transfer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletTransferModelAdapter extends TypeAdapter<WalletTransferModel> {
  @override
  final typeId = 4;

  @override
  WalletTransferModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletTransferModel()
      ..id = fields[0] as String
      ..fromWalletId = fields[1] as String
      ..toWalletId = fields[2] as String
      ..amount = (fields[3] as num).toInt()
      ..date = fields[4] as DateTime
      ..notes = fields[5] as String?
      ..createdAt = fields[6] as DateTime;
  }

  @override
  void write(BinaryWriter writer, WalletTransferModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromWalletId)
      ..writeByte(2)
      ..write(obj.toWalletId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransferModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

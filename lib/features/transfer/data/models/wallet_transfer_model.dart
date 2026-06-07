import 'package:hive_ce/hive.dart';

import '../../domain/entities/wallet_transfer.dart';

part 'wallet_transfer_model.g.dart';

@HiveType(typeId: 4)
class WalletTransferModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String fromWalletId;

  @HiveField(2)
  late String toWalletId;

  @HiveField(3)
  late int amount;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  late DateTime createdAt;

  WalletTransferModel();

  WalletTransfer toEntity() => WalletTransfer(
        id: id,
        fromWalletId: fromWalletId,
        toWalletId: toWalletId,
        amount: amount,
        date: date,
        notes: notes,
        createdAt: createdAt,
      );

  static WalletTransferModel fromEntity(WalletTransfer t) => WalletTransferModel()
    ..id = t.id
    ..fromWalletId = t.fromWalletId
    ..toWalletId = t.toWalletId
    ..amount = t.amount
    ..date = t.date
    ..notes = t.notes
    ..createdAt = t.createdAt;
}

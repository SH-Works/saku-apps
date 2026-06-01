import 'package:hive_ce/hive.dart';

import '../../domain/entities/wallet.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 1)
class WalletModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String icon;

  @HiveField(3)
  late int seedBalance;

  @HiveField(4)
  late bool isDefault;

  @HiveField(5)
  late DateTime createdAt;

  WalletModel();

  Wallet toEntity() => Wallet(
        id: id,
        name: name,
        icon: icon,
        seedBalance: seedBalance,
        isDefault: isDefault,
        createdAt: createdAt,
      );

  static WalletModel fromEntity(Wallet w) => WalletModel()
    ..id = w.id
    ..name = w.name
    ..icon = w.icon
    ..seedBalance = w.seedBalance
    ..isDefault = w.isDefault
    ..createdAt = w.createdAt;
}

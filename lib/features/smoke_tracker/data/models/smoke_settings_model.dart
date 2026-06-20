import 'package:hive_ce/hive.dart';

import '../../domain/entities/smoke_settings.dart';

part 'smoke_settings_model.g.dart';

@HiveType(typeId: 6)
class SmokeSettingsModel extends HiveObject {
  @HiveField(0)
  late bool isEnabled;

  @HiveField(1)
  late int dailyLimit;

  @HiveField(2)
  late int cigarettesPerPack;

  @HiveField(3)
  late int pricePerPack;

  @HiveField(4)
  late bool notifyAtLimit;

  @HiveField(5)
  late bool notifyAt80Percent;

  @HiveField(6)
  late bool autoLogExpense;

  @HiveField(7)
  late String expenseWalletId;

  SmokeSettingsModel();

  SmokeSettings toEntity() => SmokeSettings(
        isEnabled: isEnabled,
        dailyLimit: dailyLimit,
        cigarettesPerPack: cigarettesPerPack,
        pricePerPack: pricePerPack,
        notifyAtLimit: notifyAtLimit,
        notifyAt80Percent: notifyAt80Percent,
        autoLogExpense: autoLogExpense,
        expenseWalletId: expenseWalletId,
      );

  static SmokeSettingsModel fromEntity(SmokeSettings s) => SmokeSettingsModel()
    ..isEnabled = s.isEnabled
    ..dailyLimit = s.dailyLimit
    ..cigarettesPerPack = s.cigarettesPerPack
    ..pricePerPack = s.pricePerPack
    ..notifyAtLimit = s.notifyAtLimit
    ..notifyAt80Percent = s.notifyAt80Percent
    ..autoLogExpense = s.autoLogExpense
    ..expenseWalletId = s.expenseWalletId;
}

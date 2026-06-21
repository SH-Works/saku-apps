import 'package:freezed_annotation/freezed_annotation.dart';

part 'smoke_settings.freezed.dart';

@freezed
abstract class SmokeSettings with _$SmokeSettings {
  const factory SmokeSettings({
    required bool isEnabled,
    required int dailyLimit,
    required int cigarettesPerPack,
    required int pricePerPack,
    required bool notifyAtLimit,
    required bool notifyAt80Percent,
    required bool autoLogExpense,
    required String expenseWalletId,
  }) = _SmokeSettings;

  factory SmokeSettings.defaults() => const SmokeSettings(
        isEnabled: false,
        dailyLimit: 15,
        cigarettesPerPack: 20,
        pricePerPack: 25000,
        notifyAtLimit: true,
        notifyAt80Percent: true,
        autoLogExpense: false,
        expenseWalletId: '',
      );
}

extension SmokeSettingsX on SmokeSettings {
  int get pricePerCigarette =>
      cigarettesPerPack > 0 ? pricePerPack ~/ cigarettesPerPack : 0;

  int dailyCost(int count) => count * pricePerCigarette;
}

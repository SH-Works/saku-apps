import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String name,
    required String icon,
    /// Seed balance when the wallet was created.
    /// Current balance = seedBalance + sum of linked income - expense transactions.
    @Default(0) int seedBalance,
    required bool isDefault,
    required DateTime createdAt,
  }) = _Wallet;
}

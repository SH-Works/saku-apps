import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_transfer.freezed.dart';

@freezed
abstract class WalletTransfer with _$WalletTransfer {
  const factory WalletTransfer({
    required String id,
    required String fromWalletId,
    required String toWalletId,
    required int amount,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _WalletTransfer;
}

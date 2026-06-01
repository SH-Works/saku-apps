import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense }

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,
    required int amount,
    required String categoryId,
    /// The wallet this transaction belongs to.
    /// Defaults to 'default' for records created before multi-wallet support.
    @Default('default') String walletId,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}

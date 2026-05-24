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
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}

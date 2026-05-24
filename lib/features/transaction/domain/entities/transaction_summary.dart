import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_summary.freezed.dart';

@freezed
abstract class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    required int totalIncome,
    required int totalExpense,
    required int balance,
    required Map<String, int> byCategory,
    required Map<int, int> dailyExpense,
  }) = _TransactionSummary;

  factory TransactionSummary.empty() => const TransactionSummary(
        totalIncome: 0,
        totalExpense: 0,
        balance: 0,
        byCategory: {},
        dailyExpense: {},
      );
}

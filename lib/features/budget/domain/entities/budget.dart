import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String categoryId,
    required int limitAmount,
    required int month,
    required int year,
    required DateTime createdAt,
  }) = _Budget;
}

/// Computed progress — not persisted.
class BudgetProgress {
  final Budget budget;
  final int spentAmount;
  final int remainingAmount;
  final double percentage;
  final bool isWarning;
  final bool isExceeded;

  BudgetProgress({
    required this.budget,
    required this.spentAmount,
  })  : remainingAmount = budget.limitAmount - spentAmount,
        percentage = budget.limitAmount <= 0
            ? 0
            : spentAmount / budget.limitAmount,
        isWarning = budget.limitAmount <= 0
            ? false
            : spentAmount / budget.limitAmount >= 0.8,
        isExceeded =
            budget.limitAmount > 0 && spentAmount >= budget.limitAmount;
}

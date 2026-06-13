import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgetProgress {
  final BudgetRepository budgetRepo;
  final TransactionRepository transactionRepo;

  GetBudgetProgress(this.budgetRepo, this.transactionRepo);

  Future<List<BudgetProgress>> call(int year, int month) async {
    final budgets = budgetRepo.getBudgetsByMonth(year, month);
    final transactions = await transactionRepo.getTransactionsByMonth(year, month);

    return budgets.map((budget) {
      final spent = transactions
          .where(
            (tx) =>
                tx.type == TransactionType.expense &&
                tx.categoryId == budget.categoryId,
          )
          .fold<int>(0, (sum, tx) => sum + tx.amount);

      return BudgetProgress(budget: budget, spentAmount: spent);
    }).toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
  }
}

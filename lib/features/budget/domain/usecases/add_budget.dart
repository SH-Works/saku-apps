import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class DuplicateBudgetException implements Exception {
  final String message;
  DuplicateBudgetException([this.message = 'Budget kategori ini sudah ada']);

  @override
  String toString() => message;
}

class AddBudget {
  final BudgetRepository repository;
  AddBudget(this.repository);

  Future<void> call(Budget budget) async {
    if (budget.limitAmount <= 0) {
      throw Exception('Limit budget harus lebih dari 0');
    }

    final existing = repository.getBudgetByCategory(
      budget.categoryId,
      budget.year,
      budget.month,
    );
    if (existing != null) {
      throw DuplicateBudgetException();
    }

    await repository.addBudget(budget);
  }
}

import '../entities/budget.dart';

abstract class BudgetRepository {
  List<Budget> getBudgetsByMonth(int year, int month);
  Budget? getBudgetByCategory(String categoryId, int year, int month);
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
  Stream<List<Budget>> watchAllBudgets();
}

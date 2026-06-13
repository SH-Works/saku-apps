import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgetsByMonth {
  final BudgetRepository repository;
  GetBudgetsByMonth(this.repository);

  List<Budget> call(int year, int month) =>
      repository.getBudgetsByMonth(year, month);
}

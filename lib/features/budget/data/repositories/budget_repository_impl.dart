import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource _ds;

  BudgetRepositoryImpl(this._ds);

  @override
  List<Budget> getBudgetsByMonth(int year, int month) =>
      _ds.getBudgetsByMonth(year, month);

  @override
  Budget? getBudgetByCategory(String categoryId, int year, int month) =>
      _ds.getBudgetByCategory(categoryId, year, month);

  @override
  Future<void> addBudget(Budget budget) =>
      _ds.saveBudget(BudgetModel.fromEntity(budget));

  @override
  Future<void> updateBudget(Budget budget) =>
      _ds.saveBudget(BudgetModel.fromEntity(budget));

  @override
  Future<void> deleteBudget(String id) => _ds.deleteBudget(id);

  @override
  Stream<List<Budget>> watchAllBudgets() => _ds.watchAllBudgets();
}

import 'package:hive_ce/hive.dart';

import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  List<Budget> getBudgetsByMonth(int year, int month);
  Budget? getBudgetByCategory(String categoryId, int year, int month);
  Future<void> saveBudget(BudgetModel model);
  Future<void> deleteBudget(String id);
  Stream<List<Budget>> watchAllBudgets();
  static const String boxName = 'budgets';
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final Box<BudgetModel> _box;

  BudgetLocalDataSourceImpl(this._box);

  @override
  List<Budget> getBudgetsByMonth(int year, int month) {
    return _box.values
        .where((m) => m.year == year && m.month == month)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Budget? getBudgetByCategory(String categoryId, int year, int month) {
    try {
      return _box.values
          .firstWhere(
            (m) =>
                m.categoryId == categoryId &&
                m.year == year &&
                m.month == month,
          )
          .toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveBudget(BudgetModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<Budget>> watchAllBudgets() async* {
    yield _box.values.map((m) => m.toEntity()).toList();
    yield* _box.watch().map((_) => _box.values.map((m) => m.toEntity()).toList());
  }
}

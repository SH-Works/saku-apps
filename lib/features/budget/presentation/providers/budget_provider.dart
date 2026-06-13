import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../data/datasources/budget_local_datasource.dart';
import '../../data/models/budget_model.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/add_budget.dart';
import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/get_budgets_by_month.dart';
import '../../domain/usecases/get_budget_progress.dart';

typedef MonthKey = ({int year, int month});

/// Must be overridden in main.dart after Hive initialization.
final budgetBoxProvider = Provider<Box<BudgetModel>>((ref) {
  throw UnimplementedError('budgetBoxProvider must be overridden in main.dart');
});

final budgetLocalDataSourceProvider = Provider<BudgetLocalDataSource>((ref) {
  return BudgetLocalDataSourceImpl(ref.watch(budgetBoxProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(budgetLocalDataSourceProvider));
});

final addBudgetProvider = Provider<AddBudget>((ref) {
  return AddBudget(ref.watch(budgetRepositoryProvider));
});

final deleteBudgetProvider = Provider<DeleteBudget>((ref) {
  return DeleteBudget(ref.watch(budgetRepositoryProvider));
});

final getBudgetsByMonthProvider = Provider<GetBudgetsByMonth>((ref) {
  return GetBudgetsByMonth(ref.watch(budgetRepositoryProvider));
});

final getBudgetProgressProvider = Provider<GetBudgetProgress>((ref) {
  return GetBudgetProgress(
    ref.watch(budgetRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final budgetsByMonthProvider =
    FutureProvider.family<List<Budget>, MonthKey>((ref, key) async {
  ref.watch(allTransactionsStreamProvider);
  return ref.read(getBudgetsByMonthProvider).call(key.year, key.month);
});

final budgetProgressProvider =
    FutureProvider.family<List<BudgetProgress>, MonthKey>((ref, key) async {
  ref.watch(allTransactionsStreamProvider);
  return ref.read(getBudgetProgressProvider).call(key.year, key.month);
});

final budgetWarningsProvider = Provider<AsyncValue<List<BudgetProgress>>>((ref) {
  final now = DateTime.now();
  final key = (year: now.year, month: now.month);
  return ref.watch(budgetProgressProvider(key)).whenData(
        (list) => list.where((p) => p.isWarning).toList(),
      );
});

final currentMonthBudgetProgressProvider =
    FutureProvider<List<BudgetProgress>>((ref) async {
  final now = DateTime.now();
  final key = (year: now.year, month: now.month);
  return ref.watch(budgetProgressProvider(key).future);
});

/// User dismissed the home budget alert banner for this session.
final budgetAlertDismissedProvider = StateProvider<bool>((ref) => false);

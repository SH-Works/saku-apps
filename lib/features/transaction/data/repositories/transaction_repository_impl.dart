import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final models = await localDataSource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByMonth(int year, int month) async {
    final models = await localDataSource.getByMonth(year, month);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await localDataSource.add(TransactionModel.fromEntity(transaction));
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDataSource.delete(id);
  }

  @override
  Future<TransactionSummary> getSummary(int year, int month) async {
    final txs = await getTransactionsByMonth(year, month);

    int totalIncome = 0;
    int totalExpense = 0;
    final byCategory = <String, int>{};
    final dailyExpense = <int, int>{};

    for (final tx in txs) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
        byCategory[tx.categoryId] =
            (byCategory[tx.categoryId] ?? 0) + tx.amount;
        final day = tx.date.day;
        dailyExpense[day] = (dailyExpense[day] ?? 0) + tx.amount;
      }
    }

    return TransactionSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
      byCategory: byCategory,
      dailyExpense: dailyExpense,
    );
  }

  @override
  Stream<List<Transaction>> watchAllTransactions() {
    return localDataSource
        .watchAll()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}

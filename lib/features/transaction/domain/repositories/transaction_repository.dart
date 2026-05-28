import '../entities/transaction.dart';
import '../entities/transaction_summary.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsByMonth(int year, int month);
  Future<void> addTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<void> deleteAllTransactions();
  Future<TransactionSummary> getSummary(int year, int month);
  Stream<List<Transaction>> watchAllTransactions();
}

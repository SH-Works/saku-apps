import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsByMonth {
  final TransactionRepository repository;
  GetTransactionsByMonth(this.repository);

  Future<List<Transaction>> call(int year, int month) =>
      repository.getTransactionsByMonth(year, month);
}

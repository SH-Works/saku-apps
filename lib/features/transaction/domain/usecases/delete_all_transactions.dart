import '../repositories/transaction_repository.dart';

class DeleteAllTransactions {
  final TransactionRepository repository;
  DeleteAllTransactions(this.repository);

  Future<void> call() => repository.deleteAllTransactions();
}

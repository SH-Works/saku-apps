import '../entities/transaction_summary.dart';
import '../repositories/transaction_repository.dart';

class GetSummary {
  final TransactionRepository repository;
  GetSummary(this.repository);

  Future<TransactionSummary> call(int year, int month) =>
      repository.getSummary(year, month);
}

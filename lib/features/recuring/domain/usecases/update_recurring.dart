import '../entities/recuring_transaction.dart';
import '../repositories/recuring_repository.dart';

class UpdateRecurring {
  final RecuringRepository repository;
  UpdateRecurring(this.repository);

  Future<void> call(RecuringTransaction recurring) =>
      repository.updateRecurring(recurring);
}

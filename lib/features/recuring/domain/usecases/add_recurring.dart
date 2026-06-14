import '../entities/recuring_transaction.dart';
import '../repositories/recuring_repository.dart';

class AddRecurring {
  final RecuringRepository repository;
  AddRecurring(this.repository);

  Future<void> call(RecuringTransaction recurring) =>
      repository.addRecurring(recurring);
}

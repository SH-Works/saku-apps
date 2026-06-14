import '../entities/recuring_transaction.dart';
import '../repositories/recuring_repository.dart';

class GetAllRecurring {
  final RecuringRepository repository;
  GetAllRecurring(this.repository);

  List<RecuringTransaction> call() => repository.getAllRecurring();
}

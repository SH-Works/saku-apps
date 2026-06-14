import '../repositories/recuring_repository.dart';

class DeleteRecurring {
  final RecuringRepository repository;
  DeleteRecurring(this.repository);

  Future<void> call(String id) => repository.deleteRecurring(id);
}

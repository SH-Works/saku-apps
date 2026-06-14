import '../repositories/recuring_repository.dart';

class ToggleRecurringActive {
  final RecuringRepository repository;
  ToggleRecurringActive(this.repository);

  Future<void> call(String id) => repository.toggleActive(id);
}

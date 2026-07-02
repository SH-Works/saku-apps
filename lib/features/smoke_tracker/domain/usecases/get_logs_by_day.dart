import '../entities/smoke_log.dart';
import '../repositories/smoke_repository.dart';

class GetLogsByDay {
  final SmokeRepository repository;
  GetLogsByDay(this.repository);

  List<SmokeLog> call(DateTime date) => repository.getLogsByDay(date);
}

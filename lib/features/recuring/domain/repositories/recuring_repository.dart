import '../entities/recuring_transaction.dart';

abstract class RecuringRepository {
  List<RecuringTransaction> getAllRecurring();
  Future<void> addRecurring(RecuringTransaction recurring);
  Future<void> updateRecurring(RecuringTransaction recurring);
  Future<void> deleteRecurring(String id);
  Future<void> toggleActive(String id);
  List<RecuringTransaction> getDueRecurring(DateTime now);
  Future<void> markAsProcessed(String id, DateTime processedDate);
  Stream<List<RecuringTransaction>> watchAllRecurring();
}

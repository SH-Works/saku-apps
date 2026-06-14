import '../../domain/entities/recuring_transaction.dart';
import '../../domain/repositories/recuring_repository.dart';
import '../datasources/recuring_local_datasource.dart';
import '../models/recuring_model.dart';

class RecuringRepositoryImpl implements RecuringRepository {
  final RecuringLocalDataSource _ds;

  RecuringRepositoryImpl(this._ds);

  @override
  List<RecuringTransaction> getAllRecurring() => _ds.getAllRecurring();

  @override
  Future<void> addRecurring(RecuringTransaction recurring) =>
      _ds.saveRecurring(RecuringModel.fromEntity(recurring));

  @override
  Future<void> updateRecurring(RecuringTransaction recurring) =>
      _ds.saveRecurring(RecuringModel.fromEntity(recurring));

  @override
  Future<void> deleteRecurring(String id) => _ds.deleteRecurring(id);

  @override
  Future<void> toggleActive(String id) async {
    final all = _ds.getAllRecurring();
    final existing = all.where((r) => r.id == id).firstOrNull;
    if (existing == null) return;
    await _ds.saveRecurring(
      RecuringModel.fromEntity(existing.copyWith(isActive: !existing.isActive)),
    );
  }

  @override
  List<RecuringTransaction> getDueRecurring(DateTime now) =>
      _ds.getDueRecurring(now);

  @override
  Future<void> markAsProcessed(String id, DateTime processedDate) =>
      _ds.markAsProcessed(id, processedDate);

  @override
  Stream<List<RecuringTransaction>> watchAllRecurring() =>
      _ds.watchAllRecurring();
}

import 'package:hive_ce/hive.dart';

import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/recuring_transaction.dart';
import '../models/recuring_model.dart';

/// Next occurrence after [afterDate] was processed.
DateTime getNextDueDate(RecuringTransaction r, DateTime afterDate) {  switch (r.frequency) {
    case RecuringFrequency.daily:
      return afterDate.add(const Duration(days: 1));
    case RecuringFrequency.weekly:
      return afterDate.add(const Duration(days: 7));
    case RecuringFrequency.monthly:
      var month = afterDate.month + 1;
      var year = afterDate.year;
      if (month > 12) {
        month = 1;
        year++;
      }
      final day = r.dayOfMonth.clamp(1, 28);
      return DateTime(year, month, day);
    case RecuringFrequency.yearly:
      return DateTime(
        afterDate.year + 1,
        r.startDate.month,
        r.dayOfMonth.clamp(1, 28),
      );
  }
}

bool isRecurringDue(RecuringTransaction r, DateTime now) {
  if (!r.isActive) return false;

  final today = DateHelper.dateOnly(now);
  if (DateHelper.dateOnly(r.startDate).isAfter(today)) return false;
  if (r.endDate != null && DateHelper.dateOnly(r.endDate!).isBefore(today)) {
    return false;
  }

  if (r.lastProcessedDate == null) {
    return !DateHelper.dateOnly(r.startDate).isAfter(today);
  }

  final nextDue = getNextDueDate(r, r.lastProcessedDate!);
  return !DateHelper.dateOnly(nextDue).isAfter(today);
}

abstract class RecuringLocalDataSource {
  List<RecuringTransaction> getAllRecurring();
  Future<void> saveRecurring(RecuringModel model);
  Future<void> deleteRecurring(String id);
  List<RecuringTransaction> getDueRecurring(DateTime now);
  Future<void> markAsProcessed(String id, DateTime processedDate);
  Stream<List<RecuringTransaction>> watchAllRecurring();
  static const String boxName = 'recuring';
}

class RecuringLocalDataSourceImpl implements RecuringLocalDataSource {
  final Box<RecuringModel> _box;

  RecuringLocalDataSourceImpl(this._box);

  @override
  List<RecuringTransaction> getAllRecurring() =>
      _box.values.map((m) => m.toEntity()).toList();

  @override
  Future<void> saveRecurring(RecuringModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteRecurring(String id) async {
    await _box.delete(id);
  }

  @override
  List<RecuringTransaction> getDueRecurring(DateTime now) {
    return getAllRecurring().where((r) => isRecurringDue(r, now)).toList();
  }

  @override
  Future<void> markAsProcessed(String id, DateTime processedDate) async {
    final model = _box.get(id);
    if (model == null) return;
    model.lastProcessedDate = processedDate;
    await model.save();
  }

  @override
  Stream<List<RecuringTransaction>> watchAllRecurring() async* {
    yield getAllRecurring();
    yield* _box.watch().map((_) => getAllRecurring());
  }
}

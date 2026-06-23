import 'package:hive_ce/hive.dart';

import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/smoke_log.dart';
import '../models/smoke_log_model.dart';

abstract class SmokeLogDataSource {
  List<SmokeLog> getAllLogs();
  List<SmokeLog> getLogsByDay(DateTime date);
  List<SmokeLog> getLogsByMonth(int year, int month);
  Map<DateTime, int> getDailyCountByMonth(int year, int month);
  Future<void> saveLog(SmokeLogModel model);
  Future<void> deleteLog(String id);
  static const String boxName = 'smoke_logs';
}

class SmokeLogDataSourceImpl implements SmokeLogDataSource {
  final Box<SmokeLogModel> _box;

  SmokeLogDataSourceImpl(this._box);

  @override
  List<SmokeLog> getAllLogs() {
    final logs = _box.values.map((m) => m.toEntity()).toList();
    logs.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return logs;
  }

  @override
  List<SmokeLog> getLogsByDay(DateTime date) {
    final day = DateHelper.dateOnly(date);
    return getAllLogs()
        .where((l) => DateHelper.isSameDay(l.date, day))
        .toList();
  }

  @override
  List<SmokeLog> getLogsByMonth(int year, int month) {
    return getAllLogs()
        .where((l) => l.date.year == year && l.date.month == month)
        .toList();
  }

  @override
  Map<DateTime, int> getDailyCountByMonth(int year, int month) {
    final map = <DateTime, int>{};
    for (final log in getLogsByMonth(year, month)) {
      final day = DateHelper.dateOnly(log.date);
      map[day] = (map[day] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<void> saveLog(SmokeLogModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteLog(String id) async {
    await _box.delete(id);
  }
}

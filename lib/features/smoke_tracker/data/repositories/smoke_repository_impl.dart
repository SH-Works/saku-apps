import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/smoke_log.dart';
import '../../domain/entities/smoke_settings.dart';
import '../../domain/repositories/smoke_repository.dart';
import '../datasources/smoke_log_datasource.dart';
import '../datasources/smoke_settings_datasource.dart';
import '../models/smoke_log_model.dart';
import '../models/smoke_settings_model.dart';

class SmokeRepositoryImpl implements SmokeRepository {
  final SmokeLogDataSource _logDs;
  final SmokeSettingsDataSource _settingsDs;

  SmokeRepositoryImpl(this._logDs, this._settingsDs);

  @override
  Future<void> logCigarette(SmokeLog log) =>
      _logDs.saveLog(SmokeLogModel.fromEntity(log));

  @override
  Future<void> deleteSmokeLog(String id) => _logDs.deleteLog(id);

  @override
  List<SmokeLog> getLogsByDay(DateTime date) => _logDs.getLogsByDay(date);

  @override
  List<SmokeLog> getLogsByMonth(int year, int month) =>
      _logDs.getLogsByMonth(year, month);

  @override
  Map<DateTime, int> getDailyCountByMonth(int year, int month) =>
      _logDs.getDailyCountByMonth(year, month);

  @override
  SmokeSettings? getSettings() => _settingsDs.getSettings();

  @override
  Future<void> saveSettings(SmokeSettings settings) =>
      _settingsDs.saveSettings(SmokeSettingsModel.fromEntity(settings));

  @override
  SmokeStatistics getStatistics(int year, int month) {
    final settings = getSettings() ?? SmokeSettings.defaults();
    final dailyCounts = getDailyCountByMonth(year, month);

    final lastMonth = month == 1 ? 12 : month - 1;
    final lastYear = month == 1 ? year - 1 : year;
    final lastMonthCounts = getDailyCountByMonth(lastYear, lastMonth);

    final totalThisMonth =
        dailyCounts.values.fold<int>(0, (sum, c) => sum + c);
    final totalLastMonth =
        lastMonthCounts.values.fold<int>(0, (sum, c) => sum + c);

    final daysInMonth = DateHelper.daysInMonth(year, month);
    final averagePerDay =
        daysInMonth > 0 ? totalThisMonth / daysInMonth : 0.0;

    var highestDay = 0;
    var lowestDay = 0;
    if (dailyCounts.isNotEmpty) {
      highestDay = dailyCounts.values.reduce((a, b) => a > b ? a : b);
      lowestDay = dailyCounts.values.reduce((a, b) => a < b ? a : b);
    }

    final totalCostThisMonth = totalThisMonth * settings.pricePerCigarette;

    var daysUnderLimit = 0;
    var daysOverLimit = 0;
    for (final count in dailyCounts.values) {
      if (count > settings.dailyLimit) {
        daysOverLimit++;
      } else if (count > 0) {
        daysUnderLimit++;
      }
    }

    return SmokeStatistics(
      totalThisMonth: totalThisMonth,
      totalLastMonth: totalLastMonth,
      averagePerDay: averagePerDay,
      highestDay: highestDay,
      lowestDay: lowestDay,
      totalCostThisMonth: totalCostThisMonth,
      daysUnderLimit: daysUnderLimit,
      daysOverLimit: daysOverLimit,
    );
  }
}

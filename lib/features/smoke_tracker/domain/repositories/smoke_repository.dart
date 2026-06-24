import '../entities/smoke_log.dart';
import '../entities/smoke_settings.dart';

class SmokeStatistics {
  final int totalThisMonth;
  final int totalLastMonth;
  final double averagePerDay;
  final int highestDay;
  final int lowestDay;
  final int totalCostThisMonth;
  final int daysUnderLimit;
  final int daysOverLimit;

  const SmokeStatistics({
    required this.totalThisMonth,
    required this.totalLastMonth,
    required this.averagePerDay,
    required this.highestDay,
    required this.lowestDay,
    required this.totalCostThisMonth,
    required this.daysUnderLimit,
    required this.daysOverLimit,
  });
}

abstract class SmokeRepository {
  Future<void> logCigarette(SmokeLog log);
  Future<void> deleteSmokeLog(String id);
  List<SmokeLog> getLogsByDay(DateTime date);
  List<SmokeLog> getLogsByMonth(int year, int month);
  Map<DateTime, int> getDailyCountByMonth(int year, int month);
  SmokeSettings? getSettings();
  Future<void> saveSettings(SmokeSettings settings);
  SmokeStatistics getStatistics(int year, int month);
}

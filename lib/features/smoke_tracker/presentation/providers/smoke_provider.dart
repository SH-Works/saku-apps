import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../data/datasources/smoke_log_datasource.dart';
import '../../data/datasources/smoke_settings_datasource.dart';
import '../../data/models/smoke_log_model.dart';
import '../../data/models/smoke_settings_model.dart';
import '../../data/repositories/smoke_repository_impl.dart';
import '../../domain/entities/smoke_log.dart';
import '../../domain/entities/smoke_settings.dart';
import '../../domain/repositories/smoke_repository.dart';
import '../../domain/usecases/delete_smoke_log.dart';
import '../../domain/usecases/log_cigarette.dart';
import '../../domain/usecases/toggle_smoke_tracker.dart';
import '../../domain/usecases/update_smoke_settings.dart';

final smokeLogBoxProvider = Provider<Box<SmokeLogModel>>((ref) {
  throw UnimplementedError('smokeLogBoxProvider must be overridden in main.dart');
});

final smokeSettingsBoxProvider = Provider<Box<SmokeSettingsModel>>((ref) {
  throw UnimplementedError(
      'smokeSettingsBoxProvider must be overridden in main.dart');
});

final smokeLogDataSourceProvider = Provider<SmokeLogDataSource>((ref) {
  return SmokeLogDataSourceImpl(ref.watch(smokeLogBoxProvider));
});

final smokeSettingsDataSourceProvider =
    Provider<SmokeSettingsDataSource>((ref) {
  return SmokeSettingsDataSourceImpl(ref.watch(smokeSettingsBoxProvider));
});

final smokeRepositoryProvider = Provider<SmokeRepository>((ref) {
  return SmokeRepositoryImpl(
    ref.watch(smokeLogDataSourceProvider),
    ref.watch(smokeSettingsDataSourceProvider),
  );
});

final logCigaretteProvider = Provider<LogCigarette>((ref) {
  return LogCigarette(
    ref.watch(smokeRepositoryProvider),
    ref.watch(addTransactionUseCaseProvider),
    ref.watch(settingsBoxProvider),
  );
});

final deleteSmokeLogProvider = Provider<DeleteSmokeLog>((ref) {
  return DeleteSmokeLog(ref.watch(smokeRepositoryProvider));
});

final toggleSmokeTrackerProvider = Provider<ToggleSmokeTracker>((ref) {
  return ToggleSmokeTracker(ref.watch(smokeRepositoryProvider));
});

final updateSmokeSettingsProvider = Provider<UpdateSmokeSettings>((ref) {
  return UpdateSmokeSettings(ref.watch(smokeRepositoryProvider));
});

final smokeSettingsProvider = FutureProvider<SmokeSettings?>((ref) async {
  return ref.watch(smokeRepositoryProvider).getSettings();
});

final smokeTrackerEnabledProvider = Provider<bool>((ref) {
  return ref.watch(smokeSettingsProvider).maybeWhen(
        data: (s) => s?.isEnabled ?? false,
        orElse: () => false,
      );
});

final todayLogsProvider = FutureProvider<List<SmokeLog>>((ref) async {
  final now = DateTime.now();
  return ref.watch(smokeRepositoryProvider).getLogsByDay(
        DateTime(now.year, now.month, now.day),
      );
});

final todayCountProvider = Provider<int>((ref) {
  return ref.watch(todayLogsProvider).value?.length ?? 0;
});

typedef MonthKey = ({int year, int month});

final smokeDailyChartProvider =
    FutureProvider.family<Map<DateTime, int>, MonthKey>((ref, params) async {
  return ref.watch(smokeRepositoryProvider).getDailyCountByMonth(
        params.year,
        params.month,
      );
});

final smokeStatisticsProvider =
    FutureProvider.family<SmokeStatistics, MonthKey>((ref, params) async {
  return ref.watch(smokeRepositoryProvider).getStatistics(
        params.year,
        params.month,
      );
});

final smokeWeekChartProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final repo = ref.watch(smokeRepositoryProvider);
  final now = DateTime.now();
  final map = <DateTime, int>{};
  for (var i = 6; i >= 0; i--) {
    final day = DateTime(now.year, now.month, now.day - i);
    map[day] = repo.getLogsByDay(day).length;
  }
  return map;
});

final smokeRefreshProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(todayLogsProvider);
    ref.invalidate(smokeSettingsProvider);
    ref.invalidate(smokeWeekChartProvider);
  };
});

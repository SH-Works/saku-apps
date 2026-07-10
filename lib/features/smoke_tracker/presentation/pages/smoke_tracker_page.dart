// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/smoke_log.dart';
import '../../domain/entities/smoke_settings.dart';
import '../providers/smoke_provider.dart';
import '../widgets/smoke_counter_card.dart';
import '../widgets/smoke_daily_chart.dart';
import '../widgets/smoke_timeline.dart';

class SmokeTrackerPage extends ConsumerWidget {
  const SmokeTrackerPage({super.key});

  Future<void> _log(WidgetRef ref) async {
    await ref.read(logCigaretteProvider).call();
    ref.invalidate(todayLogsProvider);
    ref.invalidate(smokeWeekChartProvider);
  }

  Future<void> _removeLast(BuildContext context, WidgetRef ref) async {
    final logs = ref.read(todayLogsProvider).valueOrNull;
    if (logs == null || logs.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.smokeDeleteLast),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final sorted = List<SmokeLog>.from(logs)
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    await ref.read(deleteSmokeLogProvider).call(sorted.first.id);
    ref.invalidate(todayLogsProvider);
    ref.invalidate(smokeWeekChartProvider);
  }

  Future<bool> _deleteLog(
    BuildContext context,
    WidgetRef ref,
    SmokeLog log,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.smokeDeleteLog),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(deleteSmokeLogProvider).call(log.id);
      ref.invalidate(todayLogsProvider);
      ref.invalidate(smokeWeekChartProvider);
    }
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(todayLogsProvider);
    final settings = ref.watch(smokeSettingsProvider).valueOrNull ??
        SmokeSettings.defaults();
    final weekAsync = ref.watch(smokeWeekChartProvider);
    final count = logsAsync.value?.length ?? 0;
    final dailyCost = settings.dailyCost(count);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.smokeTracker),
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/smoke/stats'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/smoke/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          SmokeCounterCard(
            todayCount: count,
            dailyLimit: settings.dailyLimit,
            dailyCost: dailyCost,
            onLog: () => _log(ref),
            onRemoveLast: () => _removeLast(context, ref),
          ),
          const SizedBox(height: 28),
          logsAsync.when(
            data: (logs) => SmokeTimeline(
              logs: logs,
              onDelete: (log) => _deleteLog(context, ref, log),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 28),
          Text(
            AppStrings.smokeThisWeek,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          weekAsync.when(
            data: (counts) => SmokeDailyChart(
              dailyCounts: counts,
              dailyLimit: settings.dailyLimit,
            ),
            loading: () => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}

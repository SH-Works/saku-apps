import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../transaction/presentation/widgets/month_selector.dart';
import '../../domain/entities/smoke_settings.dart';
import '../providers/smoke_provider.dart';
import '../widgets/smoke_cost_summary.dart';
import '../widgets/smoke_daily_chart.dart';

class SmokeStatisticsPage extends ConsumerStatefulWidget {
  const SmokeStatisticsPage({super.key});

  @override
  ConsumerState<SmokeStatisticsPage> createState() =>
      _SmokeStatisticsPageState();
}

class _SmokeStatisticsPageState extends ConsumerState<SmokeStatisticsPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final key = (year: _selectedMonth.year, month: _selectedMonth.month);
    final statsAsync = ref.watch(smokeStatisticsProvider(key));
    final chartAsync = ref.watch(smokeDailyChartProvider(key));
    final settings =
        ref.watch(smokeSettingsProvider).valueOrNull ?? SmokeSettings.defaults();
    final daysInMonth =
        DateHelper.daysInMonth(_selectedMonth.year, _selectedMonth.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.smokeStatistics),
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          MonthSelector(
            selected: _selectedMonth,
            onChanged: (d) => setState(() => _selectedMonth = d),
          ),
          const SizedBox(height: 16),
          statsAsync.when(
            data: (stats) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                      label: AppStrings.smokeTotalThisMonth,
                      value: '${stats.totalThisMonth}',
                    ),
                    _StatCard(
                      label: AppStrings.smokeAvgPerDay,
                      value: stats.averagePerDay.toStringAsFixed(1),
                    ),
                    _StatCard(
                      label: AppStrings.smokeTotalCost,
                      value: formatRupiah(stats.totalCostThisMonth),
                    ),
                    _StatCard(
                      label: AppStrings.smokeDaysOverLimit,
                      value: '${stats.daysOverLimit}',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                chartAsync.when(
                  data: (counts) => SmokeMonthlyChart(
                    dailyCounts: counts,
                    dailyLimit: settings.dailyLimit,
                    daysInMonth: daysInMonth,
                  ),
                  loading: () => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('$e'),
                ),
                const SizedBox(height: 24),
                SmokeCostSummary(stats: stats, settings: settings),
                const SizedBox(height: 24),
                Text(
                  AppStrings.smokeWorstDays,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ..._worstDays(chartAsync.valueOrNull ?? {}, settings),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
          ),
        ],
      ),
    );
  }

  List<Widget> _worstDays(Map<DateTime, int> counts, SmokeSettings settings) {
    if (counts.isEmpty) {
      return [
        const Text(
          AppStrings.smokeEmptyToday,
          style: TextStyle(color: AppColors.secondary),
        ),
      ];
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(5).toList();
    final dateFmt = DateFormat('d MMM yyyy', 'id');

    return top.map((e) {
      final cost = e.value * settings.pricePerCigarette;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateFmt.format(e.key),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text('${e.value} batang'),
            const SizedBox(width: 16),
            Text(
              formatRupiah(cost),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.secondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

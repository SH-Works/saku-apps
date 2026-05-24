import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/date_helper.dart';

class MonthlyChart extends StatelessWidget {
  final Map<int, int> dailyExpense;
  final DateTime month;

  const MonthlyChart({
    super.key,
    required this.dailyExpense,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final secondary = AppColors.secondary;

    final daysInMonth = DateHelper.daysInMonth(month.year, month.month);
    final maxValue = dailyExpense.values.isEmpty
        ? 0
        : dailyExpense.values.reduce((a, b) => a > b ? a : b);
    final maxY = maxValue == 0 ? 1.0 : maxValue.toDouble() * 1.2;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  final day = value.toInt();
                  if (day == 1 ||
                      day == 5 ||
                      day == 10 ||
                      day == 15 ||
                      day == 20 ||
                      day == 25 ||
                      day == daysInMonth) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '$day',
                        style: TextStyle(fontSize: 11, color: secondary),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: List.generate(daysInMonth, (i) {
            final day = i + 1;
            final value = (dailyExpense[day] ?? 0).toDouble();
            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 6,
                  color: fg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

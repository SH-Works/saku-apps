import 'package:flutter/material.dart';
// ignore_for_file: deprecated_member_use

import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../data/datasources/recuring_local_datasource.dart';
import '../../domain/entities/recuring_transaction.dart';

class RecuringItem extends StatelessWidget {
  final RecuringTransaction recurring;
  final VoidCallback onToggle;
  final Future<bool> Function() onDeleteConfirm;

  const RecuringItem({
    super.key,
    required this.recurring,
    required this.onToggle,
    required this.onDeleteConfirm,
  });

  Color _frequencyBg(RecuringFrequency f) {
    return switch (f) {
      RecuringFrequency.daily => const Color(0xFFE0E0E0),
      RecuringFrequency.weekly => const Color(0xFFD0D0D0),
      RecuringFrequency.monthly => const Color(0xFFC0C0C0),
      RecuringFrequency.yearly => const Color(0xFFA0A0A0),
    };
  }

  String _frequencyLabel(RecuringFrequency f) {
    return switch (f) {
      RecuringFrequency.daily => AppStrings.recuringDaily,
      RecuringFrequency.weekly => AppStrings.recuringWeekly,
      RecuringFrequency.monthly => AppStrings.recuringMonthly,
      RecuringFrequency.yearly => AppStrings.recuringYearly,
    };
  }

  DateTime _nextDue() {
    if (recurring.lastProcessedDate == null) {
      return recurring.startDate;
    }
    return getNextDueDate(recurring, recurring.lastProcessedDate!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final cat = categoryById(recurring.categoryId);
    final isIncome = recurring.type.name == 'income';

    return Dismissible(
      key: ValueKey(recurring.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onDeleteConfirm(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, size: 22),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            HugeIcon(icon: cat.icon, color: fg, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recurring.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _frequencyBg(recurring.frequency),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _frequencyLabel(recurring.frequency),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: fg,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatRupiah(recurring.amount),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isIncome ? fg : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.recuringNextDue}: ${DateHelper.formatFullDate(_nextDue())}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: recurring.isActive,
              onChanged: (_) => onToggle(),
              activeColor: fg,
            ),
          ],
        ),
      ),
    );
  }
}

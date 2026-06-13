import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/budget.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetProgress progress;
  final VoidCallback onDelete;

  const BudgetProgressCard({
    super.key,
    required this.progress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final cat = categoryById(progress.budget.categoryId);
    final pct = (progress.percentage * 100).clamp(0, 999).toStringAsFixed(0);

    Color fillColor;
    if (progress.isExceeded) {
      fillColor = fg;
    } else if (progress.isWarning) {
      fillColor = const Color(0xFF3A3A3A);
    } else {
      fillColor = fg;
    }

    return Dismissible(
      key: ValueKey(progress.budget.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedDelete01,
          size: 22,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HugeIcon(icon: cat.icon, color: fg, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
                Text(
                  '${formatRupiah(progress.spentAmount)} / ${formatRupiah(progress.budget.limitAmount)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.percentage.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.lightSurface,
                valueColor: AlwaysStoppedAnimation<Color>(fillColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (progress.isExceeded)
                  Text(
                    AppStrings.budgetOverLimit,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: fg.withValues(alpha: 0.7),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

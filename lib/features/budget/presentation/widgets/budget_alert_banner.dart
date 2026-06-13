import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/budget.dart';

class BudgetAlertBanner extends StatelessWidget {
  final List<BudgetProgress> warnings;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const BudgetAlertBanner({
    super.key,
    required this.warnings,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final exceededCount = warnings.where((w) => w.isExceeded).length;
    final nearCount = warnings.length - exceededCount;

    final text = exceededCount > 0
        ? '${warnings.length} ${AppStrings.budgetAlertExceeded}'
        : '$nearCount ${AppStrings.budgetAlertNearLimit}';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.white : AppColors.black;
    final fg = isDark ? AppColors.black : AppColors.white;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '⚠ $text',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: fg),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

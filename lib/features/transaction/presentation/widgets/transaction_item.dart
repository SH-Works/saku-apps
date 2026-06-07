import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final surfaceAlt = isDark
        ? AppColors.darkSurfaceAlt
        : AppColors.lightSurface;
    final cat = categoryById(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: HugeIcon(icon: cat.icon, color: fg, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.notes?.isNotEmpty == true
                        ? '${cat.label} - ${transaction.notes}'
                        : cat.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 2),
                  // Text(
                  //   transaction.notes?.isNotEmpty == true
                  //       ? transaction.notes!
                  //       : (isIncome ? AppStrings.income : AppStrings.expense),
                  //   style: const TextStyle(
                  //     fontSize: 13,
                  //     color: AppColors.secondary,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(height: 2),
                  Text(
                    DateHelper.formatFullDate(transaction.date),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${isIncome ? '+' : '-'}${formatRupiah(transaction.amount).replaceAll('Rp ', 'Rp ')}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isIncome ? fg : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

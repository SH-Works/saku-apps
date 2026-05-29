// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';

class BalanceCard extends StatelessWidget {
  final int balance;
  final int income;
  final int expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.white : AppColors.black;
    final fg = isDark ? AppColors.black : AppColors.white;
    final fgSecondary = fg.withOpacity(0.65);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.balance,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: fgSecondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(balance),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: fg,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: AppStrings.income,
                  amount: income,
                  fg: fg,
                  fgSecondary: fgSecondary,
                  icon: HugeIcons.strokeRoundedMoneyReceive01,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: fgSecondary.withOpacity(0.2),
              ),
              Expanded(
                child: _MiniStat(
                  label: AppStrings.expense,
                  amount: expense,
                  fg: fg,
                  fgSecondary: fgSecondary,
                  icon: HugeIcons.strokeRoundedMoneyRemove01,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int amount;
  final Color fg;
  final Color fgSecondary;
  final List<List<dynamic>> icon;

  const _MiniStat({
    required this.label,
    required this.amount,
    required this.fg,
    required this.fgSecondary,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(icon: icon, size: 14, color: fgSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: fgSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatRupiah(amount),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

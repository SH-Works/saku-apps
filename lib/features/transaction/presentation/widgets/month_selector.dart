import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/date_helper.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onChanged;

  const MonthSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  void _shift(int delta) {
    final next = DateTime(selected.year, selected.month + delta);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final fg = isDark ? AppColors.white : AppColors.black;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left_rounded, color: fg),
            onPressed: () => _shift(-1),
            splashRadius: 20,
          ),
          Expanded(
            child: Text(
              DateHelper.formatMonthYear(selected),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, color: fg),
            onPressed: () => _shift(1),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

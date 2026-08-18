import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/smoke_settings.dart';
import '../providers/smoke_provider.dart';

class SmokeQuickCard extends ConsumerWidget {
  const SmokeQuickCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(todayCountProvider);
    final settingsAsync = ref.watch(smokeSettingsProvider);
    final settings = settingsAsync.valueOrNull ?? SmokeSettings.defaults();
    final dailyLimit = settings.dailyLimit;
    final progress =
        dailyLimit > 0 ? (count / dailyLimit).clamp(0.0, 1.0) : 0.0;
    final cost = settings.dailyCost(count);

    return GestureDetector(
      onTap: () => context.push('/smoke'),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Text('🚬', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.smokeTracker,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count / $dailyLimit ${AppStrings.smokeDailyLimit}',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFF3A3A3A),
                      valueColor: const AlwaysStoppedAnimation(AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatRupiah(cost),
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

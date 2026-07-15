import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/smoke_log.dart';

class SmokeTimeline extends StatelessWidget {
  final List<SmokeLog> logs;
  final Future<bool> Function(SmokeLog log) onDelete;

  const SmokeTimeline({
    super.key,
    required this.logs,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: const Text(
          AppStrings.smokeEmptyToday,
          style: TextStyle(color: AppColors.secondary, fontSize: 14),
        ),
      );
    }

    final sorted = List<SmokeLog>.from(logs)
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    final timeFmt = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.smokeTodayTimeline,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...sorted.asMap().entries.map((entry) {
          final index = sorted.length - entry.key;
          final log = entry.value;
          return Dismissible(
            key: ValueKey(log.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => onDelete(log),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline, size: 20),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    timeFmt.format(log.loggedAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rokok #$index',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (log.notes != null && log.notes!.isNotEmpty)
                          Text(
                            log.notes!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: AppColors.secondary,
                    onPressed: () async {
                      final ok = await onDelete(log);
                      if (!ok && context.mounted) {
                        // dismissed cancelled
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

import 'package:hive_ce/hive.dart';

import '../../core/constants/categories.dart';
import '../../core/services/notification_service.dart';
import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/budget/domain/usecases/get_budget_progress.dart';
import '../../features/transaction/domain/entities/transaction.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';

/// Sends budget threshold notifications once per budget/month/threshold.
class BudgetNotificationHelper {
  BudgetNotificationHelper._();

  static Future<void> checkAndNotify({
    required Box settingsBox,
    required BudgetRepository budgetRepository,
    required TransactionRepository transactionRepository,
    required Transaction transaction,
  }) async {
    if (transaction.type != TransactionType.expense) return;

    final year = transaction.date.year;
    final month = transaction.date.month;

    final progressList = await GetBudgetProgress(
      budgetRepository,
      transactionRepository,
    ).call(year, month);

    final progress = progressList
        .where((p) => p.budget.categoryId == transaction.categoryId)
        .firstOrNull;
    if (progress == null) return;

    final categoryLabel = categoryById(progress.budget.categoryId).label;
    final budgetId = progress.budget.id;

    if (progress.isExceeded) {
      await _maybeNotify(
        settingsBox: settingsBox,
        key: 'budget_notif_${budgetId}_${month}_${year}_100',
        notifId: _notifId(budgetId, month, year, 100),
        title: '🚫 Budget Exceeded',
        body: 'You exceeded $categoryLabel budget!',
      );
    } else if (progress.isWarning) {
      await _maybeNotify(
        settingsBox: settingsBox,
        key: 'budget_notif_${budgetId}_${month}_${year}_80',
        notifId: _notifId(budgetId, month, year, 80),
        title: '⚠ Budget Warning',
        body: '$categoryLabel is 80% used',
      );
    }
  }

  static Future<void> _maybeNotify({
    required Box settingsBox,
    required String key,
    required int notifId,
    required String title,
    required String body,
  }) async {
    if (settingsBox.get(key) == true) return;

    await NotificationService.showBudgetAlert(
      id: notifId,
      title: title,
      body: body,
    );
    await settingsBox.put(key, true);
  }

  static int _notifId(String budgetId, int month, int year, int threshold) {
    return Object.hash(budgetId, month, year, threshold).abs() % 100000 + 1000;
  }
}

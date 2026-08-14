import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/notification_service.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/usecases/add_transaction.dart';
import '../entities/smoke_log.dart';
import '../repositories/smoke_repository.dart';

class LogCigarette {
  final SmokeRepository smokeRepo;
  final AddTransaction addTransaction;
  final Box settingsBox;

  LogCigarette(this.smokeRepo, this.addTransaction, this.settingsBox);

  Future<void> call({String? notes}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final log = SmokeLog(
      id: const Uuid().v4(),
      loggedAt: now,
      date: today,
      notes: notes,
      createdAt: now,
    );
    await smokeRepo.logCigarette(log);

    final settings = smokeRepo.getSettings();
    if (settings == null || !settings.isEnabled) return;

    if (settings.autoLogExpense && settings.expenseWalletId.isNotEmpty) {
      final todayLogs = smokeRepo.getLogsByDay(today);
      if (todayLogs.length % settings.cigarettesPerPack == 0) {
        final tx = Transaction(
          id: const Uuid().v4(),
          type: TransactionType.expense,
          amount: settings.pricePerPack,
          categoryId: 'cigar',
          walletId: settings.expenseWalletId,
          date: now,
          notes: 'Rokok — 1 bungkus',
          createdAt: now,
        );
        await addTransaction.call(tx);
      }
    }

    final todayCount = smokeRepo.getLogsByDay(today).length;
    final dateKey =
        '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';

    if (settings.notifyAt80Percent) {
      final threshold = (settings.dailyLimit * 0.8).floor();
      if (todayCount == threshold) {
        final key = 'smoke_notif_${dateKey}_80';
        if (settingsBox.get(key) != true) {
          await settingsBox.put(key, true);
          await NotificationService.showSmokeAlert(
            id: 2000 + threshold,
            title: '⚠ Peringatan Limit Rokok',
            body:
                'Anda sudah merokok $todayCount/${settings.dailyLimit} batang hari ini. Pelan-pelan!',
          );
        }
      }
    }

    if (settings.notifyAtLimit && todayCount >= settings.dailyLimit) {
      final key = 'smoke_notif_${dateKey}_100';
      if (settingsBox.get(key) != true) {
        await settingsBox.put(key, true);
        await NotificationService.showSmokeAlert(
          id: 2100,
          title: '🚫 Limit Harian Tercapai',
          body:
              'Anda sudah mencapai limit harian ${settings.dailyLimit} batang rokok.',
        );
      }
    }
  }
}

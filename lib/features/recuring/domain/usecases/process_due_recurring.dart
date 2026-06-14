import 'package:uuid/uuid.dart';

import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/usecases/add_transaction.dart';
import '../repositories/recuring_repository.dart';

class ProcessDueRecurring {
  final RecuringRepository recurringRepo;
  final AddTransaction addTransaction;

  ProcessDueRecurring(this.recurringRepo, this.addTransaction);

  Future<void> call() async {
    final now = DateTime.now();
    final due = recurringRepo.getDueRecurring(now);

    for (final r in due) {
      final tx = Transaction(
        id: const Uuid().v4(),
        type: r.type,
        amount: r.amount,
        categoryId: r.categoryId,
        walletId: r.walletId,
        date: now,
        notes: r.notes ?? r.label,
        createdAt: now,
      );
      await addTransaction.call(tx);
      await recurringRepo.markAsProcessed(r.id, now);
    }
  }
}

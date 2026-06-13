import 'package:hive_ce/hive.dart';

import '../../../../core/utils/budget_notification_helper.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;
  final BudgetRepository budgetRepository;
  final Box settingsBox;

  AddTransaction(
    this.repository, {
    required this.budgetRepository,
    required this.settingsBox,
  });

  Future<void> call(Transaction transaction) async {
    await repository.addTransaction(transaction);

    if (transaction.type == TransactionType.expense) {
      await BudgetNotificationHelper.checkAndNotify(
        settingsBox: settingsBox,
        budgetRepository: budgetRepository,
        transactionRepository: repository,
        transaction: transaction,
      );
    }
  }
}

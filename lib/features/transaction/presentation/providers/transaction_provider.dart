import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/datasources/transaction_local_datasource.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_all_transactions.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_all_transactions.dart';
import '../../domain/usecases/get_summary.dart';
import '../../domain/usecases/get_transactions_by_month.dart';

/// Provides the open Hive [Box] for transactions.
/// Must be overridden in `main.dart` after Hive initialization.
final transactionBoxProvider = Provider<Box<TransactionModel>>((ref) {
  throw UnimplementedError(
    'transactionBoxProvider must be overridden in main.dart with the opened Hive box.',
  );
});

final transactionLocalDataSourceProvider =
    Provider<TransactionLocalDataSource>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionLocalDataSourceImpl(box);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final ds = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(ds);
});

// ---- Use cases ----

final addTransactionUseCaseProvider = Provider<AddTransaction>((ref) {
  return AddTransaction(ref.watch(transactionRepositoryProvider));
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>((ref) {
  return DeleteTransaction(ref.watch(transactionRepositoryProvider));
});

final deleteAllTransactionsUseCaseProvider =
    Provider<DeleteAllTransactions>((ref) {
  return DeleteAllTransactions(ref.watch(transactionRepositoryProvider));
});

final getAllTransactionsUseCaseProvider = Provider<GetAllTransactions>((ref) {
  return GetAllTransactions(ref.watch(transactionRepositoryProvider));
});

final getTransactionsByMonthUseCaseProvider =
    Provider<GetTransactionsByMonth>((ref) {
  return GetTransactionsByMonth(ref.watch(transactionRepositoryProvider));
});

final getSummaryUseCaseProvider = Provider<GetSummary>((ref) {
  return GetSummary(ref.watch(transactionRepositoryProvider));
});

// ---- Streams / state ----

/// Stream of all transactions, auto-updated when the Hive box changes.
final allTransactionsStreamProvider =
    StreamProvider<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchAllTransactions();
});

/// Currently-selected month for History/Report screens.
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

/// Transactions for the currently-selected month.
final monthTransactionsProvider =
    Provider<AsyncValue<List<Transaction>>>((ref) {
  final selected = ref.watch(selectedMonthProvider);
  final all = ref.watch(allTransactionsStreamProvider);
  return all.whenData((list) {
    return list
        .where((tx) =>
            tx.date.year == selected.year && tx.date.month == selected.month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  });
});

/// Summary for the currently-selected month.
final monthSummaryProvider = Provider<TransactionSummary>((ref) {
  final txsAsync = ref.watch(monthTransactionsProvider);
  return txsAsync.maybeWhen(
    data: (txs) {
      int income = 0;
      int expense = 0;
      final byCategory = <String, int>{};
      final dailyExpense = <int, int>{};
      for (final tx in txs) {
        if (tx.type == TransactionType.income) {
          income += tx.amount;
        } else {
          expense += tx.amount;
          byCategory[tx.categoryId] =
              (byCategory[tx.categoryId] ?? 0) + tx.amount;
          final day = tx.date.day;
          dailyExpense[day] = (dailyExpense[day] ?? 0) + tx.amount;
        }
      }
      return TransactionSummary(
        totalIncome: income,
        totalExpense: expense,
        balance: income - expense,
        byCategory: byCategory,
        dailyExpense: dailyExpense,
      );
    },
    orElse: TransactionSummary.empty,
  );
});

/// Current search query (debounced from [SearchPage]).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered transactions matching [searchQueryProvider].
final searchResultsProvider = Provider<List<Transaction>>((ref) {
  final query = ref.watch(searchQueryProvider).trim();
  final all = ref.watch(allTransactionsStreamProvider).maybeWhen(
        data: (list) => list,
        orElse: () => <Transaction>[],
      );
  if (query.isEmpty) return [];

  final q = query.toLowerCase();
  return all
      .where((tx) {
        final category = categoryById(tx.categoryId);
        return category.label.toLowerCase().contains(q) ||
            (tx.notes?.toLowerCase().contains(q) ?? false) ||
            formatRupiah(tx.amount).toLowerCase().contains(q) ||
            tx.amount.toString().contains(q);
      })
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

/// Overall (all-time) summary, useful for the home balance card.
final overallSummaryProvider = Provider<TransactionSummary>((ref) {
  final allAsync = ref.watch(allTransactionsStreamProvider);
  return allAsync.maybeWhen(
    data: (txs) {
      int income = 0;
      int expense = 0;
      for (final tx in txs) {
        if (tx.type == TransactionType.income) {
          income += tx.amount;
        } else {
          expense += tx.amount;
        }
      }
      return TransactionSummary(
        totalIncome: income,
        totalExpense: expense,
        balance: income - expense,
        byCategory: const {},
        dailyExpense: const {},
      );
    },
    orElse: TransactionSummary.empty,
  );
});

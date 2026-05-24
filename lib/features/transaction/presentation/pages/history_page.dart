// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/month_selector.dart';
import '../widgets/transaction_item.dart';

enum _HistoryFilter { all, income, expense }

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedMonthProvider);
    final monthTxsAsync = ref.watch(monthTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.history),
        toolbarHeight: 64,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MonthSelector(
              selected: selected,
              onChanged: (d) =>
                  ref.read(selectedMonthProvider.notifier).state = d,
            ),
            const SizedBox(height: 12),
            Center(
              child: SegmentedButton<_HistoryFilter>(
                segments: const [
                  ButtonSegment(
                      value: _HistoryFilter.all, label: Text(AppStrings.all)),
                  ButtonSegment(
                      value: _HistoryFilter.income,
                      label: Text(AppStrings.income)),
                  ButtonSegment(
                      value: _HistoryFilter.expense,
                      label: Text(AppStrings.expense)),
                ],
                selected: {_filter},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _filter = s.first),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: monthTxsAsync.when(
                data: (txs) {
                  final filtered = _applyFilter(txs);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        AppStrings.noTransactions,
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    );
                  }
                  final grouped = _groupByDay(filtered);
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final entry = grouped[index];
                      return _DaySection(
                        date: entry.date,
                        transactions: entry.transactions,
                        onDelete: _confirmDelete,
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('${AppStrings.errorPrefix}: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Transaction> _applyFilter(List<Transaction> txs) {
    switch (_filter) {
      case _HistoryFilter.all:
        return txs;
      case _HistoryFilter.income:
        return txs.where((t) => t.type == TransactionType.income).toList();
      case _HistoryFilter.expense:
        return txs.where((t) => t.type == TransactionType.expense).toList();
    }
  }

  List<_DayGroup> _groupByDay(List<Transaction> txs) {
    final map = <String, _DayGroup>{};
    for (final tx in txs) {
      final key =
          '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}';
      map.putIfAbsent(
        key,
        () => _DayGroup(date: DateHelper.dateOnly(tx.date), transactions: []),
      );
      map[key]!.transactions.add(tx);
    }
    final list = map.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> _confirmDelete(Transaction tx) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              AppStrings.delete,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(deleteTransactionUseCaseProvider).call(tx.id);
    }
  }
}

class _DayGroup {
  final DateTime date;
  final List<Transaction> transactions;
  _DayGroup({required this.date, required this.transactions});
}

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final Future<void> Function(Transaction tx) onDelete;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.onDelete,
  });

  int get _dayTotal {
    int total = 0;
    for (final tx in transactions) {
      total += tx.type == TransactionType.income ? tx.amount : -tx.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateHelper.formatDayLabel(date),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  formatRupiah(_dayTotal),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                for (int i = 0; i < transactions.length; i++) ...[
                  Dismissible(
                    key: ValueKey(transactions[i].id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      await onDelete(transactions[i]);
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                    ),
                    child: TransactionItem(transaction: transactions[i]),
                  ),
                  if (i < transactions.length - 1)
                    const Divider(indent: 56, height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

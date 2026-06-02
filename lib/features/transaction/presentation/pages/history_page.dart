// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/categories.dart';
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
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 24,
            ),
            tooltip: AppStrings.search,
            onPressed: () => context.push('/search'),
          ),
        ],
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
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<_HistoryFilter>(
                segments: [
                  ButtonSegment(
                    value: _HistoryFilter.all,
                    label: Text(style: const TextStyle(fontSize: 14), AppStrings.all),
                  ),
                  ButtonSegment(
                    value: _HistoryFilter.income,
                    label: Text(
                      style: const TextStyle(fontSize: 14),
                      AppStrings.income,
                    ),
                  ),
                  ButtonSegment(
                    value: _HistoryFilter.expense,
                    label: Text(
                      style: const TextStyle(fontSize: 14),
                      AppStrings.expense,
                    ),
                  ),
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
                        onTap: _showTransactionDetail,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('${AppStrings.errorPrefix}: $e')),
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
    final list = map.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  void _showTransactionDetail(Transaction tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TransactionDetailSheet(
        transaction: tx,
        onDelete: () async {
          Navigator.of(context).pop();
          await _confirmDelete(tx);
        },
      ),
    );
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

// ─────────────────────────────────────────────────────────────────────────────
// Detail Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;

  const _TransactionDetailSheet({
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final surfaceAlt = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurface;
    final cat = categoryById(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),

          // Icon + category + type badge
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: HugeIcon(icon: cat.icon, color: fg, size: 36),
          ),
          const SizedBox(height: 12),
          Text(
            cat.label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isIncome ? AppStrings.income : AppStrings.expense,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Amount
          Text(
            '${isIncome ? '+' : '-'} ${formatRupiah(transaction.amount)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: fg,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 28),

          // Detail rows
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: HugeIcons.strokeRoundedCalendar01,
                  label: AppStrings.date,
                  value: DateHelper.formatFullDate(transaction.date),
                  fg: fg,
                ),
                const Divider(height: 1, indent: 52),
                _DetailRow(
                  icon: HugeIcons.strokeRoundedNote01,
                  label: AppStrings.notes,
                  value: transaction.notes?.isNotEmpty == true
                      ? transaction.notes!
                      : '—',
                  fg: fg,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Delete button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedDelete01,
                color: Colors.red,
                size: 18,
              ),
              label: const Text(
                AppStrings.delete,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;
  final Color fg;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: AppColors.secondary, size: 20),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Day grouping helpers
// ─────────────────────────────────────────────────────────────────────────────

class _DayGroup {
  final DateTime date;
  final List<Transaction> transactions;
  _DayGroup({required this.date, required this.transactions});
}

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final Future<void> Function(Transaction tx) onDelete;
  final void Function(Transaction tx) onTap;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.onDelete,
    required this.onTap,
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
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedDelete01,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                    ),
                    child: TransactionItem(
                      transaction: transactions[i],
                      onTap: () => onTap(transactions[i]),
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(overallSummaryProvider);
    final txsAsync = ref.watch(allTransactionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        toolbarHeight: 64,
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedSetting07, size: 24),
            tooltip: AppStrings.settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(allTransactionsStreamProvider),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            BalanceCard(
              balance: summary.balance,
              income: summary.totalIncome,
              expense: summary.totalExpense,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.recentTransactions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => context.go('/history'),
                  child: const Text(
                    AppStrings.seeAll,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            txsAsync.when(
              data: (txs) {
                if (txs.isEmpty) {
                  return _EmptyState(onAdd: () => _openAdd(context));
                }
                final recent = txs.take(5).toList();
                return Column(
                  children: [
                    for (int i = 0; i < recent.length; i++) ...[
                      TransactionItem(transaction: recent[i]),
                      if (i < recent.length - 1)
                        const Divider(indent: 56, height: 1),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('${AppStrings.errorPrefix}: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        child: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01, size: 28),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTransactionPage(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('🪙', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            AppStrings.noTransactions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.startTracking,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              child: const Text(AppStrings.addTransaction),
            ),
          ),
        ],
      ),
    );
  }
}

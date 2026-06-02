import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../features/wallets/domain/entities/wallet.dart';
import '../../../../features/wallets/presentation/providers/wallet_provider.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWalletId = ref.watch(selectedWalletIdProvider);
    final walletsAsync = ref.watch(walletsStreamProvider);
    final txsAsync = ref.watch(allTransactionsStreamProvider);

    // Compute summary based on selected wallet
    final summary = txsAsync.maybeWhen(
      data: (all) {
        final filtered = selectedWalletId == null
            ? all
            : all.where((tx) => tx.walletId == selectedWalletId).toList();
        int income = 0, expense = 0;
        for (final tx in filtered) {
          if (tx.type == TransactionType.income) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }
        // For selected wallet, balance = seedBalance + computed
        int balance;
        if (selectedWalletId == null) {
          balance =
              income -
              expense +
              walletsAsync.maybeWhen(
                data: (ws) => ws.fold(0, (s, w) => s + w.seedBalance),
                orElse: () => 0,
              );
        } else {
          final seedBalance = walletsAsync.maybeWhen(
            data: (ws) => ws
                .where((w) => w.id == selectedWalletId)
                .fold(0, (s, w) => s + w.seedBalance),
            orElse: () => 0,
          );
          balance = seedBalance + income - expense;
        }
        return (balance: balance, income: income, expense: expense);
      },
      orElse: () => (balance: 0, income: 0, expense: 0),
    );

    final wallets = walletsAsync.maybeWhen(
      data: (list) => list,
      orElse: () => <Wallet>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
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
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedWallet01,
              size: 24,
            ),
            tooltip: AppStrings.wallets,
            onPressed: () => context.push('/wallets'),
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSetting07,
              size: 24,
            ),
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
              income: summary.income,
              expense: summary.expense,
            ),
            // Wallet chips — only show when there are multiple wallets
            if (wallets.length > 0) ...[
              const SizedBox(height: 16),
              _WalletChips(
                wallets: wallets,
                selectedId: selectedWalletId,
                onSelected: (id) =>
                    ref.read(selectedWalletIdProvider.notifier).state = id,
              ),
            ],
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
              data: (all) {
                final txs = selectedWalletId == null
                    ? all
                    : all
                          .where((tx) => tx.walletId == selectedWalletId)
                          .toList();
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

// ---- Wallet chips ----

class _WalletChips extends ConsumerWidget {
  final List<Wallet> wallets;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  const _WalletChips({
    required this.wallets,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: AppStrings.allWallets,
            emoji: '💰',
            isSelected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...wallets.map((w) {
            final balance = ref.watch(walletCurrentBalanceProvider(w.id));
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Chip(
                label: w.name,
                emoji: w.icon,
                subtitle: formatRupiah(balance),
                isSelected: selectedId == w.id,
                onTap: () => onSelected(w.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String emoji;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.emoji,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isSelected
        ? (isDark ? AppColors.white : AppColors.black)
        : Theme.of(context).colorScheme.surface;
    final fg = isSelected
        ? (isDark ? AppColors.black : AppColors.white)
        : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(
          //   strokeAlign: BorderSide.strokeAlignOutside,
          //   width: 1.5,
          //   color: isSelected ? Colors.transparent : AppColors.secondary,
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Empty state ----

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
          Image.asset('assets/icons/app_icon.png', width: 100, height: 100),
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

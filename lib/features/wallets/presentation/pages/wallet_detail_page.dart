import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../../transaction/presentation/widgets/transaction_item.dart';
import '../../../transfer/presentation/widgets/transfer_sheet.dart';
import '../providers/wallet_provider.dart';

class WalletDetailPage extends ConsumerWidget {
  final String walletId;
  const WalletDetailPage({super.key, required this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStreamProvider);
    final txsAsync = ref.watch(allTransactionsStreamProvider);
    final balance = ref.watch(walletCurrentBalanceProvider(walletId));

    final wallet = walletsAsync.maybeWhen(
      data: (list) => list.where((w) => w.id == walletId).firstOrNull,
      orElse: () => null,
    );

    if (wallet == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 24,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final walletTxs = txsAsync.maybeWhen(
      data: (list) =>
          list.where((tx) => tx.walletId == walletId).toList()
            ..sort((a, b) => b.date.compareTo(a.date)),
      orElse: () => <Transaction>[],
    );

    // Group transactions by date
    final grouped = <String, List<Transaction>>{};
    for (final tx in walletTxs) {
      final key = DateHelper.formatFullDate(tx.date);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${wallet.icon}  ${wallet.name}'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Text('⇄', style: TextStyle(fontSize: 20)),
            tooltip: AppStrings.transfer,
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => TransferSheet(defaultFromWalletId: wallet.id),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance card
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.walletBalance,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.black.withOpacity(0.6)
                        : AppColors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(balance),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.black
                        : AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                title: const Text(AppStrings.transferHistory),
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 18,
                  color: AppColors.secondary,
                ),
                onTap: () =>
                    context.push('/transfers?walletId=$walletId'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Transaction list
          Expanded(
            child: walletTxs.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📭', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 12),
                        Text(
                          AppStrings.noTransactionsForWallet,
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemCount: grouped.length,
                    itemBuilder: (ctx, i) {
                      final dateKey = grouped.keys.elementAt(i);
                      final dayTxs = grouped[dateKey]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              dateKey,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          ...dayTxs.map(
                            (tx) => TransactionItem(transaction: tx),
                          ),
                          const Divider(height: 1),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

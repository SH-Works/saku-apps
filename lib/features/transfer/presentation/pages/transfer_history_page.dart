import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/providers/wallet_provider.dart';
import '../../domain/entities/wallet_transfer.dart';
import '../providers/transfer_provider.dart';
import '../widgets/transfer_item.dart';

class TransferHistoryPage extends ConsumerWidget {
  final String? walletId;

  const TransferHistoryPage({super.key, this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsStreamProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <Wallet>[],
        );

    final transfersAsync = ref.watch(allTransfersStreamProvider);

    Wallet? walletById(String id) =>
        wallets.where((w) => w.id == id).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transferHistory),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: transfersAsync.when(
        data: (all) {
          final transfers = walletId == null
              ? all
              : all
                  .where((t) =>
                      t.fromWalletId == walletId ||
                      t.toWalletId == walletId)
                  .toList();

          if (transfers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⇄', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 12),
                  Text(
                    AppStrings.noTransfers,
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ],
              ),
            );
          }

          final grouped = _groupByDate(transfers);

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final entry = grouped[index];
              final dayTotal = entry.transfers.fold<int>(
                0,
                (sum, t) => sum + t.amount,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateHelper.formatFullDate(entry.date),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          formatRupiah(dayTotal),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...entry.transfers.map((transfer) {
                    final from = walletById(transfer.fromWalletId);
                    final to = walletById(transfer.toWalletId);
                    if (from == null || to == null) {
                      return const SizedBox.shrink();
                    }

                    return Dismissible(
                      key: ValueKey(transfer.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedDelete01,
                          size: 22,
                        ),
                      ),
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) async {
                        await ref
                            .read(deleteTransferUseCaseProvider)
                            .call(transfer);
                      },
                      child: TransferItem(
                        transfer: transfer,
                        fromWallet: from,
                        toWallet: to,
                      ),
                    );
                  }),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('${AppStrings.errorPrefix}: $e')),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.transferUndoTitle),
        content: const Text(AppStrings.transferUndoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

  List<_TransferDayGroup> _groupByDate(List<WalletTransfer> transfers) {
    final map = <String, _TransferDayGroup>{};
    for (final transfer in transfers) {
      final key =
          '${transfer.date.year}-${transfer.date.month}-${transfer.date.day}';
      map.putIfAbsent(
        key,
        () => _TransferDayGroup(
          date: DateHelper.dateOnly(transfer.date),
          transfers: [],
        ),
      );
      map[key]!.transfers.add(transfer);
    }
    return map.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}

class _TransferDayGroup {
  final DateTime date;
  final List<WalletTransfer> transfers;

  _TransferDayGroup({required this.date, required this.transfers});
}

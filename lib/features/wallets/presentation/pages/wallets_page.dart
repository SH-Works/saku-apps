import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/wallet.dart';
import '../providers/wallet_provider.dart';
import 'add_wallet_page.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wallets),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01, size: 24),
            tooltip: AppStrings.addWallet,
            onPressed: () => _openAdd(context),
          ),
        ],
      ),
      body: walletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return _EmptyWallets(onAdd: () => _openAdd(context));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: wallets.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => _WalletListTile(wallet: wallets[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${AppStrings.errorPrefix}: $e')),
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
      builder: (_) => const AddWalletPage(),
    );
  }
}

// ---- Wallet list tile ----

class _WalletListTile extends ConsumerWidget {
  final Wallet wallet;
  const _WalletListTile({required this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletCurrentBalanceProvider(wallet.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(wallet.id),
      direction: wallet.isDefault
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedDelete01,
          color: Colors.white,
          size: 22,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) async {
        await ref.read(deleteWalletUseCaseProvider).call(wallet.id);
      },
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/wallets/${wallet.id}'),
          onLongPress: () => _showOptions(context, ref, isDark),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(wallet.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (wallet.isDefault) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Utama',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(balance),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteWallet),
        content: Text(AppStrings.deleteWalletConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              AppStrings.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            // Edit — available for ALL wallets
            ListTile(
              leading: const HugeIcon(
                icon: HugeIcons.strokeRoundedPencilEdit01,
                size: 22,
              ),
              title: const Text(AppStrings.editWallet),
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => AddWalletPage(wallet: wallet),
                );
              },
            ),
            if (!wallet.isDefault)
              ListTile(
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedStar,
                  size: 22,
                ),
                title: const Text(AppStrings.setAsDefault),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(setDefaultWalletUseCaseProvider)
                      .call(wallet.id);
                },
              ),
            if (!wallet.isDefault)
              ListTile(
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete01,
                  size: 22,
                  color: Colors.red,
                ),
                title: Text(
                  AppStrings.delete,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final ok = await _confirmDelete(context);
                  if (ok == true && context.mounted) {
                    await ref.read(deleteWalletUseCaseProvider).call(wallet.id);
                  }
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---- Empty state ----

class _EmptyWallets extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyWallets({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👛', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              AppStrings.noWallets,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.noWalletsSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text(AppStrings.addWallet),
            ),
          ],
        ),
      ),
    );
  }
}

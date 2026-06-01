import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/wallet.dart';
import '../providers/wallet_provider.dart';

class WalletCard extends ConsumerWidget {
  final Wallet wallet;
  final VoidCallback? onTap;
  final bool isSelected;

  const WalletCard({
    super.key,
    required this.wallet,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletCurrentBalanceProvider(wallet.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isSelected
        ? (isDark ? AppColors.white : AppColors.black)
        : Theme.of(context).colorScheme.surface;
    final textColor = isSelected
        ? (isDark ? AppColors.black : AppColors.white)
        : Theme.of(context).colorScheme.onSurface;
    final subColor = isSelected
        ? textColor.withOpacity(0.65)
        : AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.secondary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wallet.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 12),
            Text(
              wallet.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(balance),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (wallet.isDefault) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: subColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Utama',
                  style: TextStyle(fontSize: 10, color: subColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

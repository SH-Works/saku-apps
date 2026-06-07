import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../transaction/presentation/widgets/amount_input.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/providers/wallet_provider.dart';
import '../../domain/entities/wallet_transfer.dart';
import '../../domain/usecases/execute_transfer.dart';
import '../providers/transfer_provider.dart';

class TransferSheet extends ConsumerStatefulWidget {
  final String? defaultFromWalletId;

  const TransferSheet({super.key, this.defaultFromWalletId});

  @override
  ConsumerState<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<TransferSheet> {
  String? _fromWalletId;
  String? _toWalletId;
  int _amount = 0;
  DateTime _date = DateTime.now();
  final _notesCtrl = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _initWallets(List<Wallet> wallets) {
    if (_fromWalletId != null) return;
    if (wallets.isEmpty) return;

    final defaultId = widget.defaultFromWalletId;
    _fromWalletId = defaultId != null && wallets.any((w) => w.id == defaultId)
        ? defaultId
        : wallets.firstWhere((w) => w.isDefault, orElse: () => wallets.first).id;

    _toWalletId = wallets
        .where((w) => w.id != _fromWalletId)
        .map((w) => w.id)
        .firstOrNull;
  }

  void _swapWallets() {
    setState(() {
      final from = _fromWalletId;
      _fromWalletId = _toWalletId;
      _toWalletId = from;
      _error = null;
    });
  }

  Future<void> _pickWallet({required bool isFrom}) async {
    final wallets = ref.read(walletsStreamProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <Wallet>[],
        );
    if (wallets.length < 2) return;

    final selected = await showModalBottomSheet<String>(
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
                color: AppColors.secondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ...wallets.map((w) {
              return ListTile(
                leading: Text(w.icon, style: const TextStyle(fontSize: 24)),
                title: Text(w.name),
                subtitle: Text(
                  formatRupiah(ref.read(walletCurrentBalanceProvider(w.id))),
                ),
                onTap: () => Navigator.of(context).pop(w.id),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _fromWalletId = selected;
        if (_toWalletId == selected) {
          _toWalletId = wallets
              .where((w) => w.id != selected)
              .map((w) => w.id)
              .firstOrNull;
        }
      } else {
        _toWalletId = selected;
        if (_fromWalletId == selected) {
          _fromWalletId = wallets
              .where((w) => w.id != selected)
              .map((w) => w.id)
              .firstOrNull;
        }
      }
      _error = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (_fromWalletId == null || _toWalletId == null) return;

    if (_fromWalletId == _toWalletId) {
      setState(() => _error = AppStrings.transferDifferentWallets);
      return;
    }
    if (_amount <= 0) {
      setState(() => _error = AppStrings.transferEnterAmount);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final transfer = WalletTransfer(
      id: const Uuid().v4(),
      fromWalletId: _fromWalletId!,
      toWalletId: _toWalletId!,
      amount: _amount,
      date: _date,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(executeTransferUseCaseProvider).call(transfer);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.transferSuccess),
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on InsufficientBalanceException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;

    return walletsAsync.when(
      data: (wallets) {
        _initWallets(wallets);
        if (wallets.length < 2) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppStrings.transferNeedTwoWallets,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.cancel),
                ),
              ],
            ),
          );
        }

        final fromWallet =
            wallets.where((w) => w.id == _fromWalletId).firstOrNull;
        final toWallet = wallets.where((w) => w.id == _toWalletId).firstOrNull;

        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.transfer,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedCancel01,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        _SectionLabel(text: AppStrings.transferFrom, color: fg),
                        const SizedBox(height: 8),
                        if (fromWallet != null)
                          _WalletPickerTile(
                            wallet: fromWallet,
                            balance: ref.watch(
                              walletCurrentBalanceProvider(fromWallet.id),
                            ),
                            onTap: () => _pickWallet(isFrom: true),
                          ),
                        const SizedBox(height: 12),
                        Center(
                          child: Material(
                            color: isDark
                                ? AppColors.darkSurfaceAlt
                                : AppColors.lightSurface,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _swapWallets,
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: Text('⇄',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionLabel(text: AppStrings.transferTo, color: fg),
                        const SizedBox(height: 8),
                        if (toWallet != null)
                          _WalletPickerTile(
                            wallet: toWallet,
                            balance: ref.watch(
                              walletCurrentBalanceProvider(toWallet.id),
                            ),
                            onTap: () => _pickWallet(isFrom: false),
                          ),
                        const SizedBox(height: 20),
                        AmountInput(
                          amount: _amount,
                          onChanged: (v) => setState(() {
                            _amount = v;
                            _error = null;
                          }),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedCalendar01,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DateHelper.formatFullDate(_date),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _notesCtrl,
                          decoration: const InputDecoration(
                            hintText: AppStrings.transferNotesHint,
                          ),
                          maxLines: 1,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saving ? null : _submit,
                          child: _saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(AppStrings.transferAction),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text('${AppStrings.errorPrefix}: $e'),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: color.withValues(alpha: 0.55),
      ),
    );
  }
}

class _WalletPickerTile extends StatelessWidget {
  final Wallet wallet;
  final int balance;
  final VoidCallback onTap;

  const _WalletPickerTile({
    required this.wallet,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(wallet.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                icon: HugeIcons.strokeRoundedArrowDown01,
                size: 18,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

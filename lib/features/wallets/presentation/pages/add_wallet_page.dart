import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/wallet.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_icon_picker.dart';

class AddWalletPage extends ConsumerStatefulWidget {
  /// Pass an existing [wallet] to open in edit mode.
  final Wallet? wallet;

  const AddWalletPage({super.key, this.wallet});

  bool get isEdit => wallet != null;

  @override
  ConsumerState<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends ConsumerState<AddWalletPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _balanceCtrl;
  late String _selectedIcon;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final w = widget.wallet;
    _nameCtrl = TextEditingController(text: w?.name ?? '');
    _balanceCtrl =
        TextEditingController(text: w != null ? '${w.seedBalance}' : '0');
    _selectedIcon = w?.icon ?? '💵';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _balanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _snack(AppStrings.walletNameRequired);
      return;
    }
    final seedBalance =
        int.tryParse(_balanceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    setState(() => _saving = true);
    try {
      if (widget.isEdit) {
        final updated = widget.wallet!.copyWith(
          name: name,
          icon: _selectedIcon,
          seedBalance: seedBalance,
        );
        await ref.read(updateWalletUseCaseProvider).call(updated);
      } else {
        final wallet = buildWallet(
          name: name,
          icon: _selectedIcon,
          seedBalance: seedBalance,
        );
        await ref.read(addWalletUseCaseProvider).call(wallet);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _snack('${AppStrings.failedToSave}: $e');
      }
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final title = widget.isEdit ? AppStrings.editWallet : AppStrings.addWallet;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.cancel),
                ),
                Text(title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 64),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(text: AppStrings.walletIcon, color: fg),
                  const SizedBox(height: 8),
                  WalletIconPicker(
                    selected: _selectedIcon,
                    onSelected: (icon) => setState(() => _selectedIcon = icon),
                  ),
                  const SizedBox(height: 20),
                  _Label(text: AppStrings.walletName, color: fg),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      hintText: AppStrings.walletNameHint,
                      prefixText: '$_selectedIcon  ',
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  _Label(text: AppStrings.walletInitialBalance, color: fg),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.walletInitialBalanceHint,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _balanceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: formatRupiah(0),
                      prefixText: 'Rp ',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(AppStrings.save),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  const _Label({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.65),
          letterSpacing: 0.4,
        ),
      );
}

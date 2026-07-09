// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/providers/wallet_provider.dart';
import '../../domain/entities/smoke_settings.dart';
import '../providers/smoke_provider.dart';

class SmokeSettingsPage extends ConsumerStatefulWidget {
  const SmokeSettingsPage({super.key});

  @override
  ConsumerState<SmokeSettingsPage> createState() => _SmokeSettingsPageState();
}

class _SmokeSettingsPageState extends ConsumerState<SmokeSettingsPage> {
  late int _cigarettesPerPack;
  late int _pricePerPack;
  late int _dailyLimit;
  late bool _notifyAt80;
  late bool _notifyAtLimit;
  late bool _autoLogExpense;
  late String _walletId;
  bool _saving = false;
  bool _initialized = false;

  void _initFrom(SmokeSettings? settings) {
    if (_initialized) return;
    final s = settings ?? SmokeSettings.defaults();
    _cigarettesPerPack = s.cigarettesPerPack;
    _pricePerPack = s.pricePerPack;
    _dailyLimit = s.dailyLimit;
    _notifyAt80 = s.notifyAt80Percent;
    _notifyAtLimit = s.notifyAtLimit;
    _autoLogExpense = s.autoLogExpense;
    _walletId = s.expenseWalletId;
    _initialized = true;
  }

  int get _pricePerCigarette =>
      _cigarettesPerPack > 0 ? _pricePerPack ~/ _cigarettesPerPack : 0;

  Future<void> _save(SmokeSettings? current) async {
    setState(() => _saving = true);
    final updated = (current ?? SmokeSettings.defaults()).copyWith(
      cigarettesPerPack: _cigarettesPerPack,
      pricePerPack: _pricePerPack,
      dailyLimit: _dailyLimit,
      notifyAt80Percent: _notifyAt80,
      notifyAtLimit: _notifyAtLimit,
      autoLogExpense: _autoLogExpense,
      expenseWalletId: _walletId,
    );
    await ref.read(updateSmokeSettingsProvider).call(updated);
    ref.invalidate(smokeSettingsProvider);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.save)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(smokeSettingsProvider);
    final wallets = ref.watch(walletsStreamProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <Wallet>[],
        );

    return settingsAsync.when(
      data: (settings) {
        _initFrom(settings);
        if (_walletId.isEmpty && wallets.isNotEmpty) {
          final def = wallets.firstWhere(
            (w) => w.isDefault,
            orElse: () => wallets.first,
          );
          _walletId = def.id;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.smokeSettings),
            toolbarHeight: 64,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              _SectionHeader(label: AppStrings.smokeMyCigarette),
              _Section(
                children: [
                  _NumberField(
                    label: AppStrings.smokePerPack,
                    value: _cigarettesPerPack,
                    onChanged: (v) =>
                        setState(() => _cigarettesPerPack = v),
                  ),
                  const Divider(height: 1, indent: 16),
                  _NumberField(
                    label: AppStrings.smokePricePerPack,
                    value: _pricePerPack,
                    prefix: 'Rp ',
                    onChanged: (v) => setState(() => _pricePerPack = v),
                  ),
                  const Divider(height: 1, indent: 16),
                  ListTile(
                    title: const Text(AppStrings.smokePricePerCigarette),
                    trailing: Text(
                      formatRupiah(_pricePerCigarette),
                      style: const TextStyle(color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionHeader(label: AppStrings.smokeDailyLimitLabel),
              _Section(
                children: [
                  _NumberField(
                    label: AppStrings.smokeDailyLimitLabel,
                    value: _dailyLimit,
                    onChanged: (v) => setState(() => _dailyLimit = v),
                  ),
                  SwitchListTile(
                    title: const Text(AppStrings.smokeNotify80),
                    value: _notifyAt80,
                    activeColor: AppColors.black,
                    onChanged: (v) => setState(() => _notifyAt80 = v),
                  ),
                  SwitchListTile(
                    title: const Text(AppStrings.smokeNotifyLimit),
                    value: _notifyAtLimit,
                    activeColor: AppColors.black,
                    onChanged: (v) => setState(() => _notifyAtLimit = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionHeader(label: AppStrings.smokeFinanceIntegration),
              _Section(
                children: [
                  SwitchListTile(
                    title: const Text(AppStrings.smokeAutoLogExpense),
                    value: _autoLogExpense,
                    activeColor: AppColors.black,
                    onChanged: (v) => setState(() => _autoLogExpense = v),
                  ),
                  if (_autoLogExpense && wallets.isNotEmpty) ...[
                    const Divider(height: 1, indent: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: wallets.map((w) {
                          final selected = w.id == _walletId;
                          return GestureDetector(
                            onTap: () => setState(() => _walletId = w.id),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.black
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? Colors.transparent
                                      : AppColors.secondary.withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(w.icon),
                                  const SizedBox(width: 6),
                                  Text(
                                    w.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? AppColors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Text(
                      AppStrings.smokeExpenseInfo,
                      style: TextStyle(fontSize: 12, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : () => _save(settings),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AppStrings.smokeSaveSettings),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final int value;
  final String? prefix;
  final ValueChanged<int> onChanged;

  const _NumberField({
    required this.label,
    required this.value,
    this.prefix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: SizedBox(
        width: 100,
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          controller: TextEditingController(text: '$value')
            ..selection = TextSelection.collapsed(offset: '$value'.length),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            prefixText: prefix,
          ),
          onChanged: (v) {
            final parsed = int.tryParse(v.replaceAll('.', ''));
            if (parsed != null) onChanged(parsed);
          },
        ),
      ),
    );
  }
}

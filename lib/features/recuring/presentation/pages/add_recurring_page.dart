// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/widgets/amount_input.dart';
import '../../../transaction/presentation/widgets/category_picker.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/providers/wallet_provider.dart';
import '../../domain/entities/recuring_transaction.dart';
import '../providers/recuring_provider.dart';

class AddRecurringPage extends ConsumerStatefulWidget {
  const AddRecurringPage({super.key});

  @override
  ConsumerState<AddRecurringPage> createState() => _AddRecurringPageState();
}

class _AddRecurringPageState extends ConsumerState<AddRecurringPage> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  int _amount = 0;
  String? _categoryId;
  String _walletId = 'default';
  RecuringFrequency _frequency = RecuringFrequency.monthly;
  int _dayOfMonth = DateTime.now().day.clamp(1, 28);
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _hasEndDate = false;
  bool _saving = false;

  @override
  void dispose() {
    _labelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wallets = ref.read(getAllWalletsUseCaseProvider).call();
    if (wallets.isNotEmpty) {
      final def = wallets.firstWhere(
        (w) => w.isDefault,
        orElse: () => wallets.first,
      );
      _walletId = def.id;
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _dayOfMonth = picked.day.clamp(1, 28);
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      _showSnack(AppStrings.recuringLabelRequired);
      return;
    }
    if (_amount <= 0) {
      _showSnack(AppStrings.enterAmount);
      return;
    }
    if (_categoryId == null) {
      _showSnack(AppStrings.selectCategory);
      return;
    }

    setState(() => _saving = true);

    final recurring = RecuringTransaction(
      id: const Uuid().v4(),
      type: _type,
      amount: _amount,
      categoryId: _categoryId!,
      walletId: _walletId,
      frequency: _frequency,
      dayOfMonth: _dayOfMonth,
      startDate: _startDate,
      endDate: _hasEndDate ? _endDate : null,
      lastProcessedDate: null,
      isActive: true,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      label: label,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(addRecurringProvider).call(recurring);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _showSnack('${AppStrings.failedToSave}: $e');
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool get _showDayOfMonth =>
      _frequency == RecuringFrequency.monthly ||
      _frequency == RecuringFrequency.yearly;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final wallets = ref.watch(walletsStreamProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <Wallet>[],
        );

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.cancel),
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.recuringAdd,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 64),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    _SectionLabel(text: AppStrings.recuringLabel, color: fg),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.recuringLabelHint,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<TransactionType>(
                        segments: const [
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text(
                              style: TextStyle(fontSize: 14),
                              AppStrings.expense,
                            ),
                          ),
                          ButtonSegment(
                            value: TransactionType.income,
                            label: Text(
                              style: TextStyle(fontSize: 14),
                              AppStrings.income,
                            ),
                          ),
                        ],
                        selected: {_type},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            setState(() => _type = s.first),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AmountInput(
                      amount: _amount,
                      onChanged: (v) => setState(() => _amount = v),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(text: AppStrings.category, color: fg),
                    const SizedBox(height: 8),
                    CategoryPicker(
                      selectedCategoryId: _categoryId,
                      onSelected: (id) => setState(() => _categoryId = id),
                    ),
                    if (wallets.length > 1) ...[
                      const SizedBox(height: 20),
                      _SectionLabel(text: AppStrings.wallet, color: fg),
                      const SizedBox(height: 8),
                      _WalletPicker(
                        wallets: wallets,
                        selectedId: _walletId,
                        onSelected: (id) => setState(() => _walletId = id),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _SectionLabel(text: AppStrings.recuringFrequency, color: fg),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<RecuringFrequency>(
                        segments: const [
                          ButtonSegment(
                            value: RecuringFrequency.daily,
                            label: Text(AppStrings.recuringDaily),
                          ),
                          ButtonSegment(
                            value: RecuringFrequency.weekly,
                            label: Text(AppStrings.recuringWeekly),
                          ),
                          ButtonSegment(
                            value: RecuringFrequency.monthly,
                            label: Text(AppStrings.recuringMonthly),
                          ),
                          ButtonSegment(
                            value: RecuringFrequency.yearly,
                            label: Text(AppStrings.recuringYearly),
                          ),
                        ],
                        selected: {_frequency},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            setState(() => _frequency = s.first),
                      ),
                    ),
                    if (_showDayOfMonth) ...[
                      const SizedBox(height: 20),
                      _SectionLabel(
                        text: AppStrings.recuringDayOfMonth,
                        color: fg,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _dayOfMonth > 1
                                ? () => setState(() => _dayOfMonth--)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$_dayOfMonth',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: _dayOfMonth < 28
                                ? () => setState(() => _dayOfMonth++)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    _SectionLabel(text: AppStrings.recuringStartDate, color: fg),
                    const SizedBox(height: 8),
                    _DateTile(
                      label: AppStrings.date,
                      date: _startDate,
                      onTap: _pickStartDate,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        AppStrings.recuringHasEndDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: fg.withOpacity(0.85),
                        ),
                      ),
                      value: _hasEndDate,
                      onChanged: (v) => setState(() {
                        _hasEndDate = v;
                        if (!v) _endDate = null;
                      }),
                    ),
                    if (_hasEndDate) ...[
                      const SizedBox(height: 8),
                      _DateTile(
                        label: AppStrings.recuringEndDate,
                        date: _endDate ?? _startDate,
                        onTap: _pickEndDate,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _SectionLabel(text: AppStrings.notes, color: fg),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.optionalNotes,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(AppStrings.save),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(0.65),
        letterSpacing: 0.4,
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                DateHelper.formatFullDate(date),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
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
    );
  }
}

class _WalletPicker extends StatelessWidget {
  final List<Wallet> wallets;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _WalletPicker({
    required this.wallets,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: wallets.map((w) {
        final isSelected = w.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(w.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.secondary.withOpacity(0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(w.icon, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  w.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

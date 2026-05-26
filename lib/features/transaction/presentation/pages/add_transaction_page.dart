// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_picker.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  TransactionType _type = TransactionType.expense;
  int _amount = 0;
  String? _categoryId;
  DateTime _date = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      _showSnack(AppStrings.enterAmount);
      return;
    }
    if (_categoryId == null) {
      _showSnack(AppStrings.selectCategory);
      return;
    }
    setState(() => _saving = true);

    final tx = Transaction(
      id: const Uuid().v4(),
      type: _type,
      amount: _amount,
      categoryId: _categoryId!,
      date: _date,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(addTransactionUseCaseProvider).call(tx);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _showSnack('${AppStrings.failedToSave}: $e');
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
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
                    Text(
                      AppStrings.newTransaction,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 64),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
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
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 20),
                    _SectionLabel(text: AppStrings.date, color: fg),
                    const SizedBox(height: 8),
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
                            const Icon(Icons.calendar_today_outlined, size: 18),
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
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel(text: AppStrings.notes, color: fg),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.optionalNotes,
                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
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
          ),
        );
      },
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

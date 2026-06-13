import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/categories.dart';
import '../../../transaction/presentation/widgets/amount_input.dart';
import '../../../transaction/presentation/widgets/month_selector.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/add_budget.dart';
import '../providers/budget_provider.dart';

const _incomeCategoryIds = {'salary', 'bonus'};

List<TransactionCategory> get kExpenseCategories => kCategories
    .where((c) => !_incomeCategoryIds.contains(c.id))
    .toList();

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  String? _categoryId;
  int _limitAmount = 0;
  late DateTime _selectedMonth;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  Future<void> _save() async {
    if (_categoryId == null) {
      setState(() => _error = AppStrings.selectCategory);
      return;
    }
    if (_limitAmount <= 0) {
      setState(() => _error = AppStrings.budgetEnterLimit);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final budget = Budget(
      id: const Uuid().v4(),
      categoryId: _categoryId!,
      limitAmount: _limitAmount,
      month: _selectedMonth.month,
      year: _selectedMonth.year,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(addBudgetProvider).call(budget);
      if (mounted) Navigator.of(context).pop();
    } on DuplicateBudgetException catch (e) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.white : AppColors.black;
    final key = (year: _selectedMonth.year, month: _selectedMonth.month);
    final existingBudgets = ref.watch(budgetsByMonthProvider(key)).maybeWhen(
          data: (list) => list.map((b) => b.categoryId).toSet(),
          orElse: () => <String>{},
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
                  color: AppColors.secondary.withValues(alpha: 0.4),
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
                        AppStrings.setBudget,
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
                    Text(
                      AppStrings.category,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fg.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ExpenseCategoryGrid(
                      selectedCategoryId: _categoryId,
                      disabledCategoryIds: existingBudgets,
                      onSelected: (id) => setState(() {
                        _categoryId = id;
                        _error = null;
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.budgetLimit,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fg.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AmountInput(
                      amount: _limitAmount,
                      onChanged: (v) => setState(() {
                        _limitAmount = v;
                        _error = null;
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.budgetMonth,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fg.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MonthSelector(
                      selected: _selectedMonth,
                      onChanged: (d) => setState(() {
                        _selectedMonth = d;
                        _categoryId = null;
                      }),
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
                          : Text(AppStrings.setBudget),
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

class _ExpenseCategoryGrid extends StatelessWidget {
  final String? selectedCategoryId;
  final Set<String> disabledCategoryIds;
  final ValueChanged<String> onSelected;

  const _ExpenseCategoryGrid({
    required this.selectedCategoryId,
    required this.disabledCategoryIds,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final selectedBg = isDark ? AppColors.white : AppColors.black;
    final selectedFg = isDark ? AppColors.black : AppColors.white;
    final defaultFg = isDark ? AppColors.white : AppColors.black;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: kExpenseCategories.length,
      itemBuilder: (context, index) {
        final cat = kExpenseCategories[index];
        final isSelected = cat.id == selectedCategoryId;
        final isDisabled = disabledCategoryIds.contains(cat.id);

        return Material(
          color: isSelected ? selectedBg : defaultBg,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isDisabled ? null : () => onSelected(cat.id),
            child: Opacity(
              opacity: isDisabled ? 0.35 : 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: cat.icon,
                      color: isSelected ? selectedFg : defaultFg,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat.label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? selectedFg : defaultFg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

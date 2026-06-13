import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../../transaction/presentation/widgets/month_selector.dart';
import '../providers/budget_provider.dart';
import '../widgets/budget_progress_card.dart';
import 'add_budget_page.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddBudgetPage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedMonthProvider);
    final key = (year: selected.year, month: selected.month);
    final progressAsync = ref.watch(budgetProgressProvider(key));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.budget),
        toolbarHeight: 64,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: progressAsync.when(
        data: (progressList) {
          if (progressList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedPieChart01,
                      size: 56,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noBudgets,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _openAdd(context),
                      child: Text(AppStrings.setBudget),
                    ),
                  ],
                ),
              ),
            );
          }

          final totalLimit = progressList.fold<int>(
            0,
            (sum, p) => sum + p.budget.limitAmount,
          );
          final totalSpent = progressList.fold<int>(
            0,
            (sum, p) => sum + p.spentAmount,
          );
          final totalRemaining = totalLimit - totalSpent;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              MonthSelector(
                selected: selected,
                onChanged: (d) =>
                    ref.read(selectedMonthProvider.notifier).state = d,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCol(
                        label: AppStrings.budgetTotalLimit,
                        value: formatRupiah(totalLimit),
                      ),
                    ),
                    Expanded(
                      child: _SummaryCol(
                        label: AppStrings.budgetTotalSpent,
                        value: formatRupiah(totalSpent),
                      ),
                    ),
                    Expanded(
                      child: _SummaryCol(
                        label: AppStrings.budgetRemaining,
                        value: formatRupiah(totalRemaining),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...progressList.map(
                (p) => BudgetProgressCard(
                  progress: p,
                  onDelete: () => ref
                      .read(deleteBudgetProvider)
                      .call(p.budget.id),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('${AppStrings.errorPrefix}: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        child: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01, size: 28),
      ),
    );
  }
}

class _SummaryCol extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.secondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
